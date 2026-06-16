import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';

part 'duplicate_providers.g.dart';

@riverpod
Future<Map<String, List<Bookmark>>> duplicateBookmarks(DuplicateBookmarksRef ref) async {
  final repo = ref.watch(bookmarkRepositoryProvider);
  final bookmarks = await repo.getBookmarks(); // Get all active bookmarks across folders
  
  final groups = <String, List<Bookmark>>{};
  for (final bookmark in bookmarks) {
    final normalized = normalizeUrl(bookmark.url);
    groups.putIfAbsent(normalized, () => []).add(bookmark);
  }
  
  final duplicates = <String, List<Bookmark>>{};
  groups.forEach((url, list) {
    if (list.length > 1) {
      duplicates[url] = list;
    }
  });
  
  return duplicates;
}

@riverpod
class DuplicateFinderNotifier extends _$DuplicateFinderNotifier {
  @override
  FutureOr<void> build() => null;

  Future<void> deleteBookmarks(List<String> ids) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bookmarkRepositoryProvider);
      for (final id in ids) {
        await repo.deleteBookmark(id);
      }
      // Refresh home grids, category counts, folders lists, and duplicate page state
      ref.invalidate(bookmarkListProvider);
      ref.invalidate(folderListProvider);
      ref.invalidate(duplicateBookmarksProvider);
    });
  }

  Future<void> autoCleanAll(Map<String, List<Bookmark>> duplicateGroups) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bookmarkRepositoryProvider);
      final idsToDelete = <String>[];
      
      for (final group in duplicateGroups.values) {
        if (group.length <= 1) continue;
        
        // Sort by creation date ascending (oldest first)
        final sorted = List<Bookmark>.from(group)
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        
        // Keep the oldest (sorted[0]), and add all others (sorted[1..]) to delete list
        for (var i = 1; i < sorted.length; i++) {
          idsToDelete.add(sorted[i].id);
        }
      }
      
      for (final id in idsToDelete) {
        await repo.deleteBookmark(id);
      }
      
      ref.invalidate(bookmarkListProvider);
      ref.invalidate(folderListProvider);
      ref.invalidate(duplicateBookmarksProvider);
    });
  }

  Future<int> resolveShortLinks() async {
    state = const AsyncValue.loading();
    int updatedCount = 0;
    
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bookmarkRepositoryProvider);
      final bookmarks = await repo.getBookmarks();
      
      final shortBookmarks = bookmarks.where((b) => b.url.contains('t.co')).toList();
      if (shortBookmarks.isEmpty) return;
      
      const chunkSize = 5;
      for (var i = 0; i < shortBookmarks.length; i += chunkSize) {
        final chunk = shortBookmarks.skip(i).take(chunkSize).toList();
        await Future.wait(chunk.map((bookmark) async {
          final resolved = await resolveRedirect(bookmark.url);
          if (resolved != bookmark.url) {
            final updated = bookmark.copyWith(
              url: resolved,
              updatedAt: DateTime.now(),
            );
            await repo.saveBookmark(updated);
            updatedCount++;
          }
        }));
      }
      
      ref.invalidate(bookmarkListProvider);
      ref.invalidate(folderListProvider);
      ref.invalidate(duplicateBookmarksProvider);
    });
    
    return updatedCount;
  }
}

Future<String> resolveRedirect(String url) async {
  if (!url.contains('t.co')) return url;
  try {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 5);
    final request = await client.getUrl(Uri.parse(url));
    request.followRedirects = false;
    final response = await request.close();
    
    if (response.statusCode >= 300 && response.statusCode < 400) {
      final location = response.headers.value('location');
      if (location != null) {
        return resolveRedirect(location);
      }
    }
    return url;
  } catch (e) {
    return url;
  }
}

String normalizeUrl(String url) {
  var clean = url.trim().toLowerCase();
  
  // Strip protocol
  clean = clean.replaceFirst(RegExp(r'^https?://'), '');
  
  // Strip www.
  clean = clean.replaceFirst(RegExp(r'^www\.'), '');
  
  // Strip trailing slashes
  while (clean.endsWith('/')) {
    clean = clean.substring(0, clean.length - 1);
  }
  
  return clean;
}
