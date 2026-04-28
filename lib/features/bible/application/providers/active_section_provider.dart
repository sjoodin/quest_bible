import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';

final activeSectionProvider = NotifierProvider<ActiveSectionNotifier, BibleSection?>(
	ActiveSectionNotifier.new,
);

class ActiveSectionNotifier extends Notifier<BibleSection?> {
	@override
	BibleSection? build() => null;

	void setSection(BibleSection? section) {
		state = section;
	}

	void clear() {
		state = null;
	}
}
