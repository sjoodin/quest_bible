import 'package:bible_parser_flutter/bible_parser_flutter.dart';
import 'package:flutter/services.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart'
    as domain_book;
import 'package:quest_bible/features/bible/domain/entities/verse.dart'
    as domain_verse;
import 'package:logging/logging.dart';
import 'package:xml/xml.dart';

class UsfxLocalDataSource {
  static final Logger _logger = Logger('UsfxLocalDataSource');
  static List<domain_book.Book>? _booksCache;
  static late BibleRepository _repository;
  static bool _initialized = false;
  static final Map<String, List<domain_verse.Verse>> _versesCache = {};
  static Map<String, String>? _bookNamesByCode;

  Future<Map<String, String>> _loadBookNamesByCode() async {
    if (_bookNamesByCode != null) return _bookNamesByCode!;

    final bookNamesXml = await rootBundle.loadString(
      'assets/swef_usfx/BookNames.xml',
    );
    final document = XmlDocument.parse(bookNamesXml);
    final names = <String, String>{};

    for (final node in document.findAllElements('book')) {
      final code = node.getAttribute('code')?.trim().toUpperCase();
      final longName = node.getAttribute('long')?.trim();
      final shortName = node.getAttribute('short')?.trim();
      final abbr = node.getAttribute('abbr')?.trim();
      final resolvedName = longName ?? shortName ?? abbr;

      if (code != null && code.isNotEmpty && resolvedName != null) {
        names[code] = resolvedName;
      }
    }

    _bookNamesByCode = names;
    return names;
  }

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
      _logger.severe('Error initializing BibleRepository: $e');
      rethrow;
    }
  }

  Future<List<domain_book.Book>> getBooks() async {
    if (_booksCache != null) return _booksCache!;

    try {
      await _initializeRepository();
      final namesByCode = await _loadBookNamesByCode();

      final books = await _repository.getBooks();
      _booksCache = await Future.wait(
        books.asMap().entries.map((e) async {
          final chapterCount = await _repository.getChapterCount(e.value.id);
          final code = e.value.id.toUpperCase();
          final displayName = namesByCode[code] ?? e.value.title;

          return domain_book.Book(
            number: e.key + 1,
            name: displayName,
            chapterCount: chapterCount,
          );
        }),
      );

      return _booksCache!;
    } catch (e) {
      _logger.warning('Error loading books: $e');
      return [];
    }
  }

  Future<List<domain_verse.Verse>> getVerses({
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
            (e) => domain_verse.Verse(
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
      _logger.warning('Error loading verses: $e');
      return [];
    }
  }

  Future<void> close() async {
    if (_initialized) {
      await _repository.close();
    }
  }
}
