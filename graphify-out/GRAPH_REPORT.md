# Graph Report - D:\projects\flutter projects\bookmark manager\link_saver  (2026-05-20)

## Corpus Check
- 73 files · ~60,873 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 437 nodes · 491 edges · 43 communities detected
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 12 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 20 edges
2. `_` - 18 edges
3. `package:flutter_riverpod/flutter_riverpod.dart` - 12 edges
4. `package:link_saver/features/bookmarks/domain/entities/bookmark.dart` - 12 edges
5. `package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart` - 11 edges
6. `AppDelegate` - 8 edges
7. `package:link_saver/core/database/app_database.dart` - 8 edges
8. `_` - 8 edges
9. `package:go_router/go_router.dart` - 7 edges
10. `Create()` - 7 edges

## Surprising Connections (you probably didn't know these)
- `OnCreate()` --calls--> `RegisterPlugins()`  [INFERRED]
  D:\projects\flutter projects\bookmark manager\link_saver\windows\runner\flutter_window.cpp → D:\projects\flutter projects\bookmark manager\link_saver\windows\flutter\generated_plugin_registrant.cc
- `OnCreate()` --calls--> `Show()`  [INFERRED]
  D:\projects\flutter projects\bookmark manager\link_saver\windows\runner\flutter_window.cpp → D:\projects\flutter projects\bookmark manager\link_saver\windows\runner\win32_window.cpp
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  D:\projects\flutter projects\bookmark manager\link_saver\windows\runner\main.cpp → D:\projects\flutter projects\bookmark manager\link_saver\windows\runner\utils.cpp
- `wWinMain()` --calls--> `SetQuitOnClose()`  [INFERRED]
  D:\projects\flutter projects\bookmark manager\link_saver\windows\runner\main.cpp → D:\projects\flutter projects\bookmark manager\link_saver\windows\runner\win32_window.cpp
- `my_application_dispose()` --calls--> `dispose`  [INFERRED]
  D:\projects\flutter projects\bookmark manager\link_saver\linux\runner\my_application.cc → D:\projects\flutter projects\bookmark manager\link_saver\lib\features\search\presentation\pages\search_page.dart

## Communities

### Community 0 - "Community 0"
Cohesion: 0.04
Nodes (50): _AddFAB, AppBar, _AppBarIcon, _BookmarkGrid, build, _buildAppBar, Center, _EmptyState (+42 more)

### Community 1 - "Community 1"
Cohesion: 0.09
Nodes (25): FlutterWindow(), OnCreate(), RegisterPlugins(), wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), Create() (+17 more)

### Community 2 - "Community 2"
Cohesion: 0.06
Nodes (27): AppColors, AppTypography, build, setTheme, ThemeNotifier, toggleTheme, GraphEdge, GraphNode (+19 more)

### Community 3 - "Community 3"
Cohesion: 0.07
Nodes (27): AddBookmarkSheet, _AddBookmarkSheetState, build, _buildLabel, _buildTextField, _CategoryChips, Container, dispose (+19 more)

### Community 4 - "Community 4"
Cohesion: 0.07
Nodes (27): AppBar, build, _buildAppBar, _buildBookmarkRow, _buildEmptyState, _buildGroupActionsMenu, _buildGroupCard, _buildListContent (+19 more)

### Community 5 - "Community 5"
Cohesion: 0.07
Nodes (17): BookmarkCard, build, Center, dispose, Icon, Scaffold, SearchPage, _SearchPageState (+9 more)

### Community 6 - "Community 6"
Cohesion: 0.1
Nodes (22): _attachTags, BookmarkLocalDataSource, BookmarkLocalDataSourceImpl, BookmarkWithTags, BookmarkMapper, BookmarkRepositoryImpl, saveBookmark, BookmarkList (+14 more)

### Community 7 - "Community 7"
Cohesion: 0.1
Nodes (22): AppDatabase, Bookmarks, BookmarkTags, Folders, LazyDatabase, _openConnection, Tags, UnimplementedError (+14 more)

### Community 8 - "Community 8"
Cohesion: 0.1
Nodes (18): app_colors.dart, app_typography.dart, AppTheme, _textTheme, ThemeData, BookmarkDetailPage, build, _buildContent (+10 more)

### Community 9 - "Community 9"
Cohesion: 0.11
Nodes (17): ../../../../core/theme/app_colors.dart, ../../../../core/theme/app_typography.dart, BookmarkDetailPage, build, initState, Scaffold, SizedBox, SplashPage (+9 more)

### Community 10 - "Community 10"
Cohesion: 0.12
Nodes (17): _, Bookmark, BookmarksCompanion, BookmarkTag, BookmarkTagsCompanion, f, Folder, FoldersCompanion (+9 more)

### Community 11 - "Community 11"
Cohesion: 0.12
Nodes (15): build, Center, Drawer, _DrawerTile, FolderDrawer, InkWell, Material, _OptionTile (+7 more)

### Community 12 - "Community 12"
Cohesion: 0.12
Nodes (15): ../controllers/graph_controller.dart, build, Center, Container, _EmptyGraph, GraphPage, _GraphPageState, initState (+7 more)

