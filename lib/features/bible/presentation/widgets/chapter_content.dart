import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/chapter_verses_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/presentation/widgets/verse_tile.dart';
import 'package:quest_bible/shared/widgets/async_value_view.dart';

class ChapterContent extends ConsumerWidget {
  const ChapterContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(chapterVersesProvider);
    final selectedChapterAsync = ref.watch(currentChapterProvider);

    return AsyncValueView(
      value: versesAsync,
      data: (verses) {
        return ListView.separated(
          itemCount: verses.length + 1,
          itemBuilder: (context, index) {
            if (index < verses.length) {
              return VerseTile(verse: verses[index]);
            } else {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    final currentChapter = selectedChapterAsync.maybeWhen(
                      data: (value) => value,
                      orElse: () => 1,
                    );
                    ref
                        .read(currentChapterProvider.notifier)
                        .setChapter(currentChapter + 1);
                  },
                  child: const Text('Next Chapter'),
                ),
              );
            }
          },
          separatorBuilder: (_, index) => const Divider(height: 1),
        );
      },
    );
  }
}
