// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedBook)
final selectedBookProvider = SelectedBookProvider._();

final class SelectedBookProvider
    extends $AsyncNotifierProvider<SelectedBook, int> {
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
}

String _$selectedBookHash() => r'e2e2249781c98d73b7d23257107ad7ee4a9fbb77';

abstract class _$SelectedBook extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
