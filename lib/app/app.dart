import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/presentation/pages/bible_page.dart';

class QuestBibleApp extends StatelessWidget {
  const QuestBibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest Bible',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 232, 132, 11),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const BiblePage(),
    );
  }
}
