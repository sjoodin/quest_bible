import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/hovered_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_container.dart';

class BibleSectionsHeader extends ConsumerWidget {
  const BibleSectionsHeader({super.key});

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

    Color? sectionColor;
    if (displayBookCode != null) {
      for (final section in bibleSections) {
        if (section.bookCodes.contains(displayBookCode)) {
          sectionColor = section.color;
          break;
        }
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 117, 117, 117),
            width: 1,
          ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // A box with the section color, to the left of the title, as a visual indicator of the section
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          if (sectionColor != null)
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8),
              child: ChapterContainer(
                backgroundColor: sectionColor,
                borderWidth: 1,
                isPressed: false,
                chapterNumber: selectedChapterValue,
              ),
            ),
        ],
      ),
    );
  }
}
