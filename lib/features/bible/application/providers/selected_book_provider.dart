import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quest_bible/features/bible/application/providers/shared_preferences_provider.dart';

part 'selected_book_provider.g.dart';

const List<String> _bookCodesInOrder = [
  'GEN',
  'EXO',
  'LEV',
  'NUM',
  'DEU',
  'JOS',
  'JDG',
  'RUT',
  '1SA',
  '2SA',
  '1KI',
  '2KI',
  '1CH',
  '2CH',
  'EZR',
  'NEH',
  'EST',
  'JOB',
  'PSA',
  'PRO',
  'ECC',
  'SNG',
  'ISA',
  'JER',
  'LAM',
  'EZK',
  'DAN',
  'HOS',
  'JOL',
  'AMO',
  'OBA',
  'JON',
  'MIC',
  'NAM',
  'HAB',
  'ZEP',
  'HAG',
  'ZEC',
  'MAL',
  'MAT',
  'MRK',
  'LUK',
  'JHN',
  'ACT',
  'ROM',
  '1CO',
  '2CO',
  'GAL',
  'EPH',
  'PHP',
  'COL',
  '1TH',
  '2TH',
  '1TI',
  '2TI',
  'TIT',
  'PHM',
  'HEB',
  'JAS',
  '1PE',
  '2PE',
  '1JN',
  '2JN',
  '3JN',
  'JUD',
  'REV',
];

@riverpod
class SelectedBook extends _$SelectedBook {
  @override
  Future<String> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final persistedCode = prefs.getString('selectedBookCode');
    if (persistedCode != null && persistedCode.isNotEmpty) {
      return persistedCode;
    }

    final legacyBookNumber = prefs.getInt('selectedBook');
    if (legacyBookNumber != null &&
        legacyBookNumber >= 1 &&
        legacyBookNumber <= _bookCodesInOrder.length) {
      final migratedCode = _bookCodesInOrder[legacyBookNumber - 1];
      await prefs.setString('selectedBookCode', migratedCode);
      return migratedCode;
    }

    return 'JHN';
  }

  Future<void> setBook(String value) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setString('selectedBookCode', value);
    state = AsyncValue.data(value);
  }
}
