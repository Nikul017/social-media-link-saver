import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/features/bookmarks/presentation/services/metadata_service.dart';
import 'package:link_saver/core/database/app_database.dart' as db;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:link_saver/shared/widgets/scale_on_tap.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';
import 'package:link_saver/core/theme/theme_provider.dart';

const _kCategories = [
  '📰 Articles', '🎥 Videos', '🛠 Tools', '🎨 Design',
  '💻 Tech', '💰 Finance', '📚 Learning', '🎮 Entertainment',
  '🌐 News', '🔖 Other',
];

class AddBookmarkSheet extends ConsumerStatefulWidget {
  final String? initialUrl;
  final Bookmark? bookmarkToEdit;
  const AddBookmarkSheet({super.key, this.initialUrl, this.bookmarkToEdit});

  @override
  ConsumerState<AddBookmarkSheet> createState() => _AddBookmarkSheetState();
}

class _AddBookmarkSheetState extends ConsumerState<AddBookmarkSheet> {
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  
  String? _selectedCategory;
  int? _selectedFolderId;
  
  bool _isSaving = false;
  bool _isFetchingMetadata = false;
  LinkMetadata? _previewMetadata;

  @override
  void initState() {
    super.initState();
    if (widget.bookmarkToEdit != null) {
      final b = widget.bookmarkToEdit!;
      _urlController.text = b.url;
      _titleController.text = b.title;
      _noteController.text = b.notes ?? '';
      _selectedCategory = b.category;
      _selectedFolderId = b.folderId != null ? int.tryParse(b.folderId!) : null;
    } else if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
      _fetchMetadata(widget.initialUrl!);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _fetchMetadata(String url) async {
    if (url.isEmpty || !url.contains('://')) return;
    setState(() => _isFetchingMetadata = true);
    final meta = await ref.read(metadataServiceProvider.notifier).fetchMetadata(url);
    if (mounted && meta != null) {
      setState(() {
        _previewMetadata = meta;
        if (_titleController.text.isEmpty) _titleController.text = meta.title;
        _isFetchingMetadata = false;
      });
    } else if (mounted) {
      setState(() => _isFetchingMetadata = false);
    }
  }

  Future<void> _save() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a URL')));
      return;
    }
    setState(() => _isSaving = true);
    final title = _titleController.text.trim();
    final bookmark = Bookmark(
      id: widget.bookmarkToEdit?.id ?? '',
      url: url,
      title: title.isEmpty ? (_previewMetadata?.title ?? url) : title,
      description: _previewMetadata?.description ?? widget.bookmarkToEdit?.description,
      thumbnailUrl: _previewMetadata?.thumbnailUrl ?? widget.bookmarkToEdit?.thumbnailUrl,
      faviconUrl: _previewMetadata?.faviconUrl ?? widget.bookmarkToEdit?.faviconUrl,
      createdAt: widget.bookmarkToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      notes: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      tags: null, // Tags removed
      category: _selectedCategory,
      folderId: _selectedFolderId?.toString(),
    );
    await ref.read(bookmarkListProvider.notifier).addBookmark(bookmark);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foldersAsync = ref.watch(folderListProvider);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final saveButton = _isSaving 
           ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 3))
           : Text(
               'SAVE LINK', 
               style: TextStyle(
                 fontWeight: FontWeight.w900, 
                 letterSpacing: 1.0,
                 fontFamily: isNeo ? 'JetBrainsMono' : null,
                 color: isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.surface,
               ),
             );

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: isNeo ? Border(top: BorderSide(color: theme.colorScheme.outline, width: 2.0)) : null,
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.bookmarkToEdit != null ? 'Edit Link' : 'New Link', 
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900, 
                    letterSpacing: -0.5,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, weight: 800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_previewMetadata != null || _isFetchingMetadata)
              _MetadataPreview(metadata: _previewMetadata, isLoading: _isFetchingMetadata),
            
            const SizedBox(height: 16),
            _buildLabel(context, 'URL', isNeo),
            const SizedBox(height: 6),
            _buildTextField(context, controller: _urlController, hint: 'https://...', icon: Icons.link_rounded, 
                           onChanged: (val) => {if (val.length > 10) _fetchMetadata(val)}),
            
            const SizedBox(height: 16),
            _buildLabel(context, 'Title', isNeo),
            const SizedBox(height: 6),
            _buildTextField(context, controller: _titleController, hint: 'Auto-detected', icon: Icons.title_rounded),
            
            const SizedBox(height: 16),
            _buildLabel(context, 'Personal Notes', isNeo),
            const SizedBox(height: 6),
            _buildTextField(context, controller: _noteController, hint: 'Add some thoughts...', icon: Icons.notes_rounded, maxLines: 2),

            const SizedBox(height: 24),
            _buildLabel(context, 'Category', isNeo),
            const SizedBox(height: 10),
            _CategoryChips(selected: _selectedCategory, onSelect: (c) => setState(() => _selectedCategory = (_selectedCategory == c) ? null : c)),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel(context, 'Folder', isNeo),
                GestureDetector(
                  onTap: _showCreateFolderDialog,
                  child: Text(
                    '+ NEW FOLDER', 
                    style: TextStyle(
                      color: theme.colorScheme.onSurface, 
                      fontSize: 10, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 0.5,
                      fontFamily: isNeo ? 'JetBrainsMono' : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            foldersAsync.when(
              data: (folders) => _FolderSelector(
                folders: folders, selectedId: _selectedFolderId,
                onSelect: (id) => setState(() => _selectedFolderId = (_selectedFolderId == id) ? null : id),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stackTrace) => const Text('Error loading folders'),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: isNeo
                  ? BrutalistPress(
                      onTap: _isSaving ? null : _save,
                      isCard: true,
                      backgroundColor: theme.colorScheme.primary,
                      borderColor: theme.colorScheme.outline,
                      borderRadius: 12.0,
                      shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                      shadowOffset: const Offset(3.0, 3.0),
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        child: saveButton,
                      ),
                    )
                  : ScaleOnTap(
                      onTap: _isSaving ? null : _save,
                      child: FilledButton(
                        onPressed: _isSaving ? null : _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.onSurface,
                          foregroundColor: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: saveButton,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text, bool isNeo) {
    return Text(
      text.toUpperCase(), 
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w900, 
        letterSpacing: 1.2, 
        fontFamily: isNeo ? 'JetBrainsMono' : null,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required TextEditingController controller, required String hint, required IconData icon, int maxLines = 1, Function(String)? onChanged, Function(String)? onSubmitted, Widget? suffix}) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final border = isNeo
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline,
              width: 1.5,
            ),
          )
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      style: TextStyle(
        fontWeight: FontWeight.w600, 
        fontSize: 14,
        fontFamily: isNeo ? 'JetBrainsMono' : null,
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainer,
        prefixIcon: Icon(icon, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.4)),
        suffixIcon: suffix,
        border: border,
        enabledBorder: border,
        focusedBorder: isNeo
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white : Colors.black,
                  width: 2.0,
                ),
              )
            : border,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Folder', style: TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(
          controller: controller, 
          autofocus: true, 
          decoration: InputDecoration(
            hintText: 'Folder name',
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          TextButton(onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              ref.read(folderListProvider.notifier).addFolder(controller.text.trim());
              Navigator.pop(context);
            }
          }, child: Text('CREATE', style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary))),
        ],
      ),
    );
  }
}

