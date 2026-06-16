import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:link_saver/features/bookmarks/data/datasource/bookmark_local_datasource.dart';
import 'package:link_saver/features/bookmarks/data/mapper/bookmark_mapper.dart';
import 'package:link_saver/core/database/app_database.dart' as db;

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl(this.localDataSource);

  @override
  Future<List<Bookmark>> getBookmarks({
    bool? isArchived,
    bool? isFavorite,
    String? category,
    String? folderId,
    List<String>? tags,
  }) async {
    final rows = await localDataSource.getBookmarks(
      isArchived: isArchived,
      isFavorite: isFavorite,
      category: category,
      folderId: folderId != null ? int.tryParse(folderId) : null,
    );
    return rows.map(BookmarkMapper.toEntity).toList();
  }

  @override
  Future<Bookmark?> getBookmarkById(String id) async {
    final row = await localDataSource.getBookmarkById(int.parse(id));
    return row != null ? BookmarkMapper.toEntity(row) : null;
  }

  @override
  Stream<Bookmark?> watchBookmark(String id) {
    return localDataSource.watchBookmarkById(int.parse(id)).map((row) => row != null ? BookmarkMapper.toEntity(row) : null);
  }

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {
    final companion = BookmarkMapper.toCompanion(bookmark);
    final tags = BookmarkMapper.toTagsList(bookmark);
    await localDataSource.saveBookmark(companion, tags);
  }

  @override
  Future<void> deleteBookmark(String id) async {
    await localDataSource.deleteBookmark(int.parse(id));
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final bookmark = await getBookmarkById(id);
    if (bookmark != null) {
      await saveBookmark(bookmark.copyWith(
        isFavorite: !bookmark.isFavorite,
        updatedAt: DateTime.now(),
      ));
    }
  }

  @override
  Future<void> toggleArchive(String id) async {
    final bookmark = await getBookmarkById(id);
    if (bookmark != null) {
      await saveBookmark(bookmark.copyWith(
        isArchived: !bookmark.isArchived,
        updatedAt: DateTime.now(),
      ));
    }
  }

  @override
  Future<List<Bookmark>> searchBookmarks(String query) async {
    final rows = await localDataSource.searchBookmarks(query);
    return rows.map(BookmarkMapper.toEntity).toList();
  }

  // ── Folders ──────────────────────────────────────────────
  Future<List<db.Folder>> getFolders() async {
    return localDataSource.getFolders();
  }

  Future<void> saveFolder(String name, {int? parentId}) async {
    await localDataSource.saveFolder(
      db.FoldersCompanion.insert(name: name),
    );
  }

  Future<void> deleteFolder(int id) async {
    await localDataSource.deleteFolder(id);
  }

  Future<int> getOrCreateFolder(String name) async {
    return await localDataSource.getOrCreateFolder(name);
  }

  Future<bool> urlExists(String url) async {
    return await localDataSource.urlExists(url);
  }

  @override
  Future<Bookmark?> getBookmarkByUrl(String url) async {
    final row = await localDataSource.getBookmarkByUrl(url);
    return row != null ? BookmarkMapper.toEntity(row) : null;
  }
}
