import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/hovered_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';

class BookHeadline extends ConsumerWidget {
  const BookHeadline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);
    final hoveredChapter = ref.watch(hoveredChapterProvider);
    final selectedBookCode = ref.watch(selectedBookProvider);

    final selectedBookCodeValue = selectedBookCode.maybeWhen(
      data: (value) => value,
      orElse: () => null,
    );

    final displayBookCode = hoveredChapter?.bookCode ?? selectedBookCodeValue;

    final bookName = booksAsync.maybeWhen(
      data: (books) {
        for (final book in books) {
          if (book.code == displayBookCode) {
            return book.name;
          }
        }

        if (books.isNotEmpty) {
          return books.first.name;
        }

        return null;
      },
      orElse: () => null,
    );

    return Text(
      bookName ?? 'Chapter',
      style: Theme.of(context).textTheme.headlineSmall,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ChapterHeadline extends ConsumerWidget {
  const ChapterHeadline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoveredChapter = ref.watch(hoveredChapterProvider);
    final selectedChapter = ref.watch(currentChapterProvider);

    final selectedChapterValue = selectedChapter.maybeWhen(
      data: (value) => value,
      orElse: () => 1,
    );

    final displayChapter =
        hoveredChapter?.chapterNumber ?? selectedChapterValue;

    return Text(
      '$displayChapter',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
