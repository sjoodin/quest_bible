// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedBook)
final selectedBookProvider = SelectedBookProvider._();

final class SelectedBookProvider extends $NotifierProvider<SelectedBook, int> {
  SelectedBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBookHash();

  @$internal
  @override
  SelectedBook create() => SelectedBook();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedBookHash() => r'6c8f92f02bed06c89ff0faf3741a51083b68fad9';

abstract class _$SelectedBook extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
