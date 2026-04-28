import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/bible_repository_provider.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/application/providers/shared_preferences_provider.dart';
import 'package:quest_bible/features/bible/application/verse_cache.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';

part 'chapter_verses_provider.g.dart';

@riverpod
Future<List<Verse>> chapterVerses(Ref ref) async {
  final repository = ref.watch(bibleRepositoryProvider);
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final bookCode = await ref.watch(selectedBookProvider.future);
  final chapter = await ref.watch(currentChapterProvider.future);
  final books = await ref.watch(bookListProvider.future);
  final selectedBook = books.firstWhere(
    (item) => item.code == bookCode,
    orElse: () => books.first,
  );
  final effectiveChapter = chapter < 1
      ? 1
      : (chapter > selectedBook.chapterCount ? 1 : chapter);

  final cacheKey = chapterVersesCacheKey(
    bookCode: selectedBook.code,
    chapter: effectiveChapter,
  );
  final cachedVerses = decodeVerses(prefs.getString(cacheKey));
  if (cachedVerses != null) {
    await prefs.setString(
      lastSelectedChapterVersesKey,
      encodeVerses(cachedVerses),
    );
    return cachedVerses;
  }

  final verses = await repository.getVerses(
    bookCode: selectedBook.code,
    chapterNumber: effectiveChapter,
  );
  final encodedVerses = encodeVerses(verses);
  await prefs.setString(cacheKey, encodedVerses);
  await prefs.setString(lastSelectedChapterVersesKey, encodedVerses);

  return verses;
}
