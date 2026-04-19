import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_content.dart';
import 'package:quest_bible/features/bible/presentation/widgets/simple_book_chapter_picker.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quest Bible')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const SimpleBookChapterPicker(),
          ),
          const SizedBox(height: 8),
          const Expanded(child: ChapterContent()),
        ],
      ),
    );
  }
}
