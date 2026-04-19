import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/presentation/pages/bible_page.dart';

class QuestBibleApp extends StatelessWidget {
  const QuestBibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest Bible',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const BiblePage(),
    );
  }
}
