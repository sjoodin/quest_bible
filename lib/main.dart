import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:quest_bible/app/app.dart';
import 'package:quest_bible/features/bible/application/providers/shared_preferences_provider.dart';
import 'package:quest_bible/features/bible/application/providers/startup_chapter_cache_provider.dart';
import 'package:quest_bible/features/bible/application/verse_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _configureLogging();

  final prefs = await SharedPreferences.getInstance();
  final selectedBookCode = prefs.getString('selectedBookCode') ?? 'JHN';
  final selectedChapter = prefs.getInt('currentChapter') ?? 1;
  final cachedVerses = decodeVerses(
    prefs.getString(lastSelectedChapterVersesKey),
  );
  final startupCache = cachedVerses == null
      ? null
      : StartupChapterCache(
          bookCode: selectedBookCode,
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

void _configureLogging() {
  if (!kDebugMode) return;

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '[${record.level.name}] ${record.time.toIso8601String()} '
      '${record.loggerName}: ${record.message}',
    );
    if (record.error != null) {
      debugPrint('error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('stackTrace: ${record.stackTrace}');
    }
  });
}
