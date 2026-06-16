import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/import_provider.dart';
import 'package:link_saver/features/bookmarks/presentation/widgets/add_bookmark_sheet.dart';
import 'package:link_saver/features/bookmarks/presentation/widgets/bookmark_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:link_saver/core/providers/share_intent_provider.dart';
import 'package:link_saver/features/bookmarks/presentation/widgets/folder_drawer.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';
import 'package:link_saver/shared/widgets/staggered_entrance.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static void openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddBookmarkSheet(),
    );
  }

  static void openDetailPage(BuildContext context, Bookmark bookmark) {
    context.push('/bookmark/${bookmark.id}', extra: bookmark);
  }

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ScrollController _scrollController;
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (_showFab) {
        setState(() {
          _showFab = false;
        });
      }
    } else if (direction == ScrollDirection.forward) {
      if (!_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookmarksAsync = ref.watch(bookmarkListProvider);
    final importState = ref.watch(importNotifierProvider);

    // Listen for sharing intent when app is already in foreground (hot start)
    ref.listen<String?>(pendingSharedUrlProvider, (_, url) {
      if (url == null) return;
      ref.read(pendingSharedUrlProvider.notifier).state = null;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddBookmarkSheet(initialUrl: url),
      );
    });

    // Check for pending sharing intent on app startup/mount (cold start)
    final pendingUrl = ref.read(pendingSharedUrlProvider);
    if (pendingUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final url = ref.read(pendingSharedUrlProvider);
        if (url != null) {
          ref.read(pendingSharedUrlProvider.notifier).state = null;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddBookmarkSheet(initialUrl: url),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      drawer: const FolderDrawer(),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => ref.invalidate(bookmarkListProvider),
            color: theme.colorScheme.onSurface,
            backgroundColor: theme.colorScheme.surface,
            child: bookmarksAsync.when(
              data: (bookmarks) => Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    child: bookmarks.isEmpty
                        ? _EmptyState(
                            onAdd: () => HomePage.openAddSheet(context),
                            onImport: () => _handleImport(ref),
                          )
                        : _BookmarkGrid(
                            bookmarks: bookmarks,
                            onTap: (b) => HomePage.openDetailPage(context, b),
                            scrollController: _scrollController,
                          ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 3)),
              error: (err, _) => _ErrorState(message: err.toString()),
            ),
          ),
          if (importState is AsyncLoading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
      floatingActionButton: bookmarksAsync.maybeWhen(
        data: (b) => b.isEmpty
            ? null
            : AnimatedScale(
                scale: _showFab ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                child: AnimatedOpacity(
                  opacity: _showFab ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: _AddFAB(onTap: () => HomePage.openAddSheet(context)),
                ),
              ),
        orElse: () => AnimatedScale(
          scale: _showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          child: AnimatedOpacity(
            opacity: _showFab ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: _AddFAB(onTap: () => HomePage.openAddSheet(context)),
          ),
        ),
      ),
    );
  }

  void _handleImport(WidgetRef ref) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'csv', 'xlsx', 'xls', 'txt'],
    );
    if (result != null && result.files.single.path != null) {
      ref.read(importNotifierProvider.notifier).importFromFile(result.files.single.path!);
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final foldersAsync = ref.watch(folderListProvider);
    final bookmarksAsync = ref.watch(bookmarkListProvider);

    final count = bookmarksAsync.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0,
    );

    String folderSuffix = '';
    if (selectedFolderId != null) {
      foldersAsync.whenData((folders) {
        try {
          final folder = folders.firstWhere((f) => f.id.toString() == selectedFolderId);
          folderSuffix = ' / ${folder.name.toUpperCase()}';
        } catch (_) {}
      });
    }

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      centerTitle: false,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu_rounded, size: 22),
            tooltip: 'Open Folders',
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'LINKSAVER$folderSuffix', 
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900, 
              letterSpacing: 1.5, 
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$count LINKS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 9,
              letterSpacing: 1.0,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
      actions: [
        _AppBarIcon(icon: Icons.hub_rounded, onTap: () => context.push('/mind-map')),
        _AppBarIcon(icon: Icons.search_rounded, onTap: () => context.push('/search')),
        _AppBarIcon(icon: Icons.settings_rounded, onTap: () => context.push('/settings')),
        const SizedBox(width: 12),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BrutalistPress(
      onTap: onTap,
      child: IconButton(
        icon: Icon(icon, size: 22),
        onPressed: onTap,
      ),
    );
  }
}

class _AddFAB extends ConsumerWidget {
  final VoidCallback onTap;
  const _AddFAB({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    if (isNeo) {
      return BrutalistPress(
        onTap: onTap,
        isCard: true,
        backgroundColor: theme.colorScheme.primary,
        borderColor: theme.colorScheme.outline,
        borderRadius: 12.0,
        shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
        shadowOffset: const Offset(3.0, 3.0),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(Icons.add_rounded, size: 28, color: theme.colorScheme.onPrimary),
        ),
      );
    }

    return BrutalistPress(
      onTap: onTap,
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: theme.colorScheme.onSurface,
        foregroundColor: theme.colorScheme.surface,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}

class _BookmarkGrid extends StatelessWidget {
  final List<Bookmark> bookmarks;
  final void Function(Bookmark) onTap;
  final ScrollController scrollController;

  const _BookmarkGrid({
    required this.bookmarks,
    required this.onTap,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) => StaggeredEntrance(
        index: index,
        child: BookmarkCard(
          bookmark: bookmarks[index],
          onTap: () => onTap(bookmarks[index]),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onImport;
  const _EmptyState({required this.onAdd, required this.onImport});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_add_outlined, size: 80, color: theme.colorScheme.outline),
          const SizedBox(height: 24),
          Text('EMPTY LIBRARY', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 12),
          Text(
            'Save links from any app to build your digital library.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: BrutalistPress(
              onTap: onAdd,
              child: FilledButton(
                onPressed: onAdd,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.onSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('ADD FIRST LINK', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
