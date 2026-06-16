import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';
import 'package:link_saver/core/database/app_database.dart' hide Bookmark;

// Let's create a manual Riverpod provider to load all bookmarks (non-archived)
final allBookmarksProvider = FutureProvider<List<Bookmark>>((ref) {
  return ref.watch(bookmarkRepositoryProvider).getBookmarks(isArchived: false);
});

enum MindMapLayoutMode {
  folders,
  categories,
}

class MindMapNode {
  final String id;
  final String label;
  final String? icon;
  final String? subtitle;
  final Color color;
  final bool isLeaf;
  final Bookmark? bookmark;
  final List<MindMapNode> children;
  final int? childCount;

  // Computed layout coordinates
  double x = 0;
  double y = 0;
  double width = 0;
  double height = 0;

  MindMapNode({
    required this.id,
    required this.label,
    this.icon,
    this.subtitle,
    required this.color,
    required this.isLeaf,
    this.bookmark,
    List<MindMapNode>? children,
    this.childCount,
  }) : children = children ?? [];
}

class MindMapPage extends ConsumerStatefulWidget {
  const MindMapPage({super.key});

  @override
  ConsumerState<MindMapPage> createState() => _MindMapPageState();
}

class _MindMapPageState extends ConsumerState<MindMapPage> {
  MindMapLayoutMode _layoutMode = MindMapLayoutMode.folders;
  final Set<String> _expandedNodes = {};
  final TransformationController _transformationController = TransformationController();

