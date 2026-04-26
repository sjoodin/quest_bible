import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/shared_preferences_provider.dart';

part 'current_chapter_provider.g.dart';

@riverpod
class CurrentChapter extends _$CurrentChapter {
  @override
  Future<int> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getInt('currentChapter') ?? 1;
  }

  Future<void> setChapter(int value) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setInt('currentChapter', value);
    state = AsyncValue.data(value);
  }
}
