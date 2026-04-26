import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/shared/widgets/async_value_view.dart';

class SimpleBookChapterPicker extends ConsumerWidget {
  const SimpleBookChapterPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);
    final selectedBookCode = ref.watch(selectedBookProvider);
    final selectedChapter = ref.watch(currentChapterProvider);

    return AsyncValueView<List<Book>>(
      value: booksAsync,
      data: (books) {
        final selectedBookValue = selectedBookCode.maybeWhen(
          data: (value) => value,
          orElse: () => books.isNotEmpty ? books.first.code : 'JHN',
        );
        final selectedChapterValue = selectedChapter.maybeWhen(
          data: (value) => value,
          orElse: () => 1,
        );

        if (books.isEmpty) {
          return const Center(child: Text('No books available'));
        }

        final selectedBook = books.firstWhere(
          (book) => book.code == selectedBookValue,
          orElse: () => books.first,
        );
        final clampedChapterValue = selectedChapterValue > selectedBook.chapterCount
            ? 1
            : selectedChapterValue;

        if (clampedChapterValue != selectedChapterValue) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(currentChapterProvider.notifier).setChapter(1);
          });
        }

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                style: const TextStyle(fontSize: 14),
                initialValue: selectedBook.code,
                decoration: const InputDecoration(
                  labelText: 'Book',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final book in books)
                    DropdownMenuItem<String>(
                      value: book.code,
                      child: Text(book.name),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(selectedBookProvider.notifier).setBook(value);
                  ref.read(currentChapterProvider.notifier).setChapter(1);
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: DropdownButtonFormField<int>(
                style: const TextStyle(fontSize: 14),
                initialValue: clampedChapterValue,
                decoration: const InputDecoration(
                  labelText: 'Chapter',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (int i = 1; i <= selectedBook.chapterCount; i++)
                    DropdownMenuItem<int>(value: i, child: Text('$i')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(currentChapterProvider.notifier).setChapter(value);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
