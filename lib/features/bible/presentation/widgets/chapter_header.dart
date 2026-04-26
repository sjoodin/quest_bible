import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';

class ChapterHeader extends ConsumerWidget {
  const ChapterHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);
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

    final title = booksAsync.maybeWhen(
      data: (books) {
        String? selectedBookName;
        for (final book in books) {
          if (book.code == selectedBookCodeValue) {
            selectedBookName = book.name;
            break;
          }
        }

        if (selectedBookName == null && books.isNotEmpty) {
          selectedBookName = books.first.name;
        }

        if (selectedBookName == null) {
          return 'Chapter $selectedChapterValue';
        }

        return '$selectedBookName $selectedChapterValue';
      },
      orElse: () => 'Chapter $selectedChapterValue',
    );

    final colorScheme = Theme.of(context).colorScheme;

    Color? sectionColor;
    if (selectedBookCodeValue != null) {
      for (final section in bibleSections) {
        if (section.bookCodes.contains(selectedBookCodeValue)) {
          sectionColor = section.color;
          break;
        }
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      decoration: BoxDecoration(
        color: (sectionColor ?? colorScheme.surface),
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              255,
              75,
              75,
              75,
            ).withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
