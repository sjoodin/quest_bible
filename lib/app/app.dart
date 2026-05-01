import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quest_bible/features/bible/presentation/pages/bible_page.dart';

const warmWhite = Color(0xFFF5EBDD);
const darkWarmWhite = Color(0xFFE8C9A6);

class QuestBibleApp extends StatelessWidget {
  const QuestBibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest Bible',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 232, 132, 11),
              brightness: Brightness.dark,
            ).copyWith(
              onSurface: warmWhite,
              onPrimary: warmWhite,
              onSecondary: warmWhite,
              outline: warmWhite,
              outlineVariant: warmWhite,
            ),
        dividerColor: warmWhite,
        textTheme: GoogleFonts.sourceSerif4TextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).apply(bodyColor: warmWhite, displayColor: warmWhite),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: warmWhite,
            textStyle: GoogleFonts.sourceSerif4().copyWith(
              color: warmWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const BiblePage(),
    );
  }
}
