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
    final selectedBookNumber = ref.watch(selectedBookProvider);
    final selectedChapter = ref.watch(currentChapterProvider);

    return AsyncValueView<List<Book>>(
      value: booksAsync,
      data: (books) {
        if (books.isEmpty) {
          return const Center(child: Text('No books available'));
        }

        final selectedBook = books.firstWhere(
          (book) => book.number == selectedBookNumber,
          orElse: () => books.first,
        );

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                style: const TextStyle(fontSize: 14),
                initialValue: selectedBook.number,
                decoration: const InputDecoration(
                  labelText: 'Book',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final book in books)
                    DropdownMenuItem<int>(
                      value: book.number,
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
                initialValue: selectedChapter,
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
