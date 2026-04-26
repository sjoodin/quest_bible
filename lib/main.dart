import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/app/app.dart';
import 'package:quest_bible/features/bible/application/providers/shared_preferences_provider.dart';
import 'package:quest_bible/features/bible/application/providers/startup_chapter_cache_provider.dart';
import 'package:quest_bible/features/bible/application/verse_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final selectedBook = prefs.getInt('selectedBook') ?? 43;
  final selectedChapter = prefs.getInt('currentChapter') ?? 1;
  final cachedVerses = decodeVerses(
    prefs.getString(lastSelectedChapterVersesKey),
  );
  final startupCache = cachedVerses == null
      ? null
      : StartupChapterCache(
          bookNumber: selectedBook,
          chapterNumber: selectedChapter,
          verses: cachedVerses,
        );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) async => prefs),
        startupChapterCacheProvider.overrideWithValue(startupCache),
      ],
      child: const QuestBibleApp(),
    ),
  );
}
