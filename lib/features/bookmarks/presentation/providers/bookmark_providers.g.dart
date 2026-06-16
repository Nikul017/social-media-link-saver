// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookmarkLocalDataSourceHash() =>
    r'4fc6d81ef1c788520e29f69d0940d85727e1d9d6';

/// See also [bookmarkLocalDataSource].
@ProviderFor(bookmarkLocalDataSource)
final bookmarkLocalDataSourceProvider =
    AutoDisposeProvider<BookmarkLocalDataSource>.internal(
  bookmarkLocalDataSource,
  name: r'bookmarkLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookmarkLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookmarkLocalDataSourceRef
    = AutoDisposeProviderRef<BookmarkLocalDataSource>;
String _$bookmarkRepositoryHash() =>
    r'12e28b2da67c9ceb6dd7c1ad1d2f78fb49f7edd2';

/// See also [bookmarkRepository].
@ProviderFor(bookmarkRepository)
final bookmarkRepositoryProvider =
    AutoDisposeProvider<BookmarkRepository>.internal(
  bookmarkRepository,
  name: r'bookmarkRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookmarkRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookmarkRepositoryRef = AutoDisposeProviderRef<BookmarkRepository>;
String _$bookmarkStreamHash() => r'9478830050c814db878d6bffeefc87a5898686b6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [bookmarkStream].
@ProviderFor(bookmarkStream)
const bookmarkStreamProvider = BookmarkStreamFamily();

/// See also [bookmarkStream].
class BookmarkStreamFamily extends Family<AsyncValue<Bookmark?>> {
  /// See also [bookmarkStream].
  const BookmarkStreamFamily();

  /// See also [bookmarkStream].
  BookmarkStreamProvider call(
    String id,
  ) {
    return BookmarkStreamProvider(
      id,
    );
  }

  @override
  BookmarkStreamProvider getProviderOverride(
    covariant BookmarkStreamProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookmarkStreamProvider';
}

/// See also [bookmarkStream].
class BookmarkStreamProvider extends AutoDisposeStreamProvider<Bookmark?> {
  /// See also [bookmarkStream].
  BookmarkStreamProvider(
    String id,
  ) : this._internal(
          (ref) => bookmarkStream(
            ref as BookmarkStreamRef,
            id,
          ),
          from: bookmarkStreamProvider,
          name: r'bookmarkStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookmarkStreamHash,
          dependencies: BookmarkStreamFamily._dependencies,
          allTransitiveDependencies:
              BookmarkStreamFamily._allTransitiveDependencies,
          id: id,
        );

  BookmarkStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Bookmark?> Function(BookmarkStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookmarkStreamProvider._internal(
        (ref) => create(ref as BookmarkStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Bookmark?> createElement() {
    return _BookmarkStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookmarkStreamProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookmarkStreamRef on AutoDisposeStreamProviderRef<Bookmark?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _BookmarkStreamProviderElement
    extends AutoDisposeStreamProviderElement<Bookmark?> with BookmarkStreamRef {
  _BookmarkStreamProviderElement(super.provider);

  @override
  String get id => (origin as BookmarkStreamProvider).id;
}

String _$selectedFolderIdHash() => r'45b940ed875f20ecea5e4ea47854ca12810315a4';

/// See also [SelectedFolderId].
@ProviderFor(SelectedFolderId)
final selectedFolderIdProvider =
    AutoDisposeNotifierProvider<SelectedFolderId, String?>.internal(
  SelectedFolderId.new,
  name: r'selectedFolderIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedFolderIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedFolderId = AutoDisposeNotifier<String?>;
String _$bookmarkListHash() => r'44dcd36c4a6fce1fb781445dc0e095f9d949ed32';

/// See also [BookmarkList].
@ProviderFor(BookmarkList)
final bookmarkListProvider =
    AutoDisposeAsyncNotifierProvider<BookmarkList, List<Bookmark>>.internal(
  BookmarkList.new,
  name: r'bookmarkListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookmarkListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookmarkList = AutoDisposeAsyncNotifier<List<Bookmark>>;
String _$folderListHash() => r'08eb16e0b37402b96e76c4d1e0ef2b3f66c8b54c';

/// See also [FolderList].
@ProviderFor(FolderList)
final folderListProvider =
    AutoDisposeAsyncNotifierProvider<FolderList, List<Folder>>.internal(
  FolderList.new,
  name: r'folderListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$folderListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FolderList = AutoDisposeAsyncNotifier<List<Folder>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
