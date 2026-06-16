import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:link_saver/core/database/app_database.dart';
import 'package:link_saver/core/providers/share_intent_provider.dart';
import 'package:link_saver/core/router/app_router.dart';
import 'package:link_saver/core/theme/app_theme.dart';
import 'package:link_saver/core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    _loadThemePreferences();
    _initSharingIntent();
  }

  void _loadThemePreferences() {
    // Restore persisted theme mode and style from SharedPreferences
    ref.read(themeNotifierProvider.notifier).loadSaved();
    ref.read(themeStyleNotifierProvider.notifier).loadSaved();
  }

  void _initSharingIntent() {
    // Cold start: app opened via share intent
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isEmpty) return;
      final url = files.first.path.trim();
      if (url.isNotEmpty) {
        // Store in Riverpod — survives state recreation
        ref.read(pendingSharedUrlProvider.notifier).state = url;
      }
      // Always reset immediately so it never fires a second time
      ReceiveSharingIntent.instance.reset();
    });

    // App already running: user shares into it
    ReceiveSharingIntent.instance.getMediaStream().listen((files) {
      if (files.isEmpty) return;
      final url = files.first.path.trim();
      if (url.isNotEmpty) {
        ref.read(pendingSharedUrlProvider.notifier).state = url;
      }
      ReceiveSharingIntent.instance.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final themeStyle = ref.watch(themeStyleNotifierProvider);

    final lightTheme = themeStyle == ThemeStyle.neoBrutalist
        ? AppTheme.neoBrutalistLightTheme
        : AppTheme.lightTheme;
    final darkTheme = themeStyle == ThemeStyle.neoBrutalist
        ? AppTheme.neoBrutalistDarkTheme
        : AppTheme.darkTheme;

    return MaterialApp.router(
      title: 'LinkSaver',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}
