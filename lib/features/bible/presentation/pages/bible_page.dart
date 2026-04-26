import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/bible_section_view.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_content.dart';
import 'package:quest_bible/features/bible/presentation/widgets/left_side_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/simple_book_chapter_picker.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  BibleSection? _activeSection;

  void _closeSection() {
    setState(() {
      _activeSection = null;
    });
  }

  void _toggleSection(BibleSection section) {
    setState(() {
      if (_activeSection?.id == section.id) {
        _activeSection = null;
      } else {
        _activeSection = section;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                LeftSideSections(onSectionPressed: _toggleSection),
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
                    ],
                  ),
                ),
              ],
            ),
            if (_activeSection != null)
              Row(
                children: [
                  LeftSideSections(onSectionPressed: _toggleSection),
                  Expanded(
                    child: BibleSectionView(
                      section: _activeSection!,
                      onClose: _closeSection,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
