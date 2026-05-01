import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quest_bible/app/app.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/features/bible/presentation/utils.dart';

class BibleSectionView extends ConsumerWidget {
  const BibleSectionView({
    super.key,
    required this.section,
    this.onClose,
    required this.isChapterTouchArmed,
    this.onChapterTouchConsumed,
  });

  final BibleSection section;
  final VoidCallback? onClose;
  final bool isChapterTouchArmed;
  final VoidCallback? onChapterTouchConsumed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);

    return SizedBox.expand(
      child: ColoredBox(
        color: const Color.fromARGB(255, 62, 62, 62),
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
                      .setBookAndChapter(bookCode: bookCode, chapter: chapter);
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
                        Colors.transparent,
                        section.color,
                        constraints.maxWidth - 20,
                        onChapterSelected,
                        isChapterTouchArmed,
                        onChapterTouchConsumed,
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
  Color sectionColor,
  double availableWidth,
  Future<void> Function(String bookCode, int chapterNumber) onChapterSelected,
  bool isChapterTouchArmed,
  VoidCallback? onChapterTouchConsumed,
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
      sectionColor: sectionColor,
      chapterCount: booksByCode[code]?.chapterCount ?? 0,
      columnWidth: availableWidth,
      itemWidth: availableWidth,
      addEmptyBlock: addEmptyBlock,
      onChapterSelected: onChapterSelected,
      isChapterTouchArmed: isChapterTouchArmed,
      onChapterTouchConsumed: onChapterTouchConsumed,
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
    required this.sectionColor,
    required this.chapterCount,
    required this.columnWidth,
    required this.itemWidth,
    required this.onChapterSelected,
    required this.isChapterTouchArmed,
    this.onChapterTouchConsumed,
    this.addEmptyBlock = false,
  });

  final String bookCode;
  final String title;
  final Color titleColor;
  final Color sectionColor;
  final int chapterCount;
  final double columnWidth;
  final double itemWidth;
  final Future<void> Function(String bookCode, int chapterNumber)
  onChapterSelected;
  final bool isChapterTouchArmed;
  final VoidCallback? onChapterTouchConsumed;
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
                  fontFamily: GoogleFonts.lato().fontFamily,
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
                      sectionColor: sectionColor,
                      isChapterTouchArmed: isChapterTouchArmed,
                      onChapterTouchConsumed: onChapterTouchConsumed,
                      onTap: () async {
                        await onChapterSelected(bookCode, chapterNumber);
                      },
                    ),
                  );
                }),
              ],
            )
          else
            const Text('No chapters available'),
        ],
      ),
    );
  }
}

class _ChapterBox extends StatefulWidget {
  const _ChapterBox({
    required this.chapterNumber,
    required this.sectionColor,
    required this.onTap,
    required this.isChapterTouchArmed,
    this.onChapterTouchConsumed,
  });

  final int chapterNumber;
  final Color sectionColor;
  final Future<void> Function() onTap;
  final bool isChapterTouchArmed;
  final VoidCallback? onChapterTouchConsumed;

  @override
  State<_ChapterBox> createState() => _ChapterBoxState();
}

class _ChapterBoxState extends State<_ChapterBox> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool _containsGlobalPosition(Offset globalPosition) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return false;
    }
    final local = renderBox.globalToLocal(globalPosition);
    return local.dx >= 0 &&
        local.dy >= 0 &&
        local.dx <= renderBox.size.width &&
        local.dy <= renderBox.size.height;
  }

  void _handleGlobalPointerEvent(PointerEvent event) {
    if (!mounted) return;

    if (event is PointerUpEvent) {
      final shouldTrigger = _containsGlobalPosition(event.position);
      if (shouldTrigger && widget.isChapterTouchArmed) {
        _setPressed(true);
        widget.onChapterTouchConsumed?.call();
        unawaited(widget.onTap());
        Future<void>.delayed(const Duration(milliseconds: 120), () {
          if (mounted) {
            _setPressed(false);
          }
        });
      } else {
        _setPressed(false);
      }
      return;
    }

    if (event is PointerCancelEvent) {
      _setPressed(false);
    }
  }

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() {
        _isPressed = value;
      });
    }
  }

  void _setHovered(bool value) {
    if (_isHovered != value) {
      setState(() {
        _isHovered = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    GestureBinding.instance.pointerRouter.addGlobalRoute(
      _handleGlobalPointerEvent,
    );
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(
      _handleGlobalPointerEvent,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = darken(widget.sectionColor, 0.1);
    final hoverColor = warmWhite.withValues(alpha: 0.16);
    final pressedColor = widget.sectionColor;

    final backgroundColor = _isPressed
        ? pressedColor
        : (_isHovered ? hoverColor : baseColor);
    final borderWidth = _isPressed ? 1.5 : 1.0;

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) {
          _setHovered(false);
          _setPressed(false);
        },
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => _setPressed(true),
          onPointerCancel: (_) => _setPressed(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: warmWhite, width: borderWidth),
            ),
            child: Text(
              '${widget.chapterNumber}',
              style: TextStyle(
                fontSize: 12,
                fontFamily: GoogleFonts.lato().fontFamily,
                fontWeight: _isPressed ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
