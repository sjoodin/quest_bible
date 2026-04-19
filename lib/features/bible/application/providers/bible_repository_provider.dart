import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/data/datasources/usfx_local_data_source.dart';
import 'package:quest_bible/features/bible/data/repositories/bible_repository_impl.dart';
import 'package:quest_bible/features/bible/domain/repositories/bible_repository.dart';

part 'bible_repository_provider.g.dart';

@riverpod
BibleRepository bibleRepository(Ref ref) {
  final localDataSource = UsfxLocalDataSource();
  return BibleRepositoryImpl(localDataSource);
}
