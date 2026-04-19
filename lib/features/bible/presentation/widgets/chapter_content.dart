import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/chapter_verses_provider.dart';
import 'package:quest_bible/features/bible/presentation/widgets/verse_tile.dart';
import 'package:quest_bible/shared/widgets/async_value_view.dart';

class ChapterContent extends ConsumerWidget {
  const ChapterContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(chapterVersesProvider);

    return AsyncValueView(
      value: versesAsync,
      data: (verses) {
        return ListView.separated(
          itemCount: verses.length,
          itemBuilder: (context, index) {
            return VerseTile(verse: verses[index]);
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
        );
      },
    );
  }
}
