import 'package:drift/drift.dart';
import 'package:link_saver/core/database/app_database.dart';

abstract class BookmarkLocalDataSource {
  Future<List<BookmarkWithTags>> getBookmarks({
    bool? isArchived,
    bool? isFavorite,
    String? category,
    int? folderId,
  });

  Future<BookmarkWithTags?> getBookmarkById(int id);
  Stream<BookmarkWithTags?> watchBookmarkById(int id);

  Future<void> saveBookmark(BookmarksCompanion bookmark, List<String> tags);

  Future<void> deleteBookmark(int id);

  Future<List<BookmarkWithTags>> searchBookmarks(String query);

  Future<List<Folder>> getFolders();
  Future<void> saveFolder(FoldersCompanion folder);
  Future<void> deleteFolder(int id);
  Future<int> getOrCreateFolder(String name);
  /// Returns true if a bookmark with the given URL already exists.
  Future<bool> urlExists(String url);
  Future<BookmarkWithTags?> getBookmarkByUrl(String url);
}

/// Holds a Drift Bookmark row + its resolved tag names
class BookmarkWithTags {
  final Bookmark bookmark;
  final List<String> tags;

  const BookmarkWithTags({required this.bookmark, required this.tags});
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  final AppDatabase db;

  BookmarkLocalDataSourceImpl(this.db);

  // ────────────────────────────────────────────────────
  // Private: load tags for a list of bookmark IDs
  // ────────────────────────────────────────────────────
  Future<Map<int, List<String>>> _loadTagsForIds(List<int> ids) async {
    if (ids.isEmpty) return {};

    // JOIN BookmarkTags ↔ Tags for given bookmark IDs
    final rows = await (db.select(db.bookmarkTags).join([
      innerJoin(db.tags, db.tags.id.equalsExp(db.bookmarkTags.tagId)),
    ])
          ..where(db.bookmarkTags.bookmarkId.isIn(ids)))
        .get();

    final result = <int, List<String>>{};
    for (final row in rows) {
      final bmId = row.read(db.bookmarkTags.bookmarkId)!;
      final tagName = row.read(db.tags.name)!;
      result.putIfAbsent(bmId, () => []).add(tagName);
    }
    return result;
  }

  Future<List<BookmarkWithTags>> _attachTags(List<Bookmark> bookmarks) async {
    final ids = bookmarks.map((b) => b.id).toList();
    final tagsMap = await _loadTagsForIds(ids);
    return bookmarks
        .map((b) => BookmarkWithTags(bookmark: b, tags: tagsMap[b.id] ?? []))
        .toList();
  }

  // ────────────────────────────────────────────────────
  // Public API
  // ────────────────────────────────────────────────────

  @override
  Future<List<BookmarkWithTags>> getBookmarks({
    bool? isArchived,
    bool? isFavorite,
    String? category,
    int? folderId,
  }) async {
    final query = db.select(db.bookmarks);

    if (isArchived != null) query.where((t) => t.isArchived.equals(isArchived));
    if (isFavorite != null) query.where((t) => t.isFavorite.equals(isFavorite));
    if (category != null) query.where((t) => t.category.equals(category));
    if (folderId != null) query.where((t) => t.folderId.equals(folderId));

    query.orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);

    final rows = await query.get();
    return _attachTags(rows);
  }

  @override
  Future<BookmarkWithTags?> getBookmarkById(int id) async {
    final row = await (db.select(db.bookmarks)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final tags = await _loadTagsForIds([id]);
    return BookmarkWithTags(bookmark: row, tags: tags[id] ?? []);
  }

  @override
  Stream<BookmarkWithTags?> watchBookmarkById(int id) {
    return (db.select(db.bookmarks)..where((t) => t.id.equals(id))).watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      final tags = await _loadTagsForIds([id]);
      return BookmarkWithTags(bookmark: row, tags: tags[id] ?? []);
    });
  }

  @override
  Future<void> saveBookmark(BookmarksCompanion bookmark, List<String> tags) async {
    // 1) Upsert main bookmark row
    final bookmarkId = await db.into(db.bookmarks).insertOnConflictUpdate(bookmark);

    // Use the returned id for new inserts, or parse from companion for updates
    final actualId = bookmark.id.present ? bookmark.id.value : bookmarkId;

    // 2) Delete existing tag associations for this bookmark
    await (db.delete(db.bookmarkTags)
          ..where((t) => t.bookmarkId.equals(actualId)))
        .go();

    // 3) Insert each tag
    for (final tagName in tags) {
      final clean = tagName.trim().toLowerCase();
      if (clean.isEmpty) continue;

      // Upsert tag into Tags table
      await db.into(db.tags).insertOnConflictUpdate(
            TagsCompanion.insert(name: clean),
          );

      // Get the tag ID
      final tag = await (db.select(db.tags)..where((t) => t.name.equals(clean))).getSingle();

      // Insert junction row
      await db.into(db.bookmarkTags).insertOnConflictUpdate(
            BookmarkTagsCompanion.insert(
              bookmarkId: actualId,
              tagId: tag.id,
            ),
          );
    }
  }

  @override
  Future<void> deleteBookmark(int id) async {
    await (db.delete(db.bookmarks)..where((t) => t.id.equals(id))).go();
    // BookmarkTags is deleted by CASCADE
  }

  @override
  Future<List<BookmarkWithTags>> searchBookmarks(String query) async {
    final rows = await (db.select(db.bookmarks)
          ..where((t) =>
              t.title.contains(query) |
              t.description.contains(query) |
              t.url.contains(query) |
              t.notes.contains(query))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
    return _attachTags(rows);
  }

  // ────────────────────────────────────────────────────
  // Folders
  // ────────────────────────────────────────────────────

  @override
  Future<List<Folder>> getFolders() async {
    return db.select(db.folders).get();
  }

  @override
  Future<void> saveFolder(FoldersCompanion folder) async {
    await db.into(db.folders).insertOnConflictUpdate(folder);
  }

  @override
  Future<void> deleteFolder(int id) async {
    await (db.delete(db.folders)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<int> getOrCreateFolder(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return -1;
    
    final existing = await (db.select(db.folders)..where((t) => t.name.equals(cleanName))).getSingleOrNull();
    if (existing != null) {
      return existing.id;
    }
    
    return await db.into(db.folders).insert(FoldersCompanion.insert(name: cleanName));
  }

  @override
  Future<bool> urlExists(String url) async {
    final row = await (db.select(db.bookmarks)
          ..where((t) => t.url.equals(url))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  @override
  Future<BookmarkWithTags?> getBookmarkByUrl(String url) async {
    final row = await (db.select(db.bookmarks)
          ..where((t) => t.url.equals(url))
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    final tags = await _loadTagsForIds([row.id]);
    return BookmarkWithTags(bookmark: row, tags: tags[row.id] ?? []);
  }
}
