import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';

class BookmarkCard extends ConsumerWidget {
  final Bookmark bookmark;
  final VoidCallback onTap;

  const BookmarkCard({
    super.key,
    required this.bookmark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final double radius = isNeo ? 12.0 : 16.0;

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
        : [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ];

    final decoration = BoxDecoration(
      color: isNeo ? (isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface) : theme.cardTheme.color,
      borderRadius: BorderRadius.circular(radius),
      border: border,
      boxShadow: shadow,
    );

    Widget buildCardContent() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          if (bookmark.thumbnailUrl != null)
            Hero(
              tag: 'bookmark-image-${bookmark.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(radius - (isNeo ? 1.5 : 1))),
                child: CachedNetworkImage(
                  imageUrl: bookmark.thumbnailUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                  placeholder: (context, url) => Container(height: 100, color: theme.colorScheme.outline.withOpacity(0.05)),
                  errorWidget: (context, url, error) => const SizedBox.shrink(),
                ),
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta Row
                Row(
                  children: [
                    if (bookmark.faviconUrl != null)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                        child: CachedNetworkImage(imageUrl: bookmark.faviconUrl!, width: 12, height: 12),
                      )
                    else
                      Icon(Icons.language_rounded, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _extractDomain(bookmark.url).toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          fontFamily: isNeo ? 'JetBrainsMono' : null,
                          color: theme.colorScheme.onSurface.withOpacity(0.35),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (bookmark.isFavorite)
                      Icon(Icons.favorite_rounded, size: 14, color: isNeo ? theme.colorScheme.onSurface : theme.colorScheme.onSurface),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  bookmark.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                    letterSpacing: -0.4,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Description
                if (bookmark.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    bookmark.description!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Date
                const SizedBox(height: 16),
                Text(
                  _formatDate(bookmark.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                    color: theme.colorScheme.onSurface.withOpacity(isNeo ? 0.4 : 0.2),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return BrutalistPress(
      onTap: onTap,
      isCard: isNeo,
      backgroundColor: isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface,
      borderColor: theme.colorScheme.outline,
      borderWidth: 1.5,
      borderRadius: radius,
      shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
      shadowOffset: const Offset(3.0, 3.0),
      child: isNeo
          ? Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius - 1.5),
              ),
              child: buildCardContent(),
            )
          : Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              decoration: decoration,
              clipBehavior: Clip.antiAlias,
              child: buildCardContent(),
            ),
    );
  }

  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceAll('www.', '');
    } catch (_) {
      return url;
    }
  }

  String _formatDate(DateTime dt) {
    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
