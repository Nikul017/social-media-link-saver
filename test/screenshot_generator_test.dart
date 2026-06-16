import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/core/database/app_database.dart' as db;
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/home_page.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/bookmark_detail_page.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/mind_map_page.dart';
import 'package:link_saver/features/bookmarks/presentation/widgets/add_bookmark_sheet.dart';
import 'package:link_saver/features/settings/presentation/pages/settings_page.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/core/theme/app_theme.dart';
import 'package:link_saver/core/providers/share_intent_provider.dart';

// --- MOCK DATA ---

final mockBookmarks = [
  Bookmark(
    id: '1',
    url: 'https://notion.so',
    title: 'Notion – Your wiki, docs & projects. Together.',
    description: 'A new tool that blends your everyday work apps into one. It\'s the all-in-one workspace for you and your team.',
    notes: 'Using Notion to organize my workspace, notes, and team documentation.',
    createdAt: DateTime(2026, 6, 1),
    updatedAt: DateTime(2026, 6, 1),
    category: '📰 Articles',
    folderId: '1',
    isFavorite: true,
  ),
  Bookmark(
    id: '2',
    url: 'https://obsidian.md',
    title: 'Obsidian – Sharpen your thinking',
    description: 'Obsidian is a powerful and extensible knowledge base that works on top of your local folder of plain text Markdown files.',
    notes: 'My second brain. Local-first markdown files with connection graphing.',
    createdAt: DateTime(2026, 6, 2),
    updatedAt: DateTime(2026, 6, 2),
    category: '📚 Learning',
    folderId: '2',
  ),
  Bookmark(
    id: '3',
    url: 'https://linear.app',
    title: 'Linear – Issue tracking designed for software teams',
    description: 'Linear helps software teams streamline projects, tasks, bugs, and product roadmaps. It\'s built for high-performance teams.',
    notes: 'Beautiful design and keyboard shortcuts make it incredibly fast to use.',
    createdAt: DateTime(2026, 6, 3),
    updatedAt: DateTime(2026, 6, 3),
    category: '💻 Tech',
    folderId: '1',
  ),
  Bookmark(
    id: '4',
    url: 'https://figma.com',
    title: 'Figma: The Collaborative Interface Design Tool',
    description: 'Build better products as a team. Design, prototype, and gather feedback all in one browser-based design tool.',
    notes: 'Industry standard tool for collaborative UI/UX design and prototyping.',
    createdAt: DateTime(2026, 6, 4),
    updatedAt: DateTime(2026, 6, 4),
    category: '🎨 Design',
    folderId: '3',
  ),
  Bookmark(
    id: '5',
    url: 'https://github.com',
    title: 'GitHub – Where the world builds software',
    description: 'GitHub is where over 100 million developers shape the future of software, hosting code, managing projects, and collaborating.',
    notes: 'Version control repository for all active coding projects.',
    createdAt: DateTime(2026, 6, 5),
    updatedAt: DateTime(2026, 6, 5),
    category: '💻 Tech',
    folderId: '1',
  ),
];

final mockFolders = [
  db.Folder(id: 1, name: 'WORK WORKSPACE', parentId: null, icon: 'work'),
  db.Folder(id: 2, name: 'READ LATER', parentId: null, icon: 'book'),
  db.Folder(id: 3, name: 'DESIGN INSPO', parentId: null, icon: 'palette'),
];

// --- RIVERPOD OVERRIDES ---

class MockBookmarkList extends BookmarkList {
  final List<Bookmark> bookmarks;
  MockBookmarkList(this.bookmarks);

  @override
  FutureOr<List<Bookmark>> build() => bookmarks;
}

class MockFolderList extends FolderList {
  final List<db.Folder> folders;
  MockFolderList(this.folders);

  @override
  FutureOr<List<db.Folder>> build() => folders;
}

class MockThemeNotifier extends ThemeNotifier {
  final ThemeMode themeMode;
  MockThemeNotifier(this.themeMode);

  @override
  ThemeMode build() => themeMode;
}

class MockThemeStyleNotifier extends ThemeStyleNotifier {
  final ThemeStyle themeStyle;
  MockThemeStyleNotifier(this.themeStyle);

  @override
  ThemeStyle build() => themeStyle;
}

// --- WIDGET WRAPPER HELPERS ---

Widget createTestableWidget({
  required Widget child,
  required ThemeMode themeMode,
  required ThemeStyle themeStyle,
  Bookmark? detailBookmark,
}) {
  final lightTheme = themeStyle == ThemeStyle.neoBrutalist
      ? AppTheme.neoBrutalistLightTheme
      : AppTheme.lightTheme;
  final darkTheme = themeStyle == ThemeStyle.neoBrutalist
      ? AppTheme.neoBrutalistDarkTheme
      : AppTheme.darkTheme;

  return ProviderScope(
    overrides: [
      themeNotifierProvider.overrideWith(() => MockThemeNotifier(themeMode)),
      themeStyleNotifierProvider.overrideWith(() => MockThemeStyleNotifier(themeStyle)),
      bookmarkListProvider.overrideWith(() => MockBookmarkList(mockBookmarks)),
      folderListProvider.overrideWith(() => MockFolderList(mockFolders)),
      allBookmarksProvider.overrideWith((ref) => mockBookmarks),
      pendingSharedUrlProvider.overrideWith((ref) => null),
      if (detailBookmark != null)
        bookmarkStreamProvider(detailBookmark.id).overrideWith((ref) => Stream.value(detailBookmark)),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: child,
    ),
  );
}

