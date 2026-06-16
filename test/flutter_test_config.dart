import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  
  // Disable runtime fetching to avoid online TTF downloads and checksum checking
  GoogleFonts.config.allowRuntimeFetching = false;

  // Stub the asset channel so google_fonts thinks the font files exist locally
  binding.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (ByteData? message) async {
      if (message == null) return null;
      try {
        final key = utf8.decode(message.buffer.asUint8List());
        if (key.contains('.ttf')) {
          // Load the real Roboto-Regular font from the Flutter SDK environment as a fallback
          final flutterRoot = Platform.environment['FLUTTER_ROOT'];
          if (flutterRoot != null) {
            final file = File('$flutterRoot/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf');
            if (file.existsSync()) {
              final bytes = file.readAsBytesSync();
              return ByteData.sublistView(bytes);
            }
          }
          return ByteData(0);
        }

        final fontsToInject = [
          'google_fonts/Inter-Black.ttf',
          'google_fonts/Inter-Medium.ttf',
          'google_fonts/Inter-Bold.ttf',
          'google_fonts/Inter-Regular.ttf',
          'google_fonts/JetBrainsMono-ExtraBold.ttf',
          'google_fonts/JetBrainsMono-Regular.ttf',
          'google_fonts/JetBrainsMono-Medium.ttf',
          'google_fonts/JetBrainsMono-Bold.ttf',
        ];

        if (key == 'AssetManifest.bin') {
          ByteData? originalData;
          for (final dir in ['build/unit_test_assets', 'build/flutter_assets']) {
            final file = File('$dir/$key');
            if (file.existsSync()) {
              final bytes = file.readAsBytesSync();
              originalData = ByteData.sublistView(bytes);
              break;
            }
          }
          
          Map<dynamic, dynamic> manifest = {};
          if (originalData != null) {
            final decoded = const StandardMessageCodec().decodeMessage(originalData);
            if (decoded is Map) {
              manifest = Map<dynamic, dynamic>.from(decoded);
            }
          }
          
          for (final font in fontsToInject) {
            manifest[font] = [
              {'asset': font}
            ];
          }
          
          return const StandardMessageCodec().encodeMessage(manifest);
        }

        if (key == 'AssetManifest.json') {
          Map<String, dynamic> manifest = {};
          for (final dir in ['build/unit_test_assets', 'build/flutter_assets']) {
            final file = File('$dir/$key');
            if (file.existsSync()) {
              try {
                manifest = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
              } catch (_) {}
              break;
            }
          }
          
          for (final font in fontsToInject) {
            manifest[font] = [font];
          }

          final bytes = utf8.encode(json.encode(manifest));
          return ByteData.sublistView(Uint8List.fromList(bytes));
        }
        
        // Retrieve other files from local build assets
        for (final dir in ['build/unit_test_assets', 'build/flutter_assets']) {
          final file = File('$dir/$key');
          if (file.existsSync()) {
            final bytes = file.readAsBytesSync();
            return ByteData.sublistView(bytes);
          }
        }
      } catch (_) {}
      return null;
    },
  );

  // Load Roboto font from Flutter SDK and register it under standard & Google Fonts families
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    final file = File('$flutterRoot/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf');
    if (file.existsSync()) {
      final bytes = file.readAsBytesSync();
      
      final families = [
        'Roboto',
        'Inter',
        'JetBrainsMono',
        'JetBrains Mono',
        'sans-serif',
        '.SF UI Text',
        '.SF UI Display',
        // Dynamic Google Fonts family names
        GoogleFonts.inter().fontFamily,
        GoogleFonts.inter(fontWeight: FontWeight.w900).fontFamily,
        GoogleFonts.jetBrainsMono().fontFamily,
        GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w900).fontFamily,
      ];
      
      for (final family in families) {
        if (family != null) {
          final loader = FontLoader(family);
          loader.addFont(Future.value(ByteData.sublistView(bytes)));
          await loader.load();
        }
      }
    }
  }

  await loadAppFonts();
  await testMain();
}
