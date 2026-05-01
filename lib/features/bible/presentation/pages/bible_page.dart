import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/active_section_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/presentation/widgets/bible_section_view.dart';
import 'package:quest_bible/features/bible/presentation/widgets/book_and_chapter_headline.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_content.dart';
import 'package:quest_bible/features/bible/presentation/widgets/chapter_indicator.dart';
import 'package:quest_bible/features/bible/presentation/widgets/left_side_sections.dart';

class BiblePage extends ConsumerStatefulWidget {
  const BiblePage({super.key});

  @override
  ConsumerState<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends ConsumerState<BiblePage> {
  bool _isChapterTouchArmed = false;

  void _closeSection() {
    ref.read(activeSectionProvider.notifier).clear();
    setState(() {
      _isChapterTouchArmed = false;
    });
  }

  void _consumeChapterTouchArm() {
    if (!_isChapterTouchArmed) return;
    setState(() {
      _isChapterTouchArmed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BibleSection?>(activeSectionProvider, (previous, next) {
      if (next != null) {
        setState(() {
          _isChapterTouchArmed = true;
        });
      }
      if (next == null && _isChapterTouchArmed) {
        setState(() {
          _isChapterTouchArmed = false;
        });
      }
    });

    final activeSection = ref.watch(activeSectionProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 81, 79, 75),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
          title: const BookAndChapterHeadline(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [ChapterIndicator()],
        ),
        body: Stack(
          children: [
            Row(
              children: [
                LeftSideSections(onSectionReleased: _closeSection),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Expanded(child: ChapterContent()),
                    ],
                  ),
                ),
              ],
            ),
            if (activeSection != null)
              Row(
                children: [
                  LeftSideSections(onSectionReleased: _closeSection),
                  Expanded(
                    child: BibleSectionView(
                      section: activeSection,
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
