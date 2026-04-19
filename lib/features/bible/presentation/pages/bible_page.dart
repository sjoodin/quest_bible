import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_content.dart';
import 'package:quest_bible/features/bible/presentation/widgets/left_side_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/simple_book_chapter_picker.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: const Text('Quest Bible')),
        body: Row(
          children: [
            const LeftSideSections(),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SimpleBookChapterPicker(),
                  ),
                  const SizedBox(height: 8),
                  const Expanded(child: ChapterContent()),
                  const SafeArea(child: SizedBox.shrink()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
