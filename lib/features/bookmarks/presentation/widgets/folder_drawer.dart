import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/core/database/app_database.dart' as db;
import 'package:link_saver/shared/widgets/scale_on_tap.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';


class FolderDrawer extends ConsumerWidget {
  const FolderDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foldersAsync = ref.watch(folderListProvider);
    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: isNeo ? BorderSide(color: theme.colorScheme.outline, width: 2.0) : BorderSide.none,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FOLDERS',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      fontFamily: isNeo ? 'JetBrainsMono' : null,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Section Divider
            Divider(height: 1, color: theme.colorScheme.outline.withOpacity(isNeo ? 1.0 : 0.5)),
            
            const SizedBox(height: 16),
            
            // Library Header Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'LIBRARY',
                  style: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            
            // All Bookmarks Tile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _DrawerTile(
                title: 'ALL BOOKMARKS',
                icon: Icons.bookmarks_rounded,
                isSelected: selectedFolderId == null,
                onTap: () {
                  ref.read(selectedFolderIdProvider.notifier).setFolder(null);
                  Navigator.of(context).pop();
                },
              ),
            ),
            
            // Scrollable Folders List
            Expanded(
              child: foldersAsync.when(
                data: (folders) {
                  if (folders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'NO FOLDERS YET',
                          style: theme.textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w900,
                            fontFamily: isNeo ? 'JetBrainsMono' : null,
                            color: theme.colorScheme.onSurface.withOpacity(0.35),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      final isSelected = selectedFolderId == folder.id.toString();
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _DrawerTile(
                          title: folder.name.toUpperCase(),
                          icon: Icons.folder_open_rounded,
                          isSelected: isSelected,
                          onTap: () {
                            ref.read(selectedFolderIdProvider.notifier).setFolder(folder.id.toString());
                            Navigator.of(context).pop();
                          },
                          trailing: IconButton(
                            icon: Icon(
                              Icons.more_horiz_rounded, 
                              color: isSelected 
                                  ? (isNeo ? theme.colorScheme.onPrimary.withOpacity(0.6) : theme.colorScheme.surface.withOpacity(0.6))
                                  : theme.colorScheme.onSurface.withOpacity(0.4),
                              size: 20,
                            ),
                            onPressed: () => _showFolderOptions(context, ref, folder),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: SizedBox(
                    width: 24, 
                    height: 24, 
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (err, _) => Center(
                  child: Text('Error loading folders: $err', style: const TextStyle(fontSize: 12)),
                ),
              ),
            ),
            
            // Create Folder Button at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: isNeo
                    ? BrutalistPress(
                        onTap: () => _showCreateFolderDialog(context, ref),
                        isCard: true,
                        backgroundColor: theme.colorScheme.surface,
                        borderColor: theme.colorScheme.outline,
                        borderRadius: 12.0,
                        shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                        shadowOffset: const Offset(3.0, 3.0),
                        child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_rounded, size: 20, color: theme.colorScheme.onSurface),
                              const SizedBox(width: 8),
                              Text(
                                'CREATE NEW FOLDER',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                  fontSize: 12,
                                  fontFamily: 'JetBrainsMono',
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => _showCreateFolderDialog(context, ref),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text(
                          'CREATE NEW FOLDER', 
                          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface,
                          side: BorderSide(color: theme.colorScheme.outline, width: 0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFolderOptions(BuildContext context, WidgetRef ref, db.Folder folder) {
    final theme = Theme.of(context);
    final themeStyle = ref.read(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: isNeo ? Border(top: BorderSide(color: theme.colorScheme.outline, width: 2.0)) : null,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FOLDER OPTIONS: ${folder.name.toUpperCase()}', 
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900, 
                letterSpacing: 1.5,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            _OptionTile(
              title: 'Rename Folder',
              icon: Icons.edit_note_rounded,
              onTap: () {
                Navigator.pop(ctx);
                _showRenameFolderDialog(context, ref, folder);
              },
            ),
            const SizedBox(height: 12),
            _OptionTile(
              title: 'Delete Folder',
              icon: Icons.delete_outline_rounded,
              isDestructive: true,
              onTap: () {
                Navigator.pop(ctx);
                _showDeleteConfirmationDialog(context, ref, folder);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.read(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isNeo ? 12 : 12),
          side: isNeo ? BorderSide(color: theme.colorScheme.outline, width: 2.0) : BorderSide.none,
        ),
        title: Text(
          'NEW FOLDER', 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 16, 
            letterSpacing: 0.5,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
          decoration: InputDecoration(
            hintText: 'Folder name',
            filled: true,
            fillColor: theme.colorScheme.surfaceContainer,
            border: isNeo
                ? OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5))
                : OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            enabledBorder: isNeo
                ? OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5))
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(
              'CANCEL', 
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                color: Colors.grey,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(folderListProvider.notifier).addFolder(controller.text.trim());
                Navigator.pop(context);
              }
            }, 
            child: Text(
              'CREATE', 
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                color: theme.colorScheme.onSurface,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRenameFolderDialog(BuildContext context, WidgetRef ref, db.Folder folder) {
    final theme = Theme.of(context);
    final themeStyle = ref.read(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final controller = TextEditingController(text: folder.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isNeo ? 12 : 12),
          side: isNeo ? BorderSide(color: theme.colorScheme.outline, width: 2.0) : BorderSide.none,
        ),
        title: Text(
          'RENAME FOLDER', 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 16, 
            letterSpacing: 0.5,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
          decoration: InputDecoration(
            hintText: 'New folder name',
            filled: true,
            fillColor: theme.colorScheme.surfaceContainer,
            border: isNeo
                ? OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5))
                : OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            enabledBorder: isNeo
                ? OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5))
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(
              'CANCEL', 
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                color: Colors.grey,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(folderListProvider.notifier).editFolder(folder.id, controller.text.trim());
                Navigator.pop(context);
              }
            }, 
            child: Text(
              'RENAME', 
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                color: theme.colorScheme.onSurface,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, db.Folder folder) {
    final theme = Theme.of(context);
    final themeStyle = ref.read(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isNeo ? 12 : 12),
          side: isNeo ? BorderSide(color: theme.colorScheme.outline, width: 2.0) : BorderSide.none,
        ),
        title: Text(
          'DELETE FOLDER?', 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 16, 
            letterSpacing: 0.5, 
            color: Colors.red,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${folder.name.toUpperCase()}"?\n\nBookmarks inside this folder will not be deleted, they will simply be returned to your main library.',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(
              'CANCEL', 
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                color: Colors.grey,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(folderListProvider.notifier).deleteFolder(folder.id);
              Navigator.pop(context);
            }, 
            child: Text(
              'DELETE', 
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                color: Colors.red,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends ConsumerWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing;

  const _DrawerTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryAccent = theme.colorScheme.primary;
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final double radius = isNeo ? 12.0 : 10.0;
    final double borderWidth = isNeo ? 1.5 : 0.8;
    final borderColor = isSelected 
        ? (isNeo ? Colors.black : primaryAccent)
        : theme.colorScheme.outline;

    final shadow = isNeo
        ? [
            BoxShadow(
              color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
              offset: isSelected ? Offset.zero : const Offset(2.0, 2.0),
              blurRadius: 0,
            )
          ]
        : null;

    final tileColor = isSelected
        ? (isNeo ? theme.colorScheme.primary : primaryAccent.withOpacity(0.12))
        : (isNeo ? theme.colorScheme.surface : Colors.transparent);

    final textColor = isSelected
        ? (isNeo ? Colors.black : primaryAccent)
        : theme.colorScheme.onSurface;

    Widget childWidget = Container(
      height: 48,
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor, 
          width: borderWidth,
        ),
        boxShadow: shadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon, 
            color: textColor, 
            size: 18,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (isNeo) {
      return BrutalistPress(
        onTap: onTap,
        child: childWidget,
      );
    } else {
      return ScaleOnTap(
        onTap: onTap,
        child: childWidget,
      );
    }
  }
}

class _OptionTile extends ConsumerWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const _OptionTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;
    
    final color = isDestructive ? Colors.red : theme.colorScheme.onSurface;
    final double radius = isNeo ? 12.0 : 10.0;
    final double borderWidth = isNeo ? 1.5 : 0.8;
    
    final borderColor = isDestructive 
        ? (isNeo ? theme.colorScheme.outline : Colors.red.withOpacity(0.3)) 
        : theme.colorScheme.outline;

    final shadow = isNeo
        ? [
            BoxShadow(
              color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
              offset: const Offset(2.0, 2.0),
              blurRadius: 0,
            )
          ]
        : null;

    final cardBg = isNeo 
        ? (isDestructive ? Colors.red.withOpacity(0.1) : theme.colorScheme.surfaceContainer)
        : Colors.transparent;

    Widget childWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(
          color: borderColor, 
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 16),
          Text(
            title, 
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontFamily: isNeo ? 'JetBrainsMono' : null,
              color: color,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded, 
            size: 12, 
            color: color.withOpacity(0.2),
          ),
        ],
      ),
    );

    if (isNeo) {
      return BrutalistPress(
        onTap: onTap,
        child: childWidget,
      );
    } else {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: childWidget,
      );
    }
  }
}
