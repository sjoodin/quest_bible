import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/hovered_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_container.dart';

class ChapterIndicator extends ConsumerWidget {
  const ChapterIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      width: 30,
      height: 30,
      margin: const EdgeInsets.only(right: 8),
      child: ChapterContainer(
        backgroundColor: sectionColor ?? Colors.grey,
        borderWidth: 1,
        isPressed: false,
        chapterNumber: displayChapter,
      ),
    );
  }
}
