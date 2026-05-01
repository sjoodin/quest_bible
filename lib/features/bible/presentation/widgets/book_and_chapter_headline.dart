import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/hovered_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';

class BookAndChapterHeadline extends ConsumerWidget {
  const BookAndChapterHeadline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);
    final hoveredChapter = ref.watch(hoveredChapterProvider);
    final selectedBookCode = ref.watch(selectedBookProvider);
    final selectedChapter = ref.watch(currentChapterProvider);

    final selectedBookCodeValue = selectedBookCode.maybeWhen(
      data: (value) => value,
      orElse: () => null,
    );
    final selectedChapterValue = selectedChapter.maybeWhen(
      data: (value) => value,
      orElse: () => 1,
    );

    final displayBookCode = hoveredChapter?.bookCode ?? selectedBookCodeValue;
    final displayChapter =
        hoveredChapter?.chapterNumber ?? selectedChapterValue;

    final title = booksAsync.maybeWhen(
      data: (books) {
        String? selectedBookName;
        for (final book in books) {
          if (book.code == displayBookCode) {
            selectedBookName = book.name;
            break;
          }
        }

        if (selectedBookName == null && books.isNotEmpty) {
          selectedBookName = books.first.name;
        }

        if (selectedBookName == null) {
          return 'Chapter $displayChapter';
        }

        return '$selectedBookName $displayChapter';
      },
      orElse: () => 'Chapter $displayChapter',
    );

    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}
