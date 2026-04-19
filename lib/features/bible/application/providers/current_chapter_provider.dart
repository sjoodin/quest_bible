import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_chapter_provider.g.dart';

@riverpod
class CurrentChapter extends _$CurrentChapter {
  @override
  int build() => 1;

  void setChapter(int value) => state = value;
}
