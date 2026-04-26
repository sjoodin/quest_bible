import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/chapter_verses_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/application/providers/startup_chapter_cache_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';
import 'package:quest_bible/features/bible/presentation/utils.dart';
import 'package:quest_bible/features/bible/presentation/widgets/verse_tile.dart';

class ChapterContent extends ConsumerWidget {
  const ChapterContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);
    final versesAsync = ref.watch(chapterVersesProvider);
    final selectedChapterAsync = ref.watch(currentChapterProvider);
    final selectedBookAsync = ref.watch(selectedBookProvider);
    final startupCache = ref.watch(startupChapterCacheProvider);

    final selectedBook = selectedBookAsync.asData?.value;
    final selectedChapter = selectedChapterAsync.asData?.value;
    final books = booksAsync.asData?.value;
    final sectionColor = _findSectionColorForBook(selectedBook);
    final chapterCount = _findChapterCountForBook(books, selectedBook);
    final hasNextChapter =
        selectedChapter != null &&
        chapterCount != null &&
        selectedChapter < chapterCount;

    return versesAsync.when(
      data: (verses) => _buildVersesList(
        ref: ref,
        verses: verses,
        selectedChapterAsync: selectedChapterAsync,
        hasNextChapter: hasNextChapter,
        sectionColor: sectionColor,
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
            hasNextChapter: hasNextChapter,
            sectionColor: sectionColor,
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
    required bool hasNextChapter,
    required Color? sectionColor,
  }) {
    return ListView.separated(
      itemCount: verses.length + (hasNextChapter ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < verses.length) {
          return VerseTile(verse: verses[index]);
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: NextChapterWidget(
              selectedChapterAsync: selectedChapterAsync,
              sectionColor: sectionColor,
            ),
          );
        }
      },
      separatorBuilder: (_, index) => const Divider(height: 1),
    );
  }

  Color? _findSectionColorForBook(String? bookCode) {
    if (bookCode == null) return null;

    for (final section in bibleSections) {
      if (section.bookCodes.contains(bookCode)) {
        return section.color;
      }
    }

    return null;
  }

  int? _findChapterCountForBook(List<Book>? books, String? bookCode) {
    if (books == null || bookCode == null) return null;

    for (final book in books) {
      if (book.code == bookCode) {
        return book.chapterCount;
      }
    }

    return null;
  }
}

class NextChapterWidget extends ConsumerWidget {
  const NextChapterWidget({
    super.key,
    required this.selectedChapterAsync,
    required this.sectionColor,
  });

  final AsyncValue<int> selectedChapterAsync;
  final Color? sectionColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: darken(
          sectionColor ?? Theme.of(context).colorScheme.surfaceTint,
          0.2,
        ),
        foregroundColor: Colors.white70,
      ),
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
    );
  }
}
