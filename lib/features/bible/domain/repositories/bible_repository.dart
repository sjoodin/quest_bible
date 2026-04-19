import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';

abstract class BibleRepository {
  Future<List<Book>> getBooks();
  Future<List<Verse>> getVerses({
    required int bookNumber,
    required int chapterNumber,
  });
}
