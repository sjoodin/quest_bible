import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';

class BibleSectionView extends ConsumerWidget {
  const BibleSectionView({super.key, required this.section, this.onClose});

  final BibleSection section;
  final VoidCallback? onClose;

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

                Future<void> onChapterSelected(
                  String bookCode,
                  int chapter,
                ) async {
                  await ref
                      .read(selectedBookProvider.notifier)
                      .setBook(bookCode);
                  await ref
                      .read(currentChapterProvider.notifier)
                      .setChapter(chapter);
                  onClose?.call();
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildBookRows(
                        section.bookCodes,
                        booksByCode,
                        section.titleColor,
                        constraints.maxWidth - 20,
                        onChapterSelected,
                      ),
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

List<Widget> _buildBookRows(
  List<String> bookCodes,
  Map<String, Book> booksByCode,
  Color titleColor,
  double availableWidth,
  Future<void> Function(String bookCode, int chapterNumber) onChapterSelected,
) {
  const maxGroupChapters = 9;
  final rows = <Widget>[];
  var i = 0;

  _SectionBookChapters buildSection(
    String code, {
    required bool addEmptyBlock,
  }) {
    return _SectionBookChapters(
      bookCode: code,
      title: booksByCode[code]?.name ?? code,
      titleColor: titleColor,
      chapterCount: booksByCode[code]?.chapterCount ?? 0,
      columnWidth: availableWidth,
      itemWidth: availableWidth,
      addEmptyBlock: addEmptyBlock,
      onChapterSelected: onChapterSelected,
    );
  }

  while (i < bookCodes.length) {
    final currentCode = bookCodes[i];
    final currentCount = booksByCode[currentCode]?.chapterCount ?? 0;

    final hasNext = i + 1 < bookCodes.length;
    final nextCode = hasNext ? bookCodes[i + 1] : null;
    final nextCount = nextCode != null
        ? (booksByCode[nextCode]?.chapterCount ?? 0)
        : 0;
    final canPair = hasNext && (currentCount + nextCount) <= maxGroupChapters;

    if (canPair && nextCode != null) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: buildSection(currentCode, addEmptyBlock: false)),
              Expanded(child: buildSection(nextCode, addEmptyBlock: true)),
            ],
          ),
        ),
      );
      i += 2;
      continue;
    }

    rows.add(buildSection(currentCode, addEmptyBlock: false));
    i += 1;
  }
  return rows;
}

class _SectionBookChapters extends StatelessWidget {
  const _SectionBookChapters({
    required this.bookCode,
    required this.title,
    required this.titleColor,
    required this.chapterCount,
    required this.columnWidth,
    required this.itemWidth,
    required this.onChapterSelected,
    this.addEmptyBlock = false,
  });

  final String bookCode;
  final String title;
  final Color titleColor;
  final int chapterCount;
  final double columnWidth;
  final double itemWidth;
  final Future<void> Function(String bookCode, int chapterNumber)
  onChapterSelected;
  final bool addEmptyBlock;

  @override
  Widget build(BuildContext context) {
    const crossAxisSpacing = 5.0;
    const mainAxisSpacing = 3.0;
    final itemSize = (itemWidth - crossAxisSpacing * 9) / 10;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: titleColor,
            child: Padding(
              padding: EdgeInsets.only(
                left: addEmptyBlock ? itemSize + crossAxisSpacing : 0,
              ),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (chapterCount > 0)
            Wrap(
              spacing: crossAxisSpacing,
              runSpacing: mainAxisSpacing,
              children: [
                if (addEmptyBlock) SizedBox(width: itemSize, height: itemSize),
                ...List.generate(chapterCount, (index) {
                  final chapterNumber = index + 1;
                  return SizedBox(
                    width: itemSize,
                    height: itemSize,
                    child: _ChapterBox(
                      chapterNumber: chapterNumber,
                      onTap: () async {
                        await onChapterSelected(bookCode, chapterNumber);
                      },
                    ),
                  );
                }),
              ],
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

class _ChapterBox extends StatefulWidget {
  const _ChapterBox({required this.chapterNumber, required this.onTap});

  final int chapterNumber;
  final Future<void> Function() onTap;

  @override
  State<_ChapterBox> createState() => _ChapterBoxState();
}

class _ChapterBoxState extends State<_ChapterBox> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.white.withValues(alpha: 0.08);
    final hoverColor = Colors.white.withValues(alpha: 0.16);
    final pressedColor = const Color.fromARGB(255, 255, 0, 0);

    final backgroundColor = _isPressed
        ? pressedColor
        : (_isHovered ? hoverColor : baseColor);
    final borderWidth = _isPressed ? 1.5 : 1.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (value) {
          if (_isHovered != value) {
            setState(() {
              _isHovered = value;
            });
          }
        },
        onHighlightChanged: (value) {
          if (_isPressed != value) {
            setState(() {
              _isPressed = value;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.white, width: borderWidth),
          ),
          child: Text(
            '${widget.chapterNumber}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: _isPressed ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
