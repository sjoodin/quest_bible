import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/bible_section_view.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_content.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_header.dart';
import 'package:quest_bible/features/bible/presentation/widgets/left_side_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/simple_book_chapter_picker.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  BibleSection? _activeSection;
  bool _isChapterTouchArmed = false;

  void _closeSection() {
    setState(() {
      _activeSection = null;
      _isChapterTouchArmed = false;
    });
  }

  void _consumeChapterTouchArm() {
    if (!_isChapterTouchArmed) return;
    setState(() {
      _isChapterTouchArmed = false;
    });
  }

  void _openSectionOnTouchStart(BibleSection section) {
    setState(() {
      _activeSection = section;
      _isChapterTouchArmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 75, 81, 78),
        body: Stack(
          children: [
            Row(
              children: [
                LeftSideSections(
                  onSectionPressed: _openSectionOnTouchStart,
                  onSectionReleased: _closeSection,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        //child: SimpleBookChapterPicker(),
                        child: ChapterTitle(),
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
                  LeftSideSections(
                    onSectionPressed: _openSectionOnTouchStart,
                    onSectionReleased: _closeSection,
                  ),
                  Expanded(
                    child: BibleSectionView(
                      section: _activeSection!,
                      onClose: _closeSection,
                      isChapterTouchArmed: _isChapterTouchArmed,
                      onChapterTouchConsumed: _consumeChapterTouchArm,
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
