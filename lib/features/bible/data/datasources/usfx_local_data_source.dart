import 'package:bible_parser_flutter/bible_parser_flutter.dart';
import 'package:flutter/services.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart'
    as domainBook;
import 'package:quest_bible/features/bible/domain/entities/verse.dart'
    as domainVerse;

class UsfxLocalDataSource {
  static List<domainBook.Book>? _booksCache;
  static late BibleRepository _repository;
  static bool _initialized = false;
  static Map<String, List<domainVerse.Verse>> _versesCache = {};

  Future<void> _initializeRepository() async {
    if (_initialized) return;

    try {
      // Load the USFX XML file from assets
      final xmlString = await rootBundle.loadString(
        'assets/swef_usfx/swef_usfx.xml',
      );

      // Create repository from XML string
      _repository = BibleRepository.fromString(
        xmlString: xmlString,
        format: 'USFX',
      );

      // Initialize database (parses XML and stores in SQLite)
      await _repository.initialize('quest_bible.db');
      _initialized = true;
    } catch (e) {
      print('Error initializing BibleRepository: $e');
      rethrow;
    }
  }

  Future<List<domainBook.Book>> getBooks() async {
    if (_booksCache != null) return _booksCache!;

    try {
      await _initializeRepository();

      final books = await _repository.getBooks();
      _booksCache = await Future.wait(
        books.asMap().entries.map((e) async {
          final chapterCount = await _repository.getChapterCount(e.value.id);
          return domainBook.Book(
            number: e.key + 1,
            name: e.value.title,
            chapterCount: chapterCount,
          );
        }),
      );

      return _booksCache!;
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }

  Future<List<domainVerse.Verse>> getVerses({
    required int bookNumber,
    required int chapterNumber,
  }) async {
    final cacheKey = '$bookNumber:$chapterNumber';
    if (_versesCache.containsKey(cacheKey)) {
      return _versesCache[cacheKey]!;
    }

    try {
      await _initializeRepository();

      final books = await _repository.getBooks();
      if (bookNumber < 1 || bookNumber > books.length) {
        return [];
      }

      final book = books[bookNumber - 1];
      final chapterCount = await _repository.getChapterCount(book.id);
      if (chapterNumber < 1 || chapterNumber > chapterCount) {
        return [];
      }

      final verses = await _repository.getVerses(book.id, chapterNumber);
      final domainVerses = verses
          .asMap()
          .entries
          .map(
            (e) => domainVerse.Verse(
              bookNumber: bookNumber,
              chapterNumber: chapterNumber,
              number: e.value.num,
              text: e.value.text,
            ),
          )
          .toList();

      _versesCache[cacheKey] = domainVerses;
      return domainVerses;
    } catch (e) {
      print('Error loading verses: $e');
      return [];
    }
  }

  Future<void> close() async {
    if (_initialized) {
      await _repository.close();
    }
  }
}
