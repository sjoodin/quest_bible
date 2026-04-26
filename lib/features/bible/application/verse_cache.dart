import 'dart:convert';

import 'package:quest_bible/features/bible/domain/entities/verse.dart';

const String lastSelectedChapterVersesKey = 'last_selected_chapter_verses';

String chapterVersesCacheKey({required String bookCode, required int chapter}) {
  return 'chapter_verses_${bookCode.toUpperCase()}_$chapter';
}

String encodeVerses(List<Verse> verses) {
  final jsonList = verses
      .map(
        (verse) => {
          'bookCode': verse.bookCode,
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
        .map((item) {
          final bookCode = item['bookCode'];
          if (bookCode is! String || bookCode.isEmpty) {
            return null;
          }

          return Verse(
            bookCode: bookCode,
            chapterNumber: item['chapterNumber'] as int,
            number: item['number'] as int,
            text: item['text'] as String,
          );
        })
        .whereType<Verse>()
        .toList();
  } catch (_) {
    return null;
  }
}