void main() {
  final androidDevice = Device(
    name: 'android',
    size: const Size(390, 844),
    devicePixelRatio: 3.0,
  );

  group('Automated Marketing Screenshots', () {
    testGoldens('Home Page Classic Light', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const HomePage(),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.classic,
        ),
      );
      await multiScreenGolden(tester, 'home_page_classic_light', devices: [androidDevice]);
    });

    testGoldens('Home Page Classic Dark', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const HomePage(),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.classic,
        ),
      );
      await multiScreenGolden(tester, 'home_page_classic_dark', devices: [androidDevice]);
    });

    testGoldens('Home Page Neo Light', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const HomePage(),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      await multiScreenGolden(tester, 'home_page_neo_light', devices: [androidDevice]);
    });

    testGoldens('Home Page Neo Dark', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const HomePage(),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      await multiScreenGolden(tester, 'home_page_neo_dark', devices: [androidDevice]);
    });

    testGoldens('Bookmark Detail Classic Light', (tester) async {
      final targetBookmark = mockBookmarks[0];
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: BookmarkDetailPage(bookmark: targetBookmark),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.classic,
          detailBookmark: targetBookmark,
        ),
      );
      await multiScreenGolden(tester, 'detail_page_classic_light', devices: [androidDevice]);
    });

    testGoldens('Bookmark Detail Classic Dark', (tester) async {
      final targetBookmark = mockBookmarks[0];
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: BookmarkDetailPage(bookmark: targetBookmark),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.classic,
          detailBookmark: targetBookmark,
        ),
      );
      await multiScreenGolden(tester, 'detail_page_classic_dark', devices: [androidDevice]);
    });

    testGoldens('Bookmark Detail Neo Light', (tester) async {
      final targetBookmark = mockBookmarks[0];
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: BookmarkDetailPage(bookmark: targetBookmark),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.neoBrutalist,
          detailBookmark: targetBookmark,
        ),
      );
      await multiScreenGolden(tester, 'detail_page_neo_light', devices: [androidDevice]);
    });

    testGoldens('Bookmark Detail Neo Dark', (tester) async {
      final targetBookmark = mockBookmarks[0];
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: BookmarkDetailPage(bookmark: targetBookmark),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.neoBrutalist,
          detailBookmark: targetBookmark,
        ),
      );
      await multiScreenGolden(tester, 'detail_page_neo_dark', devices: [androidDevice]);
    });

    testGoldens('Add Bookmark Sheet Classic Light', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const Scaffold(
            body: AddBookmarkSheet(
              initialUrl: 'https://github.com/google/flutter',
            ),
          ),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.classic,
        ),
      );
      await multiScreenGolden(tester, 'add_bookmark_classic_light', devices: [androidDevice]);
    });

    testGoldens('Add Bookmark Sheet Classic Dark', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const Scaffold(
            body: AddBookmarkSheet(
              initialUrl: 'https://github.com/google/flutter',
            ),
          ),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.classic,
        ),
      );
      await multiScreenGolden(tester, 'add_bookmark_classic_dark', devices: [androidDevice]);
    });

    testGoldens('Add Bookmark Sheet Neo Light', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const Scaffold(
            body: AddBookmarkSheet(
              initialUrl: 'https://github.com/google/flutter',
            ),
          ),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      await multiScreenGolden(tester, 'add_bookmark_neo_light', devices: [androidDevice]);
    });

    testGoldens('Add Bookmark Sheet Neo Dark', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const Scaffold(
            body: AddBookmarkSheet(
              initialUrl: 'https://github.com/google/flutter',
            ),
          ),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      await multiScreenGolden(tester, 'add_bookmark_neo_dark', devices: [androidDevice]);
    });

    testGoldens('Mind Map Neo Light', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const MindMapPage(),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      // Wait for layout rendering and expansion
      await tester.pump(const Duration(milliseconds: 500));
      await multiScreenGolden(tester, 'mind_map_neo_light', devices: [androidDevice]);
    });

    testGoldens('Mind Map Neo Dark', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const MindMapPage(),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      await multiScreenGolden(tester, 'mind_map_neo_dark', devices: [androidDevice]);
    });

    testGoldens('Settings Neo Light', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const SettingsPage(),
          themeMode: ThemeMode.light,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      await multiScreenGolden(tester, 'settings_neo_light', devices: [androidDevice]);
    });

    testGoldens('Settings Neo Dark', (tester) async {
      await tester.pumpWidgetBuilder(
        createTestableWidget(
          child: const SettingsPage(),
          themeMode: ThemeMode.dark,
          themeStyle: ThemeStyle.neoBrutalist,
        ),
      );
      await multiScreenGolden(tester, 'settings_neo_dark', devices: [androidDevice]);
    });
  });
}
