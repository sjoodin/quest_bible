import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/bible_repository_provider.dart';
import 'package:quest_bible/features/bible/application/providers/current_chapter_provider.dart';
import 'package:quest_bible/features/bible/application/providers/selected_book_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/verse.dart';

part 'chapter_verses_provider.g.dart';

@riverpod
Future<List<Verse>> chapterVerses(Ref ref) async {
  final repository = ref.watch(bibleRepositoryProvider);
  final book = ref.watch(selectedBookProvider);
  final chapter = ref.watch(currentChapterProvider);

  return repository.getVerses(bookNumber: book, chapterNumber: chapter);
}
