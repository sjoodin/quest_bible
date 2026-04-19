import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_content.dart';
import 'package:quest_bible/shared/widgets/async_value_view.dart';

class BiblePage extends ConsumerWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);
    final selectedBookNumber = ref.watch(selectedBookProvider);
    final selectedChapter = ref.watch(currentChapterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quest Bible')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AsyncValueView<List<Book>>(
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
                          ref
                              .read(selectedBookProvider.notifier)
                              .setBook(value);
                          ref
                              .read(currentChapterProvider.notifier)
                              .setChapter(1);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 85,
                      child: DropdownButtonFormField<int>(
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
                          ref
                              .read(currentChapterProvider.notifier)
                              .setChapter(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Expanded(child: ChapterContent()),
        ],
      ),
    );
  }
}
