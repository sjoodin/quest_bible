import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';

class LeftSideSections extends StatelessWidget {
  const LeftSideSections({super.key, required this.onSectionPressed});

  final ValueChanged<BibleSection> onSectionPressed;

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
              onPressed: () => onSectionPressed(section),
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
    required this.onPressed,
  });

  final double sectionHeight;
  final BibleSection section;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(width: 25, height: sectionHeight, color: section.color),
    );
  }
}
