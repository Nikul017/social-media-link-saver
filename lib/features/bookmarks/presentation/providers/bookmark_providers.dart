import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:link_saver/core/database/app_database.dart' hide Bookmark;
import 'package:link_saver/features/bookmarks/data/datasource/bookmark_local_datasource.dart';
import 'package:link_saver/features/bookmarks/data/repository/bookmark_repository_impl.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/domain/repository/bookmark_repository.dart';

part 'bookmark_providers.g.dart';

@riverpod
BookmarkLocalDataSource bookmarkLocalDataSource(BookmarkLocalDataSourceRef ref) {
  return BookmarkLocalDataSourceImpl(ref.watch(databaseProvider));
}

@riverpod
BookmarkRepository bookmarkRepository(BookmarkRepositoryRef ref) {
  final localDataSource = ref.watch(bookmarkLocalDataSourceProvider);
  return BookmarkRepositoryImpl(localDataSource);
}

@riverpod
class SelectedFolderId extends _$SelectedFolderId {
  @override
  String? build() => null;

  void setFolder(String? id) => state = id;
}

@riverpod
class BookmarkList extends _$BookmarkList {
  @override
  FutureOr<List<Bookmark>> build() {
    final folderId = ref.watch(selectedFolderIdProvider);
    return ref.watch(bookmarkRepositoryProvider).getBookmarks(
      isArchived: false,
      folderId: folderId,
    );
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(bookmarkRepositoryProvider).saveBookmark(bookmark);
      return ref.read(bookmarkRepositoryProvider).getBookmarks(isArchived: false);
    });
  }

  Future<void> deleteBookmark(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(bookmarkRepositoryProvider).deleteBookmark(id);
      return ref.read(bookmarkRepositoryProvider).getBookmarks(isArchived: false);
    });
  }

  Future<void> toggleFavorite(String id) async {
    await ref.read(bookmarkRepositoryProvider).toggleFavorite(id);
    ref.invalidateSelf();
  }
}

@riverpod
class FolderList extends _$FolderList {
  @override
  FutureOr<List<Folder>> build() {
    final repo = ref.watch(bookmarkRepositoryProvider) as BookmarkRepositoryImpl;
    return repo.getFolders();
  }

  Future<void> addFolder(String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bookmarkRepositoryProvider) as BookmarkRepositoryImpl;
      await repo.saveFolder(name);
      return repo.getFolders();
    });
  }

  Future<void> editFolder(int id, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bookmarkRepositoryProvider) as BookmarkRepositoryImpl;
      await repo.localDataSource.saveFolder(FoldersCompanion(
        id: Value(id),
        name: Value(name),
      ));
      return repo.getFolders();
    });
  }

  Future<void> deleteFolder(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bookmarkRepositoryProvider) as BookmarkRepositoryImpl;
      await repo.deleteFolder(id);
      
      // If the deleted folder was the active one, clear the filter
      final selectedFolderId = ref.read(selectedFolderIdProvider);
      if (selectedFolderId == id.toString()) {
        ref.read(selectedFolderIdProvider.notifier).setFolder(null);
      }
      
      return repo.getFolders();
    });
  }
}

@riverpod
Stream<Bookmark?> bookmarkStream(BookmarkStreamRef ref, String id) {
  return ref.watch(bookmarkRepositoryProvider).watchBookmark(id);
}
