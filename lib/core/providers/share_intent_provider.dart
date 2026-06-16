import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds a pending shared URL that needs the AddBookmarkSheet to open.
/// Stored in Riverpod so it survives widget rebuilds and activity recreations.
final pendingSharedUrlProvider = StateProvider<String?>((ref) => null);
