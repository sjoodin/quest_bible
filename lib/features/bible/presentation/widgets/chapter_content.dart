import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/chapter_verses_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/application/providers/startup_chapter_cache_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';
import 'package:quest_bible/features/bible/presentation/widgets/verse_tile.dart';

class ChapterContent extends ConsumerWidget {
  const ChapterContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(chapterVersesProvider);
    final selectedChapterAsync = ref.watch(currentChapterProvider);
    final selectedBookAsync = ref.watch(selectedBookProvider);
    final startupCache = ref.watch(startupChapterCacheProvider);

    final selectedBook = selectedBookAsync.asData?.value;
    final selectedChapter = selectedChapterAsync.asData?.value;

    return versesAsync.when(
      data: (verses) => _buildVersesList(
        ref: ref,
        verses: verses,
        selectedChapterAsync: selectedChapterAsync,
      ),
      error: (error, _) => Center(child: Text('Something went wrong: $error')),
      loading: () {
        final cacheMatchesSelection =
            startupCache != null &&
            selectedBook != null &&
            selectedChapter != null &&
            startupCache.bookCode == selectedBook &&
            startupCache.chapterNumber == selectedChapter;

        if (cacheMatchesSelection) {
          return _buildVersesList(
            ref: ref,
            verses: startupCache.verses,
            selectedChapterAsync: selectedChapterAsync,
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildVersesList({
    required WidgetRef ref,
    required List<Verse> verses,
    required AsyncValue<int> selectedChapterAsync,
  }) {
    return ListView.separated(
      itemCount: verses.length + 1,
      itemBuilder: (context, index) {
        if (index < verses.length) {
          return VerseTile(verse: verses[index]);
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                final currentChapter = selectedChapterAsync.maybeWhen(
                  data: (value) => value,
                  orElse: () => 1,
                );
                ref
                    .read(currentChapterProvider.notifier)
                    .setChapter(currentChapter + 1);
              },
              child: const Text('Next Chapter'),
            ),
          );
        }
      },
      separatorBuilder: (_, index) => const Divider(height: 1),
    );
  }
}