class _MetadataPreview extends ConsumerWidget {
  final LinkMetadata? metadata;
  final bool isLoading;
  const _MetadataPreview({required this.metadata, required this.isLoading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final border = isNeo
        ? Border.all(color: theme.colorScheme.outline, width: 1.5)
        : Border.all(color: theme.colorScheme.outline.withOpacity(0.1), width: 1);

    final double radius = isNeo ? 12.0 : 12.0;

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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: isNeo ? Border.all(color: theme.colorScheme.outline, width: 1.0) : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : metadata?.thumbnailUrl != null
                    ? CachedNetworkImage(imageUrl: metadata!.thumbnailUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.link_rounded, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoading ? 'Fetching details...' : (metadata?.title ?? 'No title'), 
                  style: TextStyle(
                    fontWeight: FontWeight.w800, 
                    fontSize: 13,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                  ), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isLoading && metadata?.description != null)
                  Text(
                    metadata!.description!, 
                    style: TextStyle(
                      fontSize: 11, 
                      color: theme.colorScheme.onSurface.withOpacity(0.5), 
                      fontWeight: FontWeight.w500,
                    ), 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends ConsumerWidget {
  final String? selected;
  final void Function(String) onSelect;
  const _CategoryChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _kCategories.map((cat) {
          final isSelected = selected == cat;
          
          final double radius = isNeo ? 8.0 : 10.0;
          final double borderWidth = isNeo ? 1.5 : 1.0;
          final borderColor = isSelected 
              ? theme.colorScheme.onSurface 
              : (isNeo ? theme.colorScheme.outline : theme.colorScheme.outline.withOpacity(0.1));
          
          final shadow = isNeo
              ? [
                  BoxShadow(
                    color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                    offset: isSelected ? Offset.zero : const Offset(2.0, 2.0),
                    blurRadius: 0,
                  )
                ]
              : null;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: BrutalistPress(
              onTap: () => onSelect(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (isNeo ? theme.colorScheme.primary : theme.colorScheme.onSurface) 
                      : theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: borderColor, width: borderWidth),
                  boxShadow: shadow,
                ),
                child: Text(
                  cat, 
                  style: TextStyle(
                    fontSize: 12, 
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600, 
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                    color: isSelected 
                        ? (isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.surface) 
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FolderSelector extends ConsumerWidget {
  final List<db.Folder> folders;
  final int? selectedId;
  final void Function(int) onSelect;
  const _FolderSelector({required this.folders, required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    if (folders.isEmpty) return Text('No folders yet', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4)));
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: folders.map((folder) {
          final isSelected = selectedId == folder.id;
          
          final double radius = isNeo ? 8.0 : 10.0;
          final double borderWidth = isNeo ? 1.5 : 1.0;
          final borderColor = isSelected 
              ? theme.colorScheme.onSurface 
              : (isNeo ? theme.colorScheme.outline : theme.colorScheme.outline.withOpacity(0.1));
          
          final shadow = isNeo
              ? [
                  BoxShadow(
                    color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                    offset: isSelected ? Offset.zero : const Offset(2.0, 2.0),
                    blurRadius: 0,
                  )
                ]
              : null;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: BrutalistPress(
              onTap: () => onSelect(folder.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (isNeo ? theme.colorScheme.primary : theme.colorScheme.onSurface) 
                      : theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: borderColor, width: borderWidth),
                  boxShadow: shadow,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_rounded, 
                      size: 14, 
                      color: isSelected 
                          ? (isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.surface) 
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      folder.name, 
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600, 
                        fontFamily: isNeo ? 'JetBrainsMono' : null,
                        color: isSelected 
                            ? (isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.surface) 
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
