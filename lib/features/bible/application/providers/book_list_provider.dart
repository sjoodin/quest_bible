import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/bible_repository_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/book.dart';

part 'book_list_provider.g.dart';

@riverpod
Future<List<Book>> bookList(Ref ref) {
  final repository = ref.watch(bibleRepositoryProvider);
  return repository.getBooks();
}
