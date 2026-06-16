import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String id,
    required String url,
    required String title,
    String? description,
    String? thumbnailUrl,
    String? faviconUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? notes,
    List<String>? tags,
    String? category,
    String? folderId,
    @Default(false) bool isFavorite,
    @Default(false) bool isArchived,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);
}
