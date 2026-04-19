import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';

class VerseTile extends StatelessWidget {
  const VerseTile({super.key, required this.verse});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('${verse.number}'),
      title: Text(verse.text),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
