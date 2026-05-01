import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quest_bible/app/app.dart';

class ChapterContainer extends StatelessWidget {
  const ChapterContainer({
    super.key,
    required this.backgroundColor,
    required this.borderWidth,
    required this.isPressed,
    required this.chapterNumber,
  });

  final Color backgroundColor;
  final double borderWidth;
  final bool isPressed;
  final int chapterNumber;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: warmWhite.withValues(alpha: 0.3),
          width: borderWidth,
        ),
      ),
      child: Text(
        '$chapterNumber',
        style: TextStyle(
          fontSize: 12,
          fontFamily: GoogleFonts.lato().fontFamily,
          fontWeight: isPressed ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}
