import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_saver/features/auth/presentation/pages/splash_page.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/bookmark_detail_page.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/home_page.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/mind_map_page.dart';

import 'package:link_saver/features/search/presentation/pages/search_page.dart';
import 'package:link_saver/features/settings/presentation/pages/settings_page.dart';
import 'package:link_saver/features/bookmarks/presentation/pages/duplicate_finder_page.dart';

CustomTransitionPage<T> _buildPageWithFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeOutCubic).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 220),
  );
}

Page<T> _buildPageWithIOSSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CupertinoPage<T>(
    key: state.pageKey,
    child: child,
    name: state.name,
    arguments: state.extra,
  );
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/bookmark/:id',
      pageBuilder: (context, state) {
        final bookmark = state.extra as Bookmark;
        return _buildPageWithIOSSlideTransition(
          context: context,
          state: state,
          child: BookmarkDetailPage(bookmark: bookmark),
        );
      },
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => _buildPageWithIOSSlideTransition(
        context: context,
        state: state,
        child: const SearchPage(),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => _buildPageWithIOSSlideTransition(
        context: context,
        state: state,
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      path: '/duplicates',
      pageBuilder: (context, state) => _buildPageWithIOSSlideTransition(
        context: context,
        state: state,
        child: const DuplicateFinderPage(),
      ),
    ),
    GoRoute(
      path: '/mind-map',
      pageBuilder: (context, state) => _buildPageWithIOSSlideTransition(
        context: context,
        state: state,
        child: const MindMapPage(),
      ),
    ),
  ],
);
