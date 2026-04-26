import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';

class StartupChapterCache {
  const StartupChapterCache({
    required this.bookCode,
    required this.chapterNumber,
    required this.verses,
  });

  final String bookCode;
  final int chapterNumber;
  final List<Verse> verses;
}

final startupChapterCacheProvider = Provider<StartupChapterCache?>(
  (ref) => null,
);
