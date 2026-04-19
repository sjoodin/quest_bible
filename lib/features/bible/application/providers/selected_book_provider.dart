import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_book_provider.g.dart';

@riverpod
class SelectedBook extends _$SelectedBook {
  @override
  int build() => 43;

  void setBook(int value) => state = value;
}
