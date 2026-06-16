import '../entities/bookmark.dart';

abstract class BookmarkRepository {
  Future<List<Bookmark>> getBookmarks({
    bool? isArchived,
    bool? isFavorite,
    String? category,
    String? folderId,
    List<String>? tags,
  });

  Future<Bookmark?> getBookmarkById(String id);
  Future<Bookmark?> getBookmarkByUrl(String url);
  Stream<Bookmark?> watchBookmark(String id);

  Future<void> saveBookmark(Bookmark bookmark);

  Future<void> deleteBookmark(String id);

  Future<void> toggleFavorite(String id);

  Future<void> toggleArchive(String id);

  Future<List<Bookmark>> searchBookmarks(String query);
}
