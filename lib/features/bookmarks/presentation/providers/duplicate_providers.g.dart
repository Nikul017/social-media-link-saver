// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duplicate_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$duplicateBookmarksHash() =>
    r'6380735fe0d199a9fb6075d42051ad79b5c1b3e5';

/// See also [duplicateBookmarks].
@ProviderFor(duplicateBookmarks)
final duplicateBookmarksProvider =
    AutoDisposeFutureProvider<Map<String, List<Bookmark>>>.internal(
  duplicateBookmarks,
  name: r'duplicateBookmarksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$duplicateBookmarksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DuplicateBookmarksRef
    = AutoDisposeFutureProviderRef<Map<String, List<Bookmark>>>;
String _$duplicateFinderNotifierHash() =>
    r'fe42c8de553cfe788e37a3382cea7810d2cdfef9';

/// See also [DuplicateFinderNotifier].
@ProviderFor(DuplicateFinderNotifier)
final duplicateFinderNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DuplicateFinderNotifier, void>.internal(
  DuplicateFinderNotifier.new,
  name: r'duplicateFinderNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$duplicateFinderNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DuplicateFinderNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
