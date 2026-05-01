import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';

class VerseTile extends StatelessWidget {
  const VerseTile({super.key, required this.verse});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 3.0, left: 15.0),
        child: Text('${verse.number}'),
      ),
      horizontalTitleGap: 8,
      titleAlignment: ListTileTitleAlignment.top,
      title: Text(verse.text, style: Theme.of(context).textTheme.bodyLarge),
      dense: true,
      contentPadding: const EdgeInsets.only(right: 10),
    );
  }
}
