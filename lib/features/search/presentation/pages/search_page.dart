import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:link_saver/features/bookmarks/presentation/widgets/bookmark_card.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';
import 'package:link_saver/shared/widgets/staggered_entrance.dart';

final _searchQueryProvider = StateProvider<String>((ref) => '');

final _searchResultsProvider = FutureProvider.autoDispose.family((ref, String query) async {
  if (query.isEmpty) return [];
  return ref.watch(bookmarkRepositoryProvider).searchBookmarks(query);
});

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final query = ref.watch(_searchQueryProvider);
    final resultsAsync = ref.watch(_searchResultsProvider(query));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: BrutalistPress(
          onTap: () => context.pop(),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => context.pop(),
          ),
        ),
        title: isNeo
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrainsMono',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search bookmarks...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      fontFamily: 'JetBrainsMono',
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    filled: false,
                  ),
                  onChanged: (value) {
                    // Debounce via a short delay
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (_controller.text == value) {
                        ref.read(_searchQueryProvider.notifier).state = value.trim();
                      }
                    });
                  },
                ),
              )
            : TextField(
                controller: _controller,
                autofocus: true,
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'Search bookmarks...',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  // Debounce via a short delay
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (_controller.text == value) {
                      ref.read(_searchQueryProvider.notifier).state = value.trim();
                    }
                  });
                },
              ),
        actions: [
          if (_controller.text.isNotEmpty)
            BrutalistPress(
              onTap: () {
                _controller.clear();
                ref.read(_searchQueryProvider.notifier).state = '';
                setState(() {});
              },
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () {
                  _controller.clear();
                  ref.read(_searchQueryProvider.notifier).state = '';
                  setState(() {});
                },
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: isNeo ? theme.colorScheme.outline : theme.colorScheme.outline.withOpacity(0.5),
            thickness: isNeo ? 1.5 : 0.5,
          ),
        ),
      ),
      body: query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: isNeo ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: isNeo ? BorderRadius.circular(12) : null,
                      border: Border.all(color: theme.colorScheme.outline, width: isNeo ? 2.0 : 1.5),
                      color: isNeo ? theme.colorScheme.surfaceContainer : null,
                      boxShadow: isNeo
                          ? [
                              BoxShadow(
                                color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                                offset: const Offset(3.0, 3.0),
                                blurRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      size: 32,
                      color: isNeo ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'START TYPING TO SEARCH',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontFamily: isNeo ? 'JetBrainsMono' : null,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            )
          : resultsAsync.when(
              data: (results) {
                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: isNeo ? BoxShape.rectangle : BoxShape.circle,
                            borderRadius: isNeo ? BorderRadius.circular(12) : null,
                            border: Border.all(color: theme.colorScheme.outline, width: isNeo ? 2.0 : 1.5),
                            color: isNeo ? theme.colorScheme.surfaceContainer : null,
                            boxShadow: isNeo
                                ? [
                                    BoxShadow(
                                      color: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
                                      offset: const Offset(3.0, 3.0),
                                      blurRadius: 0,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.search_off_rounded,
                            size: 32,
                            color: isNeo ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'NO RESULTS FOR "$query"',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontFamily: isNeo ? 'JetBrainsMono' : null,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final bookmark = results[index];
                    return StaggeredEntrance(
                      index: index,
                      child: BookmarkCard(
                        bookmark: bookmark,
                        onTap: () {
                          context.push('/bookmark/${bookmark.id}', extra: bookmark);
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 3)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            ),
    );
  }
}
