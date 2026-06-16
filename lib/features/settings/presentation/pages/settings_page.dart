import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/import_provider.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/export_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:link_saver/core/theme/theme_provider.dart';
import 'package:link_saver/shared/widgets/brutalist_press.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final importState = ref.watch(importNotifierProvider);
    final exportState = ref.watch(exportNotifierProvider);

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
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontFamily: isNeo ? 'JetBrainsMono' : null,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: isNeo ? theme.colorScheme.outline : theme.colorScheme.outline.withOpacity(0.5),
            thickness: isNeo ? 1.5 : 0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionHeader(context, 'Appearance', isNeo),
              const SizedBox(height: 12),
              _SettingsCard(
                title: 'Theme Style',
                subtitle: ref.watch(themeStyleNotifierProvider) == ThemeStyle.neoBrutalist ? 'Neo-Brutalist' : 'Classic B&W',
                icon: Icons.palette_rounded,
                onTap: () => _showStyleDialog(context, ref),
              ),
              const SizedBox(height: 12),
              _SettingsCard(
                title: 'Theme Mode',
                subtitle: ref.watch(themeNotifierProvider) == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                icon: ref.watch(themeNotifierProvider) == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                onTap: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(context, 'Data Management', isNeo),
              const SizedBox(height: 12),
              _SettingsCard(
                title: 'Import Bookmarks',
                subtitle: 'Import from PDF, CSV, or Excel',
                icon: Icons.upload_file_rounded,
                onTap: () => _handleImport(ref),
              ),
              const SizedBox(height: 12),
              _SettingsCard(
                title: 'Export Bookmarks',
                subtitle: 'Save your library as CSV, JSON, or Excel',
                icon: Icons.download_rounded,
                onTap: () => _showExportDialog(context, ref),
              ),
              const SizedBox(height: 12),
              _SettingsCard(
                title: 'Find Duplicate Links',
                subtitle: 'Scan and clean duplicate bookmarks',
                icon: Icons.copy_all_rounded,
                onTap: () => context.push('/duplicates'),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(context, 'About', isNeo),
              const SizedBox(height: 12),
              _SettingsCard(
                title: 'App Version',
                subtitle: '1.0.0 (Premium Edition)',
                icon: Icons.info_outline_rounded,
                onTap: null,
              ),
            ],
          ),
          if (importState is AsyncLoading || exportState is AsyncLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: theme.colorScheme.primary),
                        const SizedBox(height: 20),
                        const Text('Processing...', style: TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isNeo) {
    final theme = Theme.of(context);
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        letterSpacing: 2.0,
        fontWeight: FontWeight.w900,
        fontSize: 10,
        fontFamily: isNeo ? 'JetBrainsMono' : null,
        color: theme.colorScheme.onSurface.withOpacity(0.3),
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

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EXPORT FORMAT', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            const SizedBox(height: 24),
            _ExportOption(
              title: 'CSV (Spreadsheet)',
              icon: Icons.table_chart_rounded,
              onTap: () {
                Navigator.pop(ctx);
                ref.read(exportNotifierProvider.notifier).exportData(ExportFormat.csv);
              },
            ),
            const SizedBox(height: 12),
            _ExportOption(
              title: 'Excel (.xlsx)',
              icon: Icons.grid_on_rounded,
              onTap: () {
                Navigator.pop(ctx);
                ref.read(exportNotifierProvider.notifier).exportData(ExportFormat.excel);
              },
            ),
            const SizedBox(height: 12),
            _ExportOption(
              title: 'JSON (Developer Mode)',
              icon: Icons.code_rounded,
              onTap: () {
                Navigator.pop(ctx);
                ref.read(exportNotifierProvider.notifier).exportData(ExportFormat.json);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showStyleDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SELECT THEME STYLE', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            const SizedBox(height: 24),
            _StyleOption(
              title: 'Classic Black & White',
              description: 'Minimalist Notion-inspired styling',
              icon: Icons.brightness_medium_rounded,
              isSelected: themeStyle == ThemeStyle.classic,
              onTap: () {
                Navigator.pop(ctx);
                ref.read(themeStyleNotifierProvider.notifier).setStyle(ThemeStyle.classic);
              },
            ),
            const SizedBox(height: 12),
            _StyleOption(
              title: 'Neo-Brutalist',
              description: 'Bold borders, flat shadows & Cyber Yellow',
              icon: Icons.bolt_rounded,
              isSelected: themeStyle == ThemeStyle.neoBrutalist,
              onTap: () {
                Navigator.pop(ctx);
                ref.read(themeStyleNotifierProvider.notifier).setStyle(ThemeStyle.neoBrutalist);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends ConsumerWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final card = Container(
      decoration: isNeo
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.colorScheme.outline, width: 0.8),
            ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurface, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 11,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.2)),
        ],
      ),
    );

    if (onTap == null) return card;

    return BrutalistPress(
      onTap: onTap,
      isCard: isNeo,
      backgroundColor: isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface,
      borderColor: theme.colorScheme.outline,
      borderWidth: 1.5,
      borderRadius: 10,
      shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
      shadowOffset: const Offset(3.0, 3.0),
      child: card,
    );
  }
}

class _ExportOption extends ConsumerWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ExportOption({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: isNeo
          ? null
          : BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline, width: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurface, size: 20),
          const SizedBox(width: 16),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: isNeo ? 'JetBrainsMono' : null,
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.2)),
        ],
      ),
    );

    return BrutalistPress(
      onTap: onTap,
      isCard: isNeo,
      backgroundColor: isDark ? theme.colorScheme.surfaceContainer : theme.colorScheme.surface,
      borderColor: theme.colorScheme.outline,
      borderWidth: 1.5,
      borderRadius: 10,
      shadowColor: isDark ? Colors.white.withOpacity(0.15) : Colors.black,
      shadowOffset: const Offset(3.0, 3.0),
      child: card,
    );
  }
}

class _StyleOption extends ConsumerWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeStyle = ref.watch(themeStyleNotifierProvider);
    final isNeo = themeStyle == ThemeStyle.neoBrutalist;
    final isDark = theme.brightness == Brightness.dark;

    final border = isNeo
        ? (isSelected
            ? Border.all(color: theme.colorScheme.primary, width: 2.5)
            : Border.all(color: theme.colorScheme.outline, width: 1.5))
        : Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: isSelected ? 2.0 : 0.8,
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

    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? (isNeo ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.05))
            : null,
        boxShadow: isSelected ? shadow : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? (isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.primary)
                : theme.colorScheme.onSurface,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                    color: isSelected
                        ? (isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.primary)
                        : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 11,
                    fontFamily: isNeo ? 'JetBrainsMono' : null,
                    color: isSelected
                        ? (isNeo ? theme.colorScheme.onPrimary.withOpacity(0.7) : theme.colorScheme.onSurface.withOpacity(0.5))
                        : theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: isNeo ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
            ),
        ],
      ),
    );

    return BrutalistPress(
      onTap: onTap,
      child: card,
    );
  }
}
