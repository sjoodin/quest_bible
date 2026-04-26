import 'dart:convert';

import 'package:quest_bible/features/bible/domain/entities/verse.dart';

const String lastSelectedChapterVersesKey = 'last_selected_chapter_verses';

String chapterVersesCacheKey({required int book, required int chapter}) {
  return 'chapter_verses_${book}_$chapter';
}

String encodeVerses(List<Verse> verses) {
  final jsonList = verses
      .map(
        (verse) => {
          'bookNumber': verse.bookNumber,
          'chapterNumber': verse.chapterNumber,
          'number': verse.number,
          'text': verse.text,
        },
      )
      .toList();

  return jsonEncode(jsonList);
}

List<Verse>? decodeVerses(String? jsonString) {
  if (jsonString == null || jsonString.isEmpty) {
    return null;
  }

  try {
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      return null;
    }

    return decoded
        .whereType<Map>()
        .map(
          (item) => Verse(
            bookNumber: item['bookNumber'] as int,
            chapterNumber: item['chapterNumber'] as int,
            number: item['number'] as int,
            text: item['text'] as String,
          ),
        )
        .toList();
  } catch (_) {
    return null;
  }
}
