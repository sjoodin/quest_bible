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
    final nextBook = _findNextBook(books, selectedBook);
    final hasNextChapter =
        selectedChapter != null &&
        chapterCount != null &&
        selectedChapter < chapterCount;
    final showNextBook = !hasNextChapter && nextBook != null;
    final nextBookSectionColor = _findSectionColorForBook(nextBook?.code);
    final trailingAction = hasNextChapter
        ? NextChapterWidget(
            selectedChapterAsync: selectedChapterAsync,
            sectionColor: sectionColor,
          )
        : (showNextBook
              ? NextBookWidget(
                  nextBook: nextBook,
                  sectionColor: nextBookSectionColor,
                )
              : null);

    return versesAsync.when(
      data: (verses) =>
          _buildVersesList(verses: verses, trailingAction: trailingAction),
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
            verses: startupCache.verses,
            trailingAction: trailingAction,
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildVersesList({
    required List<Verse> verses,
    required Widget? trailingAction,
  }) {
    return ListView.separated(
      itemCount: verses.length + (trailingAction == null ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < verses.length) {
          return VerseTile(verse: verses[index]);
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: trailingAction,
          );
        }
      },
      separatorBuilder: (_, index) => Container(),
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

  Book? _findNextBook(List<Book>? books, String? bookCode) {
    if (books == null || bookCode == null) return null;

    for (var i = 0; i < books.length; i++) {
      if (books[i].code == bookCode) {
        return i + 1 < books.length ? books[i + 1] : null;
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
    final currentChapter = selectedChapterAsync.maybeWhen(
      data: (value) => value,
      orElse: () => 1,
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            sectionColor ?? Theme.of(context).colorScheme.surfaceTint,
      ),
      onPressed: () {
        ref
            .read(currentChapterProvider.notifier)
            .setChapter(currentChapter + 1);
      },
      child: Text('Next chapter: ${currentChapter + 1}'),
    );
  }
}

class NextBookWidget extends ConsumerWidget {
  const NextBookWidget({
    super.key,
    required this.nextBook,
    required this.sectionColor,
  });

  final Book nextBook;
  final Color? sectionColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            sectionColor ?? Theme.of(context).colorScheme.surfaceTint,
      ),
      onPressed: () async {
        await ref
            .read(selectedBookProvider.notifier)
            .setBookAndChapter(bookCode: nextBook.code, chapter: 1);
      },
      child: Text('Next Book: ${nextBook.name}'),
    );
  }
}
