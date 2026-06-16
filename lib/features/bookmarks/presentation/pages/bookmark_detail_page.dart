import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:link_saver/features/bookmarks/presentation/widgets/add_bookmark_sheet.dart';
import 'package:link_saver/shared/widgets/scale_on_tap.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookmarkDetailPage extends ConsumerWidget {
  final Bookmark bookmark;
  const BookmarkDetailPage({super.key, required this.bookmark});

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Bookmark bm) async {
    final theme = Theme.of(context);
    final themeStyle = ref.read(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isNeo ? 12 : 16),
          side: isNeo ? BorderSide(color: theme.colorScheme.outline, width: 2.0) : BorderSide.none,
        ),
        title: Text(
          'Delete Bookmark?',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
        ),
        content: Text(
          'This cannot be undone.',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'DELETE',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(bookmarkListProvider.notifier).deleteBookmark(bm.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkAsync = ref.watch(bookmarkStreamProvider(bookmark.id));

    return bookmarkAsync.when(
      data: (bm) => bm == null ? Scaffold(appBar: AppBar(), body: const Center(child: Text('Not found'))) : _buildContent(context, ref, bm),
      loading: () => _buildContent(context, ref, bookmark),
      error: (err, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Bookmark bm) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'LINK DETAILS',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        leading: BrutalistPress(
          onTap: () => Navigator.of(context).pop(),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          BrutalistPress(
            onTap: () => ref.read(bookmarkListProvider.notifier).toggleFavorite(bm.id),
            child: IconButton(
              icon: Icon(bm.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded, color: bm.isFavorite ? Colors.red : null),
              onPressed: () => ref.read(bookmarkListProvider.notifier).toggleFavorite(bm.id),
            ),
          ),
          BrutalistPress(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddBookmarkSheet(bookmarkToEdit: bm),
              );
            },
            child: IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddBookmarkSheet(bookmarkToEdit: bm),
                );
              },
            ),
          ),
          BrutalistPress(
            onTap: () => _delete(context, ref, bm),
            child: IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.red),
              onPressed: () => _delete(context, ref, bm),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.colorScheme.outline.withOpacity(isNeo ? 1.0 : 0.5)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image Hero
            if (bm.thumbnailUrl != null) ...[
              Hero(
                tag: 'bookmark-image-${bm.id}',
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isNeo ? 12.0 : 16.0),
                    border: isNeo
                        ? Border.all(color: theme.colorScheme.outline, width: 2.0)
                        : Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                    boxShadow: isNeo
                        ? [
                            BoxShadow(
                              color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                              offset: const Offset(4.0, 4.0),
                              blurRadius: 0,
                            )
                          ]
                        : null,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: bm.thumbnailUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: theme.colorScheme.outline.withOpacity(0.05)),
                    errorWidget: (context, url, error) => const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // URL Block
            _PremiumInfoCard(
              child: Row(
                children: [
                  Icon(Icons.link_rounded, color: theme.colorScheme.onSurface.withOpacity(0.4), size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bm.url,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600, 
                        color: theme.colorScheme.onSurface,
                        fontFamily: isNeo ? 'JetBrainsMono' : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  ScaleOnTap(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: bm.url));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                    },
                    child: IconButton(
                      icon: Icon(Icons.copy_rounded, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: bm.url));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const _PremiumSectionLabel(text: 'Title'),
            const SizedBox(height: 12),
            Text(
              bm.title, 
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900, 
                height: 1.2, 
                letterSpacing: -0.5,
                fontFamily: isNeo ? 'JetBrainsMono' : null,
              ),
            ),

            const SizedBox(height: 32),

            // Notes
            const _PremiumSectionLabel(text: 'Personal Notes'),
            const SizedBox(height: 12),
            _PremiumInfoCard(
              child: Text(
                bm.notes?.isNotEmpty == true ? bm.notes! : 'No personal notes added yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  fontFamily: isNeo ? 'JetBrainsMono' : null,
                  color: bm.notes?.isNotEmpty == true ? null : theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Category & Date
            Row(
              children: [
                if (bm.category != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _PremiumSectionLabel(text: 'Category'),
                        const SizedBox(height: 8),
                        Text(
                          bm.category!, 
                          style: TextStyle(
                            fontWeight: FontWeight.w800, 
                            fontSize: 14,
                            fontFamily: isNeo ? 'JetBrainsMono' : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _PremiumSectionLabel(text: 'Added On'),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(bm.createdAt), 
                        style: TextStyle(
                          fontWeight: FontWeight.w800, 
                          fontSize: 14,
                          fontFamily: isNeo ? 'JetBrainsMono' : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            height: 56,
            child: isNeo
                ? BrutalistPress(
                    onTap: () => _openUrl(bm.url),
                    isCard: true,
                    backgroundColor: theme.colorScheme.primary,
                    borderColor: theme.colorScheme.outline,
                    borderRadius: 12.0,
                    shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                    shadowOffset: const Offset(3.0, 3.0),
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.open_in_browser_rounded, color: theme.colorScheme.onPrimary),
                          const SizedBox(width: 8),
                          Text(
                            'OPEN IN BROWSER',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                              fontFamily: 'JetBrainsMono',
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ScaleOnTap(
                    onTap: () => _openUrl(bm.url),
                    child: FilledButton.icon(
                      onPressed: () => _openUrl(bm.url),
                      icon: const Icon(Icons.open_in_browser_rounded),
                      label: const Text('OPEN IN BROWSER', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.onSurface,
                        foregroundColor: theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

class _PremiumInfoCard extends ConsumerWidget {
  final Widget child;
  const _PremiumInfoCard({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final border = isNeo
        ? Border.all(color: theme.colorScheme.outline, width: 1.5)
        : Border.all(color: theme.colorScheme.outline.withOpacity(0.1));

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
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}

class _PremiumSectionLabel extends ConsumerWidget {
  final String text;
  const _PremiumSectionLabel({required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.35),
        letterSpacing: 1.5,
        fontWeight: FontWeight.w900,
        fontFamily: isNeo ? 'JetBrainsMono' : null,
        fontSize: 10,
      ),
    );
  }
}
