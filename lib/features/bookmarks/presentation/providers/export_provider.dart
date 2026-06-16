import 'dart:convert';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel_pkg;

part 'export_provider.g.dart';

enum ExportFormat { csv, excel, json }

@riverpod
class ExportNotifier extends _$ExportNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Returns the saved file path on success so UI can show a snackbar.
  Future<String> exportData(ExportFormat format) async {
    state = const AsyncValue.loading();
    String savedPath = '';
    state = await AsyncValue.guard(() async {
      final bookmarksAsync = ref.read(bookmarkListProvider);
      final bookmarks = bookmarksAsync.value ?? [];

      if (bookmarks.isEmpty) throw Exception('No bookmarks to export');

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String fileName;
      List<int> bytes;

      switch (format) {
        case ExportFormat.csv:
          fileName = 'bookmarks_$timestamp.csv';
          final csvData = [
            ['Title', 'URL', 'Category', 'Notes', 'Tags', 'Created At'],
            ...bookmarks.map((b) => [
                  b.title,
                  b.url,
                  b.category ?? '',
                  b.notes ?? '',
                  b.tags?.join(', ') ?? '',
                  b.createdAt.toIso8601String(),
                ]),
          ];
          bytes = utf8.encode(csv.encode(csvData));
          break;

        case ExportFormat.json:
          fileName = 'bookmarks_$timestamp.json';
          final jsonData = bookmarks.map((b) => b.toJson()).toList();
          bytes = utf8.encode(JsonEncoder.withIndent('  ').convert(jsonData));
          break;

        case ExportFormat.excel:
          fileName = 'bookmarks_$timestamp.xlsx';
          final xl = excel_pkg.Excel.createExcel();
          final sheet = xl['Bookmarks'];
          sheet.appendRow([
            excel_pkg.TextCellValue('Title'),
            excel_pkg.TextCellValue('URL'),
            excel_pkg.TextCellValue('Category'),
            excel_pkg.TextCellValue('Notes'),
            excel_pkg.TextCellValue('Tags'),
            excel_pkg.TextCellValue('Created At'),
          ]);
          for (final b in bookmarks) {
            sheet.appendRow([
              excel_pkg.TextCellValue(b.title),
              excel_pkg.TextCellValue(b.url),
              excel_pkg.TextCellValue(b.category ?? ''),
              excel_pkg.TextCellValue(b.notes ?? ''),
              excel_pkg.TextCellValue(b.tags?.join(', ') ?? ''),
              excel_pkg.TextCellValue(b.createdAt.toIso8601String()),
            ]);
          }
          bytes = xl.encode()!;
          break;
      }

      // Save directly to Android Downloads folder so it's visible in Files app
      const downloadsPath = '/storage/emulated/0/Download';
      final dir = Directory(downloadsPath);
      if (!await dir.exists()) await dir.create(recursive: true);

      final file = File('$downloadsPath/$fileName');
      await file.writeAsBytes(bytes);
      savedPath = file.path;
    });
    return savedPath;
  }
}
