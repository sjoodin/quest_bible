import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';

class LeftSideSections extends StatelessWidget {
  const LeftSideSections({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sectionHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight / bibleSections.length
            : 24.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(bibleSections.length, (index) {
            final section = bibleSections[index];
            return BibleSectionButton(
              sectionHeight: sectionHeight,
              section: section,
            );
          }),
        );
      },
    );
  }
}

class BibleSectionButton extends StatelessWidget {
  const BibleSectionButton({
    super.key,
    required this.sectionHeight,
    required this.section,
  });

  final double sectionHeight;
  final BibleSection section;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(width: 25, height: sectionHeight, color: section.color),
    );
  }
}
