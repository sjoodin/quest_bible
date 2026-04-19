// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bibleRepository)
final bibleRepositoryProvider = BibleRepositoryProvider._();

final class BibleRepositoryProvider
    extends
        $FunctionalProvider<BibleRepository, BibleRepository, BibleRepository>
    with $Provider<BibleRepository> {
  BibleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bibleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bibleRepositoryHash();

  @$internal
  @override
  $ProviderElement<BibleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BibleRepository create(Ref ref) {
    return bibleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BibleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BibleRepository>(value),
    );
  }
}

String _$bibleRepositoryHash() => r'f3d2cdaedbdb9d38cee57f07fbe024c9e2e5b515';
