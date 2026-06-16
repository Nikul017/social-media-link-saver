import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/duplicate_providers.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';
import 'package:link_saver/shared/widgets/staggered_entrance.dart';


class DuplicateFinderPage extends ConsumerStatefulWidget {
  const DuplicateFinderPage({super.key});

  @override
  ConsumerState<DuplicateFinderPage> createState() => _DuplicateFinderPageState();
}

class _DuplicateFinderPageState extends ConsumerState<DuplicateFinderPage> {
  // Store manually selected bookmark IDs for deletion
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duplicatesAsync = ref.watch(duplicateBookmarksProvider);
    final notifierState = ref.watch(duplicateFinderNotifierProvider);

    // Resolve folders for folder name lookup
    final foldersAsync = ref.watch(folderListProvider);
    final folderMap = foldersAsync.maybeWhen(
      data: (folders) => {for (var f in folders) f.id.toString(): f.name},
      orElse: () => <String, String>{},
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          duplicatesAsync.when(
            data: (duplicateGroups) {
              if (duplicateGroups.isEmpty) {
                return _buildEmptyState(theme);
              }
              return _buildListContent(theme, duplicateGroups, folderMap);
            },
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 3)),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('ERROR: $err', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ),
            ),
          ),
          
          // Selection Floating Action Bar at the bottom
          if (_selectedIds.isNotEmpty)
            _buildSelectionBar(theme),

          // Loading overlay during deletion process
          if (notifierState is AsyncLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              ),
            ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
      leading: BrutalistPress(
        onTap: () => context.pop(),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      title: Text(
        'DUPLICATE FINDER',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          fontFamily: isNeo ? 'JetBrainsMono' : null,
          fontSize: 16,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: theme.colorScheme.outline.withOpacity(isNeo ? 1.0 : 0.5)),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.onSurface, width: isNeo ? 2.0 : 1.5),
              ),
              child: Icon(Icons.verified_rounded, size: 36, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            Text(
              'ALL CLEAN!',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No duplicate bookmark links were found in your library.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent(
    ThemeData theme,
    Map<String, List<Bookmark>> duplicateGroups,
    Map<String, String> folderMap,
  ) {
    final totalGroups = duplicateGroups.length;
    final totalDuplicates = duplicateGroups.values.fold<int>(0, (sum, list) => sum + (list.length - 1));

    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        // Total Stats Action Header Card
        _buildStatsHeader(theme, totalGroups, totalDuplicates, duplicateGroups),
        
        // Group Items
        ...duplicateGroups.entries.toList().asMap().entries.map((mapEntry) {
          final index = mapEntry.key;
          final entry = mapEntry.value;
          final normalizedUrl = entry.key;
          final bookmarks = entry.value;
          return StaggeredEntrance(
            index: index,
            child: _buildGroupCard(theme, normalizedUrl, bookmarks, folderMap),
          );
        }),
      ],
    );
  }

  Widget _buildStatsHeader(
    ThemeData theme,
    int groupCount,
    int duplicateCount,
    Map<String, List<Bookmark>> duplicateGroups,
  ) {
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final border = Border.all(
      color: theme.colorScheme.outline,
      width: isNeo ? 1.5 : 0.8,
    );

    final shadow = isNeo
        ? [
            BoxShadow(
              color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
              offset: const Offset(3.0, 3.0),
              blurRadius: 0,
            )
          ]
        : null;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: border,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$groupCount DUPLICATE GROUPS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontFamily: isNeo ? 'JetBrainsMono' : null,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$duplicateCount EXTRA LINKS CAN BE REMOVED',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: isNeo ? 'JetBrainsMono' : null,
                    ),
                  ),
                ],
              ),
              Icon(Icons.cleaning_services_rounded, size: 24, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: isNeo
                ? BrutalistPress(
                    onTap: () => _confirmAutoCleanAll(duplicateGroups),
                    isCard: true,
                    backgroundColor: theme.colorScheme.onSurface,
                    borderColor: theme.colorScheme.outline,
                    borderRadius: 8.0,
                    shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                    shadowOffset: const Offset(2.0, 2.0),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Text(
                        'AUTO CLEAN ALL DUPLICATES',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          fontSize: 12,
                          fontFamily: 'JetBrainsMono',
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => _confirmAutoCleanAll(duplicateGroups),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.onSurface,
                      foregroundColor: theme.colorScheme.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'AUTO CLEAN ALL DUPLICATES',
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 12),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: isNeo
                ? BrutalistPress(
                    onTap: () => _confirmResolveShortLinks(),
                    isCard: true,
                    backgroundColor: theme.colorScheme.surface,
                    borderColor: theme.colorScheme.outline,
                    borderRadius: 8.0,
                    shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                    shadowOffset: const Offset(2.0, 2.0),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Text(
                        'RESOLVE SHORT LINKS (T.CO)',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          fontSize: 12,
                          fontFamily: 'JetBrainsMono',
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: () => _confirmResolveShortLinks(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(color: theme.colorScheme.outline, width: 0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'RESOLVE SHORT LINKS (T.CO)',
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 12),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    ThemeData theme,
    String urlKey,
    List<Bookmark> bookmarks,
    Map<String, String> folderMap,
  ) {
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final border = Border.all(
      color: theme.colorScheme.outline,
      width: isNeo ? 1.5 : 0.8,
    );

    final shadow = isNeo
        ? [
            BoxShadow(
              color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
              offset: const Offset(3.0, 3.0),
              blurRadius: 0,
            )
          ]
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: border,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Header Title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              border: Border(bottom: BorderSide(color: theme.colorScheme.outline, width: isNeo ? 1.5 : 0.8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    urlKey,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      fontFamily: isNeo ? 'JetBrainsMono' : null,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${bookmarks.length}x',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 8),
                _buildGroupActionsMenu(urlKey, bookmarks),
              ],
            ),
          ),
          
          // Bookmark rows
          ...bookmarks.map((bookmark) {
            final isChecked = _selectedIds.contains(bookmark.id);
            final folderName = bookmark.folderId != null ? folderMap[bookmark.folderId] : null;
            return _buildBookmarkRow(theme, bookmark, isChecked, folderName);
          }),
        ],
      ),
    );
  }

  Widget _buildBookmarkRow(
    ThemeData theme,
    Bookmark bookmark,
    bool isChecked,
    String? folderName,
  ) {
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final dateStr = _formatDate(bookmark.createdAt);

    return InkWell(
      onTap: () {
        setState(() {
          if (isChecked) {
            _selectedIds.remove(bookmark.id);
          } else {
            _selectedIds.add(bookmark.id);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3), width: isNeo ? 1.0 : 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox Selector
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedIds.add(bookmark.id);
                      } else {
                        _selectedIds.remove(bookmark.id);
                      }
                    });
                  },
                  activeColor: isNeo ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  checkColor: isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
            
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.title.trim().isNotEmpty ? bookmark.title : bookmark.url,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      fontFamily: isNeo ? 'JetBrainsMono' : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (folderName != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.outline, width: isNeo ? 1.2 : 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            folderName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 8, 
                              fontWeight: FontWeight.w900, 
                              letterSpacing: 0.5,
                              fontFamily: isNeo ? 'JetBrainsMono' : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'ADDED: $dateStr',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          fontFamily: isNeo ? 'JetBrainsMono' : null,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  if (bookmark.notes != null && bookmark.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      bookmark.notes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                        fontFamily: isNeo ? 'JetBrainsMono' : null,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupActionsMenu(String urlKey, List<Bookmark> bookmarks) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 18),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (val) {
        if (val == 'oldest') {
          _confirmKeepOldest(urlKey, bookmarks);
        } else if (val == 'newest') {
          _confirmKeepNewest(urlKey, bookmarks);
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: 'oldest',
          child: Row(
            children: [
              Icon(Icons.history_toggle_off_rounded, size: 16),
              SizedBox(width: 8),
              Text('KEEP OLDEST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'newest',
          child: Row(
            children: [
              Icon(Icons.update_rounded, size: 16),
              SizedBox(width: 8),
              Text('KEEP NEWEST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionBar(ThemeData theme) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedIds.length} SELECTED',
              style: TextStyle(
                color: theme.colorScheme.surface,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => _selectedIds.clear()),
                  child: Text(
                    'CLEAR',
                    style: TextStyle(
                      color: theme.colorScheme.surface.withOpacity(0.6),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _confirmDeleteSelected,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface,
                    foregroundColor: theme.colorScheme.onSurface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text(
                    'DELETE',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Date Formatting Utility ──
  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // ── Deletion Actions & Confirmation Dialogs ──
  
  void _confirmResolveShortLinks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('RESOLVE SHORTENED LINKS?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: const Text(
          'This will scan your entire bookmark database, follow all short "t.co" redirects, and replace them with their original full destination URLs.\n\nThis can help uncover duplicate links for easy auto-cleaning.',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final count = await ref.read(duplicateFinderNotifierProvider.notifier).resolveShortLinks();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'SUCCESSFULLY EXPANDED $count SHORTENED LINKS!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                );
              }
            },
            child: Text('RESOLVE', style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('DELETE SELECTED?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.red)),
        content: Text(
          'Are you sure you want to delete these ${_selectedIds.length} duplicate bookmark entries?',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ids = _selectedIds.toList();
              setState(() => _selectedIds.clear());
              await ref.read(duplicateFinderNotifierProvider.notifier).deleteBookmarks(ids);
            },
            child: const Text('DELETE', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmAutoCleanAll(Map<String, List<Bookmark>> duplicateGroups) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('AUTO CLEAN DATABASE?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.red)),
        content: const Text(
          'This will automatically keep the oldest bookmark entry in each duplicate group and delete all other newer copies.\n\nThis action cannot be undone.',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _selectedIds.clear());
              await ref.read(duplicateFinderNotifierProvider.notifier).autoCleanAll(duplicateGroups);
            },
            child: const Text('AUTO CLEAN', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmKeepOldest(String urlKey, List<Bookmark> bookmarks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('KEEP OLDEST ONLY?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: Text(
          'For "$urlKey": This will keep only the oldest bookmark and delete the other ${bookmarks.length - 1} entries.',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final sorted = List<Bookmark>.from(bookmarks)
                ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
              
              final idsToDelete = sorted.skip(1).map((b) => b.id).toList();
              setState(() {
                _selectedIds.removeAll(idsToDelete);
              });
              await ref.read(duplicateFinderNotifierProvider.notifier).deleteBookmarks(idsToDelete);
            },
            child: Text('KEEP OLDEST', style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }

  void _confirmKeepNewest(String urlKey, List<Bookmark> bookmarks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('KEEP NEWEST ONLY?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: Text(
          'For "$urlKey": This will keep only the newest bookmark and delete the other ${bookmarks.length - 1} entries.',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final sorted = List<Bookmark>.from(bookmarks)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              
              final idsToDelete = sorted.skip(1).map((b) => b.id).toList();
              setState(() {
                _selectedIds.removeAll(idsToDelete);
              });
              await ref.read(duplicateFinderNotifierProvider.notifier).deleteBookmarks(idsToDelete);
            },
            child: Text('KEEP NEWEST', style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }
}
