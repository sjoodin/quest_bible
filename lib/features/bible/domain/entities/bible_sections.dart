import 'package:flutter/material.dart';

class BibleSection {
  const BibleSection({
    required this.id,
    required this.color,
    required this.titleColor,
    required this.name,
    required this.bookCodes,
  });

  final String id;
  final Color color;
  final Color titleColor;
  final String name;
  final List<String> bookCodes;
}

const List<BibleSection> bibleSections = [
  BibleSection(
    id: 'section_1',
    color: Color(0xFFA5D6A7),
    titleColor: Color.fromARGB(255, 68, 168, 74),
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
    titleColor: Color(0xFF2E7D32),
    name: 'Historiska böckerna 1',
    bookCodes: <String>[
      'JOS', // Joshua
      'JDG', // Judges
      'RUT', // Ruth
      '1SA', // 1 Samuel
      '2SA', // 2 Samuel
      '1KI', // 1 Kings
    ],
  ),
  BibleSection(
    id: 'section_3',
    color: Color(0xFF43A047),
    titleColor: Color(0xFF1B5E20),
    name: 'Historiska böckerna 2',
    bookCodes: <String>[
      '2KI', // 2 Kings
      '1CH', // 1 Chronicles
      '2CH', // 2 Chronicles
      'EZR', // Ezra
      'NEH', // Nehemiah
      'EST', // Esther
    ],
  ),
  BibleSection(
    id: 'section_4',
    color: Color(0xFF2E7D32),
    titleColor: Color(0xFF0B3D0B),
    name: 'Historiska böckerna 3',
    bookCodes: <String>[],
  ),
  BibleSection(
    id: 'section_5',
    color: Color(0xFF2196F3),
    titleColor: Color(0xFF0D47A1),
    name: 'Poetiska böcker 1',
    bookCodes: <String>[
      'JOB', // Job
      'PSA', // Psalms
    ],
  ),
  BibleSection(
    id: 'section_6',
    color: Color(0xFF90CAF9),
    titleColor: Color(0xFF1565C0),
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
    titleColor: Color(0xFF1A237E),
    name: 'Profetiska böcker',
    bookCodes: <String>[
      'ISA', // Isaiah
      'JER', // Jeremiah
      'LAM', // Lamentations
      'EZK', // Ezekiel
    ],
  ),
  BibleSection(
    id: 'section_8',
    color: Color(0xFF9C27B0),
    titleColor: Color(0xFF4A148C),
    name: 'Section 8',
    bookCodes: <String>[
      'DAN', // Daniel
      'HOS', // Hosea
      'JOL', // Joel
      'AMO', // Amos
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
    titleColor: Color(0xFFB71C1C),
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
    color: Color.fromARGB(255, 255, 132, 0),
    titleColor: Color.fromARGB(255, 245, 82, 23),
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
    color: Color.fromARGB(255, 178, 136, 0),
    titleColor: Color.fromARGB(255, 140, 108, 0),
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
