import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quest_bible/features/bible/application/providers/book_list_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/hovered_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/features/bible/presentation/utils.dart'
    show brighten;
import 'package:quest_bible/features/bible/presentation/widgets/chapter_container.dart';

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
    final hoveredChapter = ref.watch(hoveredChapterProvider);

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
                        hoveredChapter,
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
  HoveredChapter? hoveredChapter,
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
      hoveredChapter: hoveredChapter,
      chapterCount: booksByCode[code]?.chapterCount ?? 0,
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
    required this.hoveredChapter,
    required this.chapterCount,
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
  final HoveredChapter? hoveredChapter;
  final int chapterCount;
  final double itemWidth;
  final Future<void> Function(String bookCode, int chapterNumber)
  onChapterSelected;
  final bool isChapterTouchArmed;
  final VoidCallback? onChapterTouchConsumed;
  final bool addEmptyBlock;

  @override
  Widget build(BuildContext context) {
    const crossAxisSpacing = 3.0;
    const mainAxisSpacing = 3.0;
    final itemSize = (itemWidth - crossAxisSpacing * 9) / 10;
    final itemHeight = itemSize - 2;

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
                if (addEmptyBlock)
                  SizedBox(width: itemSize, height: itemHeight),
                ...List.generate(chapterCount, (index) {
                  final chapterNumber = index + 1;
                  return SizedBox(
                    width: itemSize,
                    height: itemHeight,
                    child: _ChapterBox(
                      bookCode: bookCode,
                      chapterNumber: chapterNumber,
                      chapterIsHovered:
                          hoveredChapter?.bookCode == bookCode &&
                          hoveredChapter?.chapterNumber == chapterNumber,
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

class _ChapterBox extends ConsumerStatefulWidget {
  const _ChapterBox({
    required this.bookCode,
    required this.chapterNumber,
    required this.chapterIsHovered,
    required this.sectionColor,
    required this.onTap,
    required this.isChapterTouchArmed,
    this.onChapterTouchConsumed,
  });

  final String bookCode;
  final int chapterNumber;
  final bool chapterIsHovered;
  final Color sectionColor;
  final Future<void> Function() onTap;
  final bool isChapterTouchArmed;
  final VoidCallback? onChapterTouchConsumed;

  @override
  ConsumerState<_ChapterBox> createState() => _ChapterBoxState();
}

class _ChapterBoxState extends ConsumerState<_ChapterBox> {
  bool _isPressed = false;

  void _setChapterHovered() {
    final hovered = ref.read(hoveredChapterProvider);
    if (hovered?.bookCode == widget.bookCode &&
        hovered?.chapterNumber == widget.chapterNumber) {
      return;
    }

    ref
        .read(hoveredChapterProvider.notifier)
        .setHovered(
          HoveredChapter(
            bookCode: widget.bookCode,
            chapterNumber: widget.chapterNumber,
          ),
        );
  }

  void _clearChapterHoveredIfCurrent() {
    final hovered = ref.read(hoveredChapterProvider);
    if (hovered?.bookCode == widget.bookCode &&
        hovered?.chapterNumber == widget.chapterNumber) {
      ref.read(hoveredChapterProvider.notifier).clear();
    }
  }

  bool _isTouchLike(PointerDeviceKind kind) {
    return kind == PointerDeviceKind.touch || kind == PointerDeviceKind.stylus;
  }

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

    if (event is PointerDownEvent && _isTouchLike(event.kind)) {
      final isInside = _containsGlobalPosition(event.position);
      _setPressed(isInside);
      if (isInside) {
        _setChapterHovered();
      }
      return;
    }

    if (event is PointerMoveEvent && _isTouchLike(event.kind)) {
      if (!event.down) {
        return;
      }

      final isInside = _containsGlobalPosition(event.position);
      _setPressed(isInside);

      if (isInside) {
        _setChapterHovered();
      }
      return;
    }

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
    final selectedBookCode = ref
        .watch(selectedBookProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    final selectedChapter = ref
        .watch(currentChapterProvider)
        .maybeWhen(data: (value) => value, orElse: () => null);
    final isSelected =
        selectedBookCode == widget.bookCode &&
        selectedChapter == widget.chapterNumber;

    final baseColor = widget.sectionColor;
    final pressedColor = widget.sectionColor;

    final backgroundColor = isSelected
        ? brighten(baseColor)
        : widget.chapterIsHovered
        ? Colors.red
        : (_isPressed ? pressedColor : baseColor);
    final borderWidth = _isPressed || isSelected ? 1.5 : 1.0;

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => _setChapterHovered(),
        onExit: (_) {
          _clearChapterHoveredIfCurrent();
          _setPressed(false);
        },
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => _setPressed(true),
          onPointerCancel: (_) => _setPressed(false),
          child: ChapterContainer(
            backgroundColor: backgroundColor,
            borderWidth: borderWidth,
            chapterNumber: widget.chapterNumber,
            isPressed: _isPressed,
            showSelected: isSelected,
          ),
        ),
      ),
    );
  }
}
