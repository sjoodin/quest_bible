import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/shared_preferences_provider.dart';

part 'selected_book_provider.g.dart';

@riverpod
class SelectedBook extends _$SelectedBook {
  @override
  Future<String> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getString('selectedBookCode') ?? 'JHN';
  }

  Future<void> setBook(String value) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setString('selectedBookCode', value);
    state = AsyncValue.data(value);
  }
}
