import 'package:quest_bible/features/bible/data/datasources/usfx_local_data_source.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';
import 'package:quest_bible/features/bible/domain/repositories/bible_repository.dart';

class BibleRepositoryImpl implements BibleRepository {
  const BibleRepositoryImpl(this._localDataSource);

  final UsfxLocalDataSource _localDataSource;

  @override
  Future<List<Book>> getBooks() {
    return _localDataSource.getBooks();
  }

  @override
  Future<List<Verse>> getVerses({
    required int bookNumber,
    required int chapterNumber,
  }) {
    return _localDataSource.getVerses(
      bookNumber: bookNumber,
      chapterNumber: chapterNumber,
    );
  }
}
