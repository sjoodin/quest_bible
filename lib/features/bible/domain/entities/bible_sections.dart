import 'package:flutter/material.dart';

class BibleSection {
  const BibleSection({
    required this.id,
    required this.color,
    required this.name,
    required this.bookCodes,
  });

  final String id;
  final Color color;
  final String name;
  final List<String> bookCodes;
}

const List<BibleSection> bibleSections = [
  BibleSection(
    id: 'section_1',
    color: Color(0xFFA5D6A7),
    name: 'Moseböckerna',
    bookCodes: <String>[
      'GEN', // Genesis
      'EXO', // Exodus
      'LEV', // Leviticus
      'NUM', // Numbers
      'DEU', // Deuteronomy
    ],
  ),
  BibleSection(
    id: 'section_2',
    color: Color(0xFF66BB6A),
    name: 'Historiska böckerna 1',
    bookCodes: <String>[
      'JOS', // Joshua
      'JDG', // Judges
      'RUT', // Ruth
      '1SA', // 1 Samuel
      '2SA', // 2 Samuel
      '1KI', // 1 Kings
      '2KI', // 2 Kings
      '1CH', // 1 Chronicles
    ],
  ),
  BibleSection(
    id: 'section_3',
    color: Color(0xFF43A047),
    name: 'Historiska böckerna 2',
    bookCodes: <String>[
      '2CH', // 2 Chronicles
      'EZR', // Ezra
      'NEH', // Nehemiah
      'EST', // Esther
    ],
  ),
  BibleSection(
    id: 'section_4',
    color: Color(0xFF2E7D32),
    name: 'Historiska böckerna 3',
    bookCodes: <String>[],
  ),
  BibleSection(
    id: 'section_5',
    color: Color(0xFF2196F3),
    name: 'Poetiska böcker 1',
    bookCodes: <String>[
      'JOB', // Job
      'PSA', // Psalms
    ],
  ),
  BibleSection(
    id: 'section_6',
    color: Color(0xFF90CAF9),
    name: 'Poetiska böcker 2',
    bookCodes: <String>[
      'PRO', // Proverbs
      'ECC', // Ecclesiastes
      'SNG', // Song of Solomon
    ],
  ),
  BibleSection(
    id: 'section_7',
    color: Color(0xFF3F51B5),
    name: 'Profetiska böcker',
    bookCodes: <String>[
      'ISA', // Isaiah
      'JER', // Jeremiah
      'LAM', // Lamentations
      'EZK', // Ezekiel
      'DAN', // Daniel
      'HOS', // Hosea
      'JOL', // Joel
      'AMO', // Amos
    ],
  ),
  BibleSection(
    id: 'section_8',
    color: Color(0xFF9C27B0),
    name: 'Section 8',
    bookCodes: <String>[
      'OBA', // Obadiah
      'JON', // Jonah
      'MIC', // Micah
      'NAM', // Nahum
      'HAB', // Habakkuk
      'ZEP', // Zephaniah
      'HAG', // Haggai
      'ZEC', // Zechariah
      'MAL', // Malachi
    ],
  ),
  BibleSection(
    id: 'section_9',
    color: Color(0xFFF44336),
    name: 'Evangelierna och Apostlagärningarna',
    bookCodes: <String>[
      'MAT', // Matthew
      'MRK', // Mark
      'LUK', // Luke
      'JHN', // John
      'ACT', // Acts
    ],
  ),
  BibleSection(
    id: 'section_10',
    color: Color(0xFFFFEB3B),
    name: 'Paulus brev',
    bookCodes: <String>[
      'ROM', // Romans
      '1CO', // 1 Corinthians
      '2CO', // 2 Corinthians
      'GAL', // Galatians
      'EPH', // Ephesians
      'PHP', // Philippians
      'COL', // Colossians
      '1TH', // 1 Thessalonians
      '2TH', // 2 Thessalonians
      '1TI', // 1 Timothy
      '2TI', // 2 Timothy
      'TIT', // Titus
      'PHM', // Philemon
    ],
  ),
  BibleSection(
    id: 'section_11',
    color: Color(0xFFFBC02D),
    name: 'Andra brev och Uppenbarelseboken',
    bookCodes: <String>[
      'HEB', // Hebrews
      'JAS', // James
      '1PE', // 1 Peter
      '2PE', // 2 Peter
      '1JN', // 1 John
      '2JN', // 2 John
      '3JN', // 3 John
      'JUD', // Jude
      'REV', // Revelation
    ],
  ),
];
