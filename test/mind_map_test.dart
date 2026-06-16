import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/core/database/app_database.dart' as db;
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/mind_map_page.dart';

// Create mock FolderList class to override provider
class MockFolderList extends FolderList {
  final List<db.Folder> folders;
  MockFolderList(this.folders);

  @override
  FutureOr<List<db.Folder>> build() => folders;
}

void main() {
  testWidgets('MindMapPage render test with empty list', (WidgetTester tester) async {
    final mockGoRouter = GoRouter(
      initialLocation: '/mind-map',
      routes: [
        GoRoute(
          path: '/mind-map',
          builder: (context, state) => const MindMapPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allBookmarksProvider.overrideWith((ref) => []),
          folderListProvider.overrideWith(() => MockFolderList([])),
        ],
        child: MaterialApp.router(
          routerConfig: mockGoRouter,
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('NO DATA FOR MIND MAP'), findsOneWidget);
  });

  testWidgets('MindMapPage render test with simple data', (WidgetTester tester) async {
    final mockGoRouter = GoRouter(
      initialLocation: '/mind-map',
      routes: [
        GoRoute(
          path: '/mind-map',
          builder: (context, state) => const MindMapPage(),
        ),
      ],
    );

    final testBookmark = Bookmark(
      id: '1',
      url: 'https://example.com',
      title: 'Example Bookmark',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      folderId: '10',
    );

    final testFolder = db.Folder(
      id: 10,
      name: 'Test Folder',
      parentId: null,
      icon: 'folder',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allBookmarksProvider.overrideWith((ref) => [testBookmark]),
          folderListProvider.overrideWith(() => MockFolderList([testFolder])),
        ],
        child: MaterialApp.router(
          routerConfig: mockGoRouter,
        ),
      ),
    );

    await tester.pumpAndSettle();
    // Verify that the title and folder node exist
    expect(find.text('MY LIBRARY'), findsOneWidget);
    expect(find.text('TEST FOLDER'), findsOneWidget);
    
    // Bookmark should not be visible initially as the folder is collapsed
    expect(find.text('Example Bookmark'), findsNothing);

    // Tap on the folder to expand it
    await tester.tap(find.text('TEST FOLDER'));
    await tester.pumpAndSettle();

    // Now bookmark should be visible!
    expect(find.text('Example Bookmark'), findsOneWidget);

    // Tap on the folder again to collapse it
    await tester.tap(find.text('TEST FOLDER'));
    await tester.pumpAndSettle();

    // Bookmark should be hidden again!
    expect(find.text('Example Bookmark'), findsNothing);
  });
}
