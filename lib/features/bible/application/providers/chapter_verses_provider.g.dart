// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_verses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chapterVerses)
final chapterVersesProvider = ChapterVersesProvider._();

final class ChapterVersesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Verse>>,
          List<Verse>,
          FutureOr<List<Verse>>
        >
    with $FutureModifier<List<Verse>>, $FutureProvider<List<Verse>> {
  ChapterVersesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterVersesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterVersesHash();

  @$internal
  @override
  $FutureProviderElement<List<Verse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Verse>> create(Ref ref) {
    return chapterVerses(ref);
  }
}

String _$chapterVersesHash() => r'c940d92cfab17e01a2fdc8614f27a24bb7fbcd90';
