import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:link_saver/features/bookmarks/domain/entities/bookmark.dart';
import 'package:link_saver/features/bookmarks/data/repository/bookmark_repository_impl.dart';
import 'package:link_saver/features/bookmarks/presentation/providers/bookmark_providers.dart';

part 'import_provider.g.dart';

@riverpod
class ImportNotifier extends _$ImportNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> importFromFile(String filePath) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final file = File(filePath);
      if (!await file.exists()) throw Exception('Import file not found');

      final ext = p.extension(filePath).toLowerCase();
      List<Map<String, String>> importData = [];

      if (ext == '.csv') {
        importData = await _parseCsv(file);
      } else if (ext == '.xlsx' || ext == '.xls') {
        final urls = await _parseExcel(file);
        importData = urls.map((u) => {'url': u}).toList();
      } else if (ext == '.pdf') {
        final urls = await _parsePdf(file);
        importData = urls.map((u) => {'url': u}).toList();
      } else {
        final lines = await file.readAsLines();
        final urls = lines.where((l) => l.trim().isNotEmpty).toSet().toList();
        importData = urls.map((u) => {'url': u}).toList();
      }

      if (importData.isEmpty) throw Exception('No URLs found in file');

      final repo = ref.read(bookmarkRepositoryProvider);

      for (final data in importData) {
        final url = data['url'] ?? '';
        if (url.isEmpty) continue;

        // ── Step 1: Always ensure the folder exists, even for duplicates ──
        String? folderId;
        final folderName = data['folder'];
        if (folderName != null &&
            folderName.trim().isNotEmpty &&
            repo is BookmarkRepositoryImpl) {
          final id = await repo.getOrCreateFolder(folderName);
          if (id != -1) folderId = id.toString();
        }

        // ── Step 2: Check if URL already exists in the database ──
        Bookmark? existingBookmark;
        if (repo is BookmarkRepositoryImpl) {
          existingBookmark = await repo.getBookmarkByUrl(url);
        }

        // ── Step 3: Parse Created Date ──
        DateTime createdAt = DateTime.now();
        final dateStr = data['created_date'];
        if (dateStr != null && dateStr.trim().isNotEmpty) {
          try {
            createdAt = DateTime.parse(dateStr.trim());
          } catch (_) {
            if (existingBookmark != null) {
              createdAt = existingBookmark.createdAt;
            }
          }
        } else if (existingBookmark != null) {
          createdAt = existingBookmark.createdAt;
        }

        // ── Step 4: Save or Update bookmark ──
        final rawTitle = data['title'] ?? '';
        final title = rawTitle.trim().isNotEmpty ? rawTitle : (existingBookmark?.title ?? url);

        final bookmark = Bookmark(
          id: existingBookmark?.id ?? '',
          url: url,
          title: title,
          category: data['category'] ?? existingBookmark?.category,
          folderId: folderId ?? existingBookmark?.folderId,
          createdAt: createdAt,
          updatedAt: createdAt,
          isFavorite: existingBookmark?.isFavorite ?? false,
          isArchived: existingBookmark?.isArchived ?? false,
          notes: data['notes'] ?? existingBookmark?.notes,
          tags: existingBookmark?.tags,
        );
        await repo.saveBookmark(bookmark);
      }

      ref.invalidate(bookmarkListProvider);
      ref.invalidate(folderListProvider);
    });
  }

  Future<List<Map<String, String>>> _parseCsv(File file) async {
    // Normalise line endings so the CSV parser works on Windows exports
    final raw = await file.readAsString();
    final input = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Use package:csv 8.0.0 API to decode CSV input
    final List<List<dynamic>> rows = csv.decode(input);

    if (rows.isEmpty) return [];

    // Check if the first row looks like a structured header
    final headerRow =
        rows.first.map((e) => e.toString().toLowerCase().trim()).toList();
    final isStructured =
        headerRow.contains('url') || headerRow.contains('link');

    if (isStructured) {
      final urlIdx = headerRow.contains('url')
          ? headerRow.indexOf('url')
          : headerRow.indexOf('link');
      final titleIdx = headerRow.indexOf('title');
      final folderIdx = headerRow.indexOf('folder');
      final categoryIdx = headerRow.indexOf('category');

      // Robust check for creation date/time columns
      int dateIdx = -1;
      for (var j = 0; j < headerRow.length; j++) {
        final col = headerRow[j];
        if (col == 'created at' ||
            col == 'created_at' ||
            col == 'created date' ||
            col == 'created_date' ||
            col == 'date' ||
            col == 'time' ||
            col == 'timestamp') {
          dateIdx = j;
          break;
        }
      }
      if (dateIdx == -1) {
        for (var j = 0; j < headerRow.length; j++) {
          final col = headerRow[j];
          if (col.contains('created') ||
              col.contains('date') ||
              col.contains('time') ||
              col.contains('timestamp')) {
            dateIdx = j;
            break;
          }
        }
      }

      final results = <Map<String, String>>[];
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length <= urlIdx) continue;

        final url = row[urlIdx].toString().trim();
        if (url.isEmpty) continue;

        results.add({
          'url': url,
          'title': titleIdx != -1 && titleIdx < row.length
              ? row[titleIdx].toString()
              : '',
          // Use 'folder' column if present, otherwise fall back to 'category'
          'folder': folderIdx != -1 && folderIdx < row.length && row[folderIdx].toString().trim().isNotEmpty
              ? row[folderIdx].toString()
              : (categoryIdx != -1 && categoryIdx < row.length ? row[categoryIdx].toString() : ''),
          'category': categoryIdx != -1 && categoryIdx < row.length
              ? row[categoryIdx].toString()
              : '',
          'created_date': dateIdx != -1 && dateIdx < row.length
              ? row[dateIdx].toString()
              : '',
        });
      }
      return results;
    }

    // Fallback: regex scan for URLs anywhere in the CSV
    final urlRegex = RegExp(r'https?://[^\s"<>\[\]\(\)]+');
    final urls = <String>{};
    for (final row in rows) {
      for (final cell in row) {
        for (final m in urlRegex.allMatches(cell.toString())) {
          urls.add(m.group(0)!);
        }
      }
    }
    return urls.map((u) => {'url': u}).toList();
  }

  Future<List<String>> _parseExcel(File file) async {
    final bytes = await file.readAsBytes();
    final excel = excel_pkg.Excel.decodeBytes(bytes);
    final urlRegex = RegExp(r'https?://[^\s"<>\[\]\(\)]+');
    final urls = <String>{};

    for (final table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;
      for (final row in sheet.rows) {
        for (final cell in row) {
          if (cell == null) continue;
          for (final m in urlRegex.allMatches(cell.value.toString())) {
            urls.add(m.group(0)!);
          }
        }
      }
    }
    return urls.toList();
  }

  Future<List<String>> _parsePdf(File file) async {
    final bytes = await file.readAsBytes();
    final content =
        String.fromCharCodes(bytes.where((b) => b >= 32 && b <= 126));

    final uriPattern = RegExp(r'/URI \((https?://.*?)\)');
    final rawPattern = RegExp(r'https?://[^\s"<>\[\]\(\)]+');

    final urls = <String>{};
    for (final m in uriPattern.allMatches(content)) {
      urls.add(m.group(1)!);
    }
    for (final m in rawPattern.allMatches(content)) {
      urls.add(m.group(0)!);
    }
    return urls.toList();
  }
}
