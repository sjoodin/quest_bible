import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/bible_repository_provider.dart';
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
  final book = await ref.watch(selectedBookProvider.future);
  final chapter = await ref.watch(currentChapterProvider.future);

  final cacheKey = chapterVersesCacheKey(book: book, chapter: chapter);
  final cachedVerses = decodeVerses(prefs.getString(cacheKey));
  if (cachedVerses != null) {
    await prefs.setString(
      lastSelectedChapterVersesKey,
      encodeVerses(cachedVerses),
    );
    return cachedVerses;
  }

  final verses = await repository.getVerses(
    bookNumber: book,
    chapterNumber: chapter,
  );
  final encodedVerses = encodeVerses(verses);
  await prefs.setString(cacheKey, encodedVerses);
  await prefs.setString(lastSelectedChapterVersesKey, encodedVerses);

  return verses;
}
