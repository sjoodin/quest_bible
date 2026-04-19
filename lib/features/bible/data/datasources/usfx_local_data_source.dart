import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';

class UsfxLocalDataSource {
  Future<List<Book>> getBooks() async {
    return const [
      Book(number: 1, name: 'Genesis', chapterCount: 50),
      Book(number: 2, name: 'Exodus', chapterCount: 40),
      Book(number: 19, name: 'Psalms', chapterCount: 150),
      Book(number: 40, name: 'Matthew', chapterCount: 28),
      Book(number: 43, name: 'John', chapterCount: 21),
      Book(number: 45, name: 'Romans', chapterCount: 16),
    ];
  }

  Future<List<Verse>> getVerses({
    required int bookNumber,
    required int chapterNumber,
  }) async {
    return List<Verse>.generate(
      12,
      (index) => Verse(
        bookNumber: bookNumber,
        chapterNumber: chapterNumber,
        number: index + 1,
        text: 'Sample verse text for $bookNumber:$chapterNumber:${index + 1}',
      ),
    );
  }
}