### Community 13 - "Community 13"
Cohesion: 0.17
Nodes (11): BookmarkStreamFamily, BookmarkStreamProvider, _BookmarkStreamProviderElement, BookmarkStreamRef, call, combine, finish, getProviderOverride (+3 more)

### Community 14 - "Community 14"
Cohesion: 0.22
Nodes (3): AppDelegate, FlutterAppDelegate, FlutterImplicitEngineDelegate

### Community 15 - "Community 15"
Cohesion: 0.22
Nodes (8): build, _detectPlatform, _fetchFromHtml, _isProfileUrl, LinkMetadata, MetadataService, package:dio/dio.dart, package:html/parser.dart

### Community 16 - "Community 16"
Cohesion: 0.33
Nodes (7): _, _Bookmark, DeepCollectionEquality, EqualUnmodifiableListView, identical, _then, toString

### Community 17 - "Community 17"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), MainFlutterWindow, NSWindow

### Community 18 - "Community 18"
Cohesion: 0.4
Nodes (2): GeneratedPluginRegistrant, -registerWithRegistry

### Community 19 - "Community 19"
Cohesion: 0.4
Nodes (1): QuickSaveActivity

### Community 20 - "Community 20"
Cohesion: 0.4
Nodes (2): RunnerTests, XCTestCase

### Community 21 - "Community 21"
Cohesion: 0.5
Nodes (2): handle_new_rx_page(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.

### Community 22 - "Community 22"
Cohesion: 0.67
Nodes (2): FlutterSceneDelegate, SceneDelegate

### Community 23 - "Community 23"
Cohesion: 0.67
Nodes (2): Bookmark, package:freezed_annotation/freezed_annotation.dart

### Community 24 - "Community 24"
Cohesion: 0.67
Nodes (2): BookmarkRepository, ../entities/bookmark.dart

### Community 25 - "Community 25"
Cohesion: 1.0
Nodes (1): MainActivity

### Community 26 - "Community 26"
Cohesion: 1.0
Nodes (0): 

### Community 27 - "Community 27"
Cohesion: 1.0
Nodes (0): 

### Community 28 - "Community 28"
Cohesion: 1.0
Nodes (0): 

### Community 29 - "Community 29"
Cohesion: 1.0
Nodes (0): 

### Community 30 - "Community 30"
Cohesion: 1.0
Nodes (0): 

### Community 31 - "Community 31"
Cohesion: 1.0
Nodes (0): 

### Community 32 - "Community 32"
Cohesion: 1.0
Nodes (0): 

### Community 33 - "Community 33"
Cohesion: 1.0
Nodes (0): 

### Community 34 - "Community 34"
Cohesion: 1.0
Nodes (0): 

### Community 35 - "Community 35"
Cohesion: 1.0
Nodes (0): 

### Community 36 - "Community 36"
Cohesion: 1.0
Nodes (0): 

### Community 37 - "Community 37"
Cohesion: 1.0
Nodes (0): 

### Community 38 - "Community 38"
Cohesion: 1.0
Nodes (0): 

### Community 39 - "Community 39"
Cohesion: 1.0
Nodes (0): 

### Community 40 - "Community 40"
Cohesion: 1.0
Nodes (0): 

### Community 41 - "Community 41"
Cohesion: 1.0
Nodes (0): 

### Community 42 - "Community 42"
Cohesion: 1.0
Nodes (0): 

## Knowledge Gaps
- **275 isolated node(s):** `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `MainApp`, `_MainAppState` (+270 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 25`** (2 nodes): `MainActivity.kt`, `MainActivity`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 26`** (1 nodes): `build.gradle.kts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 27`** (1 nodes): `settings.gradle.kts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 28`** (1 nodes): `build.gradle.kts`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 29`** (1 nodes): `GeneratedPluginRegistrant.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 30`** (1 nodes): `Runner-Bridging-Header.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 31`** (1 nodes): `theme_provider.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 32`** (1 nodes): `bookmark.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 33`** (1 nodes): `duplicate_providers.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 34`** (1 nodes): `export_provider.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 35`** (1 nodes): `import_provider.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 36`** (1 nodes): `metadata_service.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 37`** (1 nodes): `generated_plugin_registrant.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 38`** (1 nodes): `my_application.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 39`** (1 nodes): `generated_plugin_registrant.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 40`** (1 nodes): `resource.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 41`** (1 nodes): `utils.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 42`** (1 nodes): `win32_window.h`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Community 2` to `Community 0`, `Community 3`, `Community 4`, `Community 5`, `Community 8`, `Community 9`, `Community 11`, `Community 12`?**
  _High betweenness centrality (0.182) - this node is a cross-community bridge._
- **Why does `package:flutter_riverpod/flutter_riverpod.dart` connect `Community 0` to `Community 2`, `Community 3`, `Community 4`, `Community 5`, `Community 7`, `Community 8`, `Community 11`, `Community 12`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Why does `package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart` connect `Community 7` to `Community 0`, `Community 2`, `Community 3`, `Community 4`, `Community 5`, `Community 8`, `Community 11`, `Community 12`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **What connects `MainActivity`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry` to the rest of the system?**
  _275 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.09 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._