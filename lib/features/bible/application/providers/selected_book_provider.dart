import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/shared_preferences_provider.dart';

part 'selected_book_provider.g.dart';

@riverpod
class SelectedBook extends _$SelectedBook {
  @override
  Future<int> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getInt('selectedBook') ?? 43;
  }

  Future<void> setBook(int value) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setInt('selectedBook', value);
    state = AsyncValue.data(value);
  }
}
