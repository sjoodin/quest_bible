import 'package:flutter_riverpod/flutter_riverpod.dart';

class HoveredChapter {
  const HoveredChapter({required this.bookCode, required this.chapterNumber});

  final String bookCode;
  final int chapterNumber;
}

final hoveredChapterProvider =
    NotifierProvider<HoveredChapterNotifier, HoveredChapter?>(
      HoveredChapterNotifier.new,
    );

class HoveredChapterNotifier extends Notifier<HoveredChapter?> {
  @override
  HoveredChapter? build() => null;

  void setHovered(HoveredChapter hoveredChapter) {
    state = hoveredChapter;
  }

  void clear() {
    state = null;
  }
}
