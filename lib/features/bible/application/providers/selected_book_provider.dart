import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
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

  Future<void> setBookAndChapter({
    required String bookCode,
    required int chapter,
  }) async {
    final books = await ref.read(bookListProvider.future);
    final matchingBook = books
        .where((book) => book.code == bookCode)
        .firstOrNull;

    var nextChapter = chapter;
    if (nextChapter < 1) {
      nextChapter = 1;
    }
    if (matchingBook != null && nextChapter > matchingBook.chapterCount) {
      nextChapter = matchingBook.chapterCount;
    }

    await ref.read(currentChapterProvider.notifier).setChapter(nextChapter);
    await setBook(bookCode);
  }
}
