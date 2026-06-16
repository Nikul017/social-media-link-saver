import 'package:drift/drift.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart' as entity;
import 'package:link_saver/core/database/app_database.dart' as db;
import 'package:link_saver/features/bookmarks/data/datasource/bookmark_local_datasource.dart';

class BookmarkMapper {
  /// Convert a Drift Bookmark row + resolved tags → Domain Bookmark entity
  static entity.Bookmark toEntity(BookmarkWithTags bwt) {
    final model = bwt.bookmark;
    return entity.Bookmark(
      id: model.id.toString(),
      url: model.url,
      title: model.title,
      description: model.description,
      thumbnailUrl: model.thumbnailUrl,
      faviconUrl: model.faviconUrl,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      notes: model.notes,
      tags: bwt.tags.isEmpty ? null : bwt.tags,
      category: model.category,
      folderId: model.folderId?.toString(),
      isFavorite: model.isFavorite,
      isArchived: model.isArchived,
    );
  }

  /// Convert a Domain Bookmark entity → Drift BookmarksCompanion (main table only)
  static db.BookmarksCompanion toCompanion(entity.Bookmark e) {
    return db.BookmarksCompanion(
      id: e.id.isNotEmpty && e.id != '0'
          ? Value(int.parse(e.id))
          : const Value.absent(),
      url: Value(e.url),
      title: Value(e.title),
      description: Value(e.description),
      thumbnailUrl: Value(e.thumbnailUrl),
      faviconUrl: Value(e.faviconUrl),
      createdAt: Value(e.createdAt),
      updatedAt: Value(e.updatedAt),
      notes: Value(e.notes),
      category: Value(e.category),
      folderId: e.folderId != null
          ? Value(int.tryParse(e.folderId!))
          : const Value.absent(),
      isFavorite: Value(e.isFavorite),
      isArchived: Value(e.isArchived),
    );
  }

  /// Extract tags list from domain entity (never null → always a List)
  static List<String> toTagsList(entity.Bookmark e) {
    return e.tags ?? [];
  }
}