  // Neo-brutalist accent colors
  final List<Color> _accentColors = [
    const Color(0xFFF472B6), // Neo Pink
    const Color(0xFF60A5FA), // Neo Blue
    const Color(0xFF34D399), // Neo Emerald
    const Color(0xFFFBBF24), // Neo Amber
    const Color(0xFFA78BFA), // Neo Purple
    const Color(0xFFF87171), // Neo Red
    const Color(0xFFFB923C), // Neo Orange
    const Color(0xFF2DD4BF), // Neo Teal
  ];

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final currentMatrix = _transformationController.value;
    final scale = currentMatrix.getMaxScaleOnAxis();
    if (scale < 2.0) {
      _transformationController.value = currentMatrix * Matrix4.diagonal3Values(1.2, 1.2, 1.0);
    }
  }

  void _zoomOut() {
    final currentMatrix = _transformationController.value;
    final scale = currentMatrix.getMaxScaleOnAxis();
    if (scale > 0.2) {
      _transformationController.value = currentMatrix * Matrix4.diagonal3Values(0.8, 0.8, 1.0);
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _toggleNodeCollapse(String id) {
    setState(() {
      if (_expandedNodes.contains(id)) {
        _expandedNodes.remove(id);
      } else {
        _expandedNodes.add(id);
      }
    });
  }

  void _expandAll(MindMapNode root) {
    setState(() {
      _expandedNodes.clear();
      // Add all direct non-leaf children of root (top-level groups/folders)
      for (final child in root.children) {
        if (!child.isLeaf) _expandedNodes.add(child.id);
      }
    });
  }

  void _collapseAll() {
    setState(() {
      _expandedNodes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      final theme = Theme.of(context);
      final themeStyle = ref.watch(themeStyleNotifierProvider);
      final isNeo = themeStyle == ThemeStyle.neoBrutalist;
      final isDark = theme.brightness == Brightness.dark;

      final foldersAsync = ref.watch(folderListProvider);
      final bookmarksAsync = ref.watch(allBookmarksProvider);

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 22),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'MIND MAP',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 16,
            ),
          ),
          actions: [
            // Layout Toggle Buttons
            _buildLayoutToggle(),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: theme.colorScheme.outline.withOpacity(0.5)),
          ),
        ),
        body: bookmarksAsync.when(
          data: (bookmarks) {
            return foldersAsync.when(
              data: (folders) {
                if (bookmarks.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildCanvas(folders, bookmarks, isNeo, isDark, theme);
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 3)),
              error: (err, _) => Center(child: Text('Error loading folders: $err')),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 3)),
          error: (err, _) => Center(child: Text('Error loading bookmarks: $err')),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('MIND MAP RENDERING ERROR: $e\n$stackTrace');
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bug_report_rounded, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'MIND MAP RENDERING ERROR',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$e',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$stackTrace',
                      style: const TextStyle(fontSize: 9, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLayoutToggle() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget buildButton(MindMapLayoutMode mode, String label, IconData icon) {
      final isSelected = _layoutMode == mode;
      final bg = isSelected 
          ? (isDark ? Colors.white : Colors.black) 
          : (isDark ? Colors.transparent : Colors.transparent);
      final fg = isSelected 
          ? (isDark ? Colors.black : Colors.white) 
          : (isDark ? Colors.white60 : Colors.black54);

      return Material(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => setState(() => _layoutMode = mode),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: fg),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: fg,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildButton(MindMapLayoutMode.folders, 'FOLDERS', Icons.folder_rounded),
          buildButton(MindMapLayoutMode.categories, 'CATEGORIES', Icons.category_rounded),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hub_outlined, size: 80, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'NO DATA FOR MIND MAP',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Save some bookmarks first to visualize them in a mind map!',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas(
    List<Folder> folders,
    List<Bookmark> bookmarks,
    bool isNeo,
    bool isDark,
    ThemeData theme,
  ) {
    // 1. Build hierarchy based on selected mode
    final rootNode = _buildHierarchyTree(folders, bookmarks);

    // 2. Perform Horizontal Layout calculation
    final layout = TreeLayout();
    final treeHeight = layout.performLayout(rootNode);

    // Get screen sizes
    final media = MediaQuery.of(context);
    final double screenWidth = media.size.width;
    final double screenHeight = media.size.height - kToolbarHeight - media.padding.top;

    // Calculate canvas size
    final double maxX = _getMaxX(rootNode);
    final double canvasWidth = max(maxX + 120.0, screenWidth * 1.3);
    final double canvasHeight = max(treeHeight + 120.0, screenHeight);

    // 3. Center the tree vertically on the canvas
    final double offsetY = (canvasHeight - treeHeight) / 2;
    _adjustYCoordinates(rootNode, offsetY);

    // 4. Collect all visible nodes for rendering and line painting
    final visibleNodes = <MindMapNode>[];
    _collectVisibleNodes(rootNode, visibleNodes);

    final lineColor = isDark ? Colors.white.withOpacity(0.35) : Colors.black.withOpacity(0.6);

    return Stack(
      children: [
        // The Interactive Map Canvas
        InteractiveViewer(
          transformationController: _transformationController,
          constrained: false,
          minScale: 0.1,
          maxScale: 2.0,
          child: Container(
            width: canvasWidth,
            height: canvasHeight,
            color: theme.scaffoldBackgroundColor,
            child: Stack(
              children: [
                // Custom Paint for Connecting Lines (sitting underneath cards)
                Positioned.fill(
                  child: CustomPaint(
                    painter: MindMapPainter(
                      nodes: visibleNodes,
                      brightness: theme.brightness,
                      lineColor: lineColor,
                    ),
                  ),
                ),
                // Render Node Cards
                ...visibleNodes.map((node) {
                  return Positioned(
                    left: node.x,
                    top: node.y,
                    width: node.width,
                    height: node.height,
                    child: _buildNodeCard(node, isNeo, isDark, theme),
                  );
                }),
              ],
            ),
          ),
        ),

        // Floating Control Panel (Bottom Center)
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: _buildControlPanel(rootNode, isNeo, isDark, theme),
          ),
        ),
      ],
    );
  }

  Widget _buildNodeCard(MindMapNode node, bool isNeo, bool isDark, ThemeData theme) {
    if (node.id == 'root') {
      return _buildRootCard(node, isNeo, isDark, theme);
    } else if (node.isLeaf) {
      return _buildBookmarkCard(node, isNeo, isDark, theme);
    } else {
      return _buildFolderCard(node, isNeo, isDark, theme);
    }
  }

  Widget _buildRootCard(MindMapNode node, bool isNeo, bool isDark, ThemeData theme) {
    final bg = isDark ? const Color(0xFF2A2A2A) : Colors.black;
    final fg = Colors.white;

    return BrutalistPress(
      onTap: null,
      isCard: true,
      backgroundColor: bg,
      borderColor: theme.colorScheme.outline,
      borderRadius: 10,
      borderWidth: 2.0,
      shadowOffset: const Offset(2.0, 2.0),
      child: Center(
        child: Text(
          node.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: fg,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFolderCard(MindMapNode node, bool isNeo, bool isDark, ThemeData theme) {
    final isCollapsed = !_expandedNodes.contains(node.id);
    final count = node.childCount ?? node.children.length;

    return BrutalistPress(
      onTap: () => _toggleNodeCollapse(node.id),
      isCard: true,
      backgroundColor: node.color,
      borderColor: Colors.black,
      borderRadius: 8.0,
      borderWidth: 2.0,
      shadowColor: Colors.black.withOpacity(0.8),
      shadowOffset: const Offset(3.0, 3.0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Icon(
            isCollapsed ? Icons.add_box_rounded : Icons.indeterminate_check_box_rounded,
            size: 16,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              node.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 0.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(MindMapNode node, bool isNeo, bool isDark, ThemeData theme) {
    final b = node.bookmark!;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return BrutalistPress(
      onTap: () => context.push('/bookmark/${b.id}', extra: b),
      isCard: true,
      backgroundColor: cardBg,
      borderColor: theme.colorScheme.outline,
      borderRadius: 8.0,
      borderWidth: 1.5,
      shadowColor: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.15),
      shadowOffset: const Offset(2.0, 2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: node.color,
              width: 5.0,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon / Favicon
            if (b.faviconUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: CachedNetworkImage(
                    imageUrl: b.faviconUrl!,
                    width: 18,
                    height: 18,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.language_rounded, size: 16, color: theme.colorScheme.outline),
                  ),
                ),
              )
            else
              Icon(Icons.language_rounded, size: 18, color: theme.colorScheme.outline),
            const SizedBox(width: 8),

            // Content info — strictly 1-line title to prevent overflow
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    b.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (node.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      node.subtitle!,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Open direct link
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final url = Uri.tryParse(b.url);
                if (url != null && await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.open_in_new_rounded, size: 14, color: theme.colorScheme.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel(MindMapNode root, bool isNeo, bool isDark, ThemeData theme) {
    final panelBg = isDark ? const Color(0xFF18181B) : Colors.white;

    Widget buildToolBtn(IconData icon, String tooltip, VoidCallback onTap) {
      return IconButton(
        icon: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
        tooltip: tooltip,
        onPressed: onTap,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.colorScheme.outline, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.2),
            offset: const Offset(3.0, 3.0),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildToolBtn(Icons.zoom_in_rounded, 'Zoom In', _zoomIn),
          buildToolBtn(Icons.zoom_out_rounded, 'Zoom Out', _zoomOut),
          buildToolBtn(Icons.center_focus_strong_rounded, 'Fit Screen', _resetZoom),
          Container(
            width: 1.5,
            height: 24,
            color: theme.colorScheme.outline.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 6),
          ),
          buildToolBtn(Icons.unfold_more_rounded, 'Expand All', () => _expandAll(root)),
          buildToolBtn(Icons.unfold_less_rounded, 'Collapse All', _collapseAll),
        ],
      ),
    );
  }

  // ── Hierarchy Builders ─────────────────────────────────────

  MindMapNode _buildHierarchyTree(List<Folder> folders, List<Bookmark> bookmarks) {
    switch (_layoutMode) {
      case MindMapLayoutMode.folders:
        return _buildFoldersTree(folders, bookmarks);
      case MindMapLayoutMode.categories:
        return _buildCategoriesTree(bookmarks);
    }
  }

  MindMapNode _buildFoldersTree(List<Folder> folders, List<Bookmark> bookmarks) {
    final root = MindMapNode(
      id: 'root',
      label: 'MY LIBRARY',
      color: Colors.grey,
      isLeaf: false,
    );

    // Map folderId to its bookmarks
    final folderBookmarks = <int, List<Bookmark>>{};
    final uncategorized = <Bookmark>[];
    for (final b in bookmarks) {
      if (b.folderId != null) {
        final fId = int.tryParse(b.folderId!);
        if (fId != null) {
          folderBookmarks.putIfAbsent(fId, () => []).add(b);
        } else {
          uncategorized.add(b);
        }
      } else {
        uncategorized.add(b);
      }
    }

    // Map parentId to child folders
    final subfolders = <int?, List<Folder>>{};
    for (final f in folders) {
      subfolders.putIfAbsent(f.parentId, () => []).add(f);
    }

    int colorIdx = 0;
    final visitedFolderIds = <int>{};

    List<MindMapNode> buildFolderChildren(int? parentId, Color parentColor) {
      final list = <MindMapNode>[];

      // Process subfolders
      final childFolders = subfolders[parentId] ?? [];
      for (final f in childFolders) {
        if (visitedFolderIds.contains(f.id)) continue;
        visitedFolderIds.add(f.id);

        final fColor = parentId == null 
            ? _accentColors[colorIdx++ % _accentColors.length] 
            : parentColor;

        final directChildCount = (subfolders[f.id]?.length ?? 0) + (folderBookmarks[f.id]?.length ?? 0);
        final fNode = MindMapNode(
          id: 'folder_${f.id}',
          label: f.name.toUpperCase(),
          icon: f.icon,
          color: fColor,
          isLeaf: false,
          childCount: directChildCount,
        );

        if (_expandedNodes.contains(fNode.id)) {
          fNode.children.addAll(buildFolderChildren(f.id, fColor));
        }
        list.add(fNode);
        
        visitedFolderIds.remove(f.id);
      }

      // Process bookmarks
      if (parentId != null) {
        final bmList = folderBookmarks[parentId] ?? [];
        for (final b in bmList) {
          list.add(MindMapNode(
            id: 'bookmark_${b.id}',
            label: b.title,
            subtitle: _extractDomain(b.url).toUpperCase(),
            color: parentColor,
            isLeaf: true,
            bookmark: b,
          ));
        }
      }

      return list;
    }

    // Add top-level folder branches
    root.children.addAll(buildFolderChildren(null, Colors.grey));

    // Add top-level uncategorized bookmarks
    if (uncategorized.isNotEmpty) {
      final uncColor = _accentColors[colorIdx++ % _accentColors.length];
      final uncNode = MindMapNode(
        id: 'uncategorized',
        label: 'UNCATEGORIZED',
        color: uncColor,
        isLeaf: false,
        childCount: uncategorized.length,
      );
      if (_expandedNodes.contains('uncategorized')) {
        for (final b in uncategorized) {
          uncNode.children.add(MindMapNode(
            id: 'bookmark_${b.id}',
            label: b.title,
            subtitle: _extractDomain(b.url).toUpperCase(),
            color: uncColor,
            isLeaf: true,
            bookmark: b,
          ));
        }
      }
      root.children.add(uncNode);
    }

    return root;
  }

  MindMapNode _buildCategoriesTree(List<Bookmark> bookmarks) {
    final root = MindMapNode(
      id: 'root',
      label: 'CATEGORIES',
      color: Colors.grey,
      isLeaf: false,
    );

    // Group by category string
    final categoryBookmarks = <String, List<Bookmark>>{};
    final uncategorized = <Bookmark>[];
    for (final b in bookmarks) {
      if (b.category == null || b.category!.trim().isEmpty) {
        uncategorized.add(b);
      } else {
        categoryBookmarks.putIfAbsent(b.category!, () => []).add(b);
      }
    }

    int colorIdx = 0;
    for (final entry in categoryBookmarks.entries) {
      final catColor = _accentColors[colorIdx++ % _accentColors.length];
      final catNode = MindMapNode(
        id: 'category_${entry.key}',
        label: entry.key.toUpperCase(),
        color: catColor,
        isLeaf: false,
        childCount: entry.value.length,
      );
      if (_expandedNodes.contains(catNode.id)) {
        for (final b in entry.value) {
          catNode.children.add(MindMapNode(
            id: 'bookmark_${b.id}',
            label: b.title,
            subtitle: _extractDomain(b.url).toUpperCase(),
            color: catColor,
            isLeaf: true,
            bookmark: b,
          ));
        }
      }
      root.children.add(catNode);
    }

    if (uncategorized.isNotEmpty) {
      final uncColor = _accentColors[colorIdx++ % _accentColors.length];
      final uncNode = MindMapNode(
        id: 'uncategorized_cat',
        label: 'UNCATEGORIZED',
        color: uncColor,
        isLeaf: false,
        childCount: uncategorized.length,
      );
      if (_expandedNodes.contains('uncategorized_cat')) {
        for (final b in uncategorized) {
          uncNode.children.add(MindMapNode(
            id: 'bookmark_${b.id}',
            label: b.title,
            subtitle: _extractDomain(b.url).toUpperCase(),
            color: uncColor,
            isLeaf: true,
            bookmark: b,
          ));
        }
      }
      root.children.add(uncNode);
    }

    return root;
  }

  // Helper utils
  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return url;
    }
  }

  double _getMaxX(MindMapNode node) {
    double mx = node.x + node.width;
    for (final child in node.children) {
      final childMaxX = _getMaxX(child);
      if (childMaxX > mx) {
        mx = childMaxX;
      }
    }
    return mx;
  }

  void _adjustYCoordinates(MindMapNode node, double offset) {
    node.y += offset;
    for (final child in node.children) {
      _adjustYCoordinates(child, offset);
    }
  }

  void _collectVisibleNodes(MindMapNode node, List<MindMapNode> list) {
    list.add(node);
    for (final child in node.children) {
      _collectVisibleNodes(child, list);
    }
  }
}

// ── Tree Layout Algorithm ────────────────────────────────────

class TreeLayout {
  final double horizontalGap = 64.0;
  final double verticalSpacing = 16.0;

  final double rootWidth = 140.0;
  final double rootHeight = 44.0;
  final double folderWidth = 170.0;
  final double folderHeight = 46.0;
  final double bookmarkWidth = 230.0;
  final double bookmarkHeight = 60.0;

  double getNodeWidth(MindMapNode node) {
    if (node.id == 'root') return rootWidth;
    return node.isLeaf ? bookmarkWidth : folderWidth;
  }

  double getNodeHeight(MindMapNode node) {
    if (node.id == 'root') return rootHeight;
    return node.isLeaf ? bookmarkHeight : folderHeight;
  }

  double performLayout(MindMapNode root) {
    root.x = 24.0;
    root.width = getNodeWidth(root);
    root.height = getNodeHeight(root);

    return _layoutNode(root, 0, 24.0);
  }

  double _layoutNode(MindMapNode node, int depth, double currentY) {
    node.width = getNodeWidth(node);
    node.height = getNodeHeight(node);

    if (node.children.isEmpty) {
      node.y = currentY;
      return currentY + node.height + verticalSpacing;
    } else {
      double childY = currentY;
      double firstChildY = 0;
      double lastChildY = 0;

      for (int i = 0; i < node.children.length; i++) {
        final child = node.children[i];
        child.x = node.x + node.width + horizontalGap;
        childY = _layoutNode(child, depth + 1, childY);
        if (i == 0) firstChildY = child.y;
        if (i == node.children.length - 1) lastChildY = child.y;
      }

      // Center parent vertically relative to children
      node.y = (firstChildY + lastChildY) / 2;
      return childY;
    }
  }
}

// ── Custom Painter for Orthogonal Lines ──────────────────────

class MindMapPainter extends CustomPainter {
  final List<MindMapNode> nodes;
  final Brightness brightness;
  final Color lineColor;

  MindMapPainter({
    required this.nodes,
    required this.brightness,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final arrowPaint = Paint()
      ..style = PaintingStyle.fill;

    for (final node in nodes) {
      for (final child in node.children) {
        // Line starts at parent middle right edge
        final double x1 = node.x + node.width;
        final double y1 = node.y + node.height / 2;

        // Line ends at child middle left edge
        final double x2 = child.x;
        final double y2 = child.y + child.height / 2;

        // Orthogonal (step) layout paths
        final path = Path();
        path.moveTo(x1, y1);

        final double midX = x1 + (x2 - x1) / 2;
        path.lineTo(midX, y1);
        path.lineTo(midX, y2);
        path.lineTo(x2, y2);

        // Draw line in child's color for high fidelity track tracing
        final Color trackColor = child.isLeaf ? node.color : child.color;
        paint.color = trackColor == Colors.grey ? lineColor : trackColor.withOpacity(0.85);

        canvas.drawPath(path, paint);

        // Draw blocky triangular arrow pointing right
        arrowPaint.color = paint.color;
        final arrowPath = Path();
        arrowPath.moveTo(x2, y2);
        arrowPath.lineTo(x2 - 6, y2 - 4);
        arrowPath.lineTo(x2 - 6, y2 + 4);
        arrowPath.close();
        canvas.drawPath(arrowPath, arrowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MindMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.brightness != brightness ||
        oldDelegate.lineColor != lineColor;
  }
}
