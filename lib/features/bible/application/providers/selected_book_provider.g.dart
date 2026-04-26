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
    extends $AsyncNotifierProvider<SelectedBook, String> {
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

String _$selectedBookHash() => r'654e2aab54a97e8d21ae93d992109f32fda37217';

abstract class _$SelectedBook extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
