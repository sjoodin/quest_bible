import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';

class BibleSectionView extends ConsumerWidget {
  const BibleSectionView({super.key, required this.section});

  final BibleSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);

    return SizedBox.expand(
      child: ColoredBox(
        color: section.color,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => booksAsync.when(
              data: (books) {
                final booksByCode = <String, Book>{
                  for (final book in books) book.code: book,
                };

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final bookCode in section.bookCodes)
                          _SectionBookChapters(
                            title: booksByCode[bookCode]?.name ?? bookCode,
                            chapterCount:
                                booksByCode[bookCode]?.chapterCount ?? 0,
                          ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Failed to load section books: $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionBookChapters extends StatelessWidget {
  const _SectionBookChapters({required this.title, required this.chapterCount});

  final String title;
  final int chapterCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (chapterCount > 0)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chapterCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final chapterNumber = index + 1;
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Text(
                    '$chapterNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            )
          else
            const Text(
              'No chapters available',
              style: TextStyle(color: Colors.white70),
            ),
        ],
      ),
    );
  }
}
