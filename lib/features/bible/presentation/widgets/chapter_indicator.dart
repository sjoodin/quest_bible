import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/active_section_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/hovered_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/presentation/utils.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_container.dart';

class ChapterIndicator extends ConsumerWidget {
  const ChapterIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoveredChapter = ref.watch(hoveredChapterProvider);
    final selectedBookCode = ref.watch(selectedBookProvider);
    final selectedChapter = ref.watch(currentChapterProvider);

    final activeSection = ref.watch(activeSectionProvider);
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

    BibleSection? sectionToShow;
    if (displayBookCode != null) {
      for (final section in bibleSections) {
        if (section.bookCodes.contains(displayBookCode)) {
          sectionToShow = section;
          break;
        }
      }
    }
    final showSelected =
        hoveredChapter == null &&
        activeSection != null &&
        sectionToShow == activeSection;
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTapDown: (_) async {
          if (activeSection != null) {
            //navigate to the book and chapter this chapter indicator is currently showing, then close the section view

            // if the chapter indicator is showing a different chapter than the currently active one, navigate to that chapter
            if (hoveredChapter == null) {
              ref.read(activeSectionProvider.notifier).clear();
            } else {
              try {
                await ref
                    .read(selectedBookProvider.notifier)
                    .setBookAndChapter(
                      bookCode: displayBookCode ?? '',
                      chapter: displayChapter,
                    );
              } finally {
                ref.read(hoveredChapterProvider.notifier).clear();
                ref.read(activeSectionProvider.notifier).clear();
              }
            }
          } else {
            ref.read(activeSectionProvider.notifier).setSection(sectionToShow);
          }
        },
        child: ChapterContainer(
          backgroundColor: showSelected
              ? brighten(sectionToShow?.color ?? Colors.grey)
              : sectionToShow?.color ?? Colors.grey,
          borderWidth: showSelected ? 1.5 : 1.0,
          isPressed: false,
          chapterNumber: displayChapter,
          showSelected: showSelected,
        ),
      ),
    );
  }
}
