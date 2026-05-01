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

const green1 = Color(0xFF649765); //hsl(121.2, 20.3%, 49.2%)
const green2 = Color(0xFF507850); //hsl(121.2, 20.3%, 39.2%)
const green3 = Color(0xFF3B5A3C); //hsl(121.2, 20.3%, 29.2%)
const blue1 = Color(0xFF4E88B8); //hsl(207.2, 42.7%, 51.4%)
const blue2 = Color(0xFF3C6E97); //hsl(207.2, 42.7%, 41.4%)
const blue3 = Color(0xFF2E5372); //hsl(207.2, 42.7%, 31.4%)
const purple1 = Color(0xFF6B64B9); //hsl(244.9, 37.8%, 55.9%)
const purple2 = Color(0xFF5049A1); //hsl(244.9, 37.8%, 45.9%)
const purple3 = Color(0xFF3F397E); //hsl(244.9, 37.8%, 35.9%)
const red = Color(0xFF803B36); //hsl(4.1, 40.7%, 35.7%)
const orange = Color(0xFF9E601F); //hsl(30.7, 67.2%, 37.1%)
const yellow = Color(0xFF7F692B); //hsl(44.3, 49.4%, 33.3%)

const List<BibleSection> bibleSections = [
  BibleSection(
    id: 'section_1',
    color: green1,
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
    color: green2,
    //color: Color(0xFF538555),
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
    color: green3,
    //color: Color(0xFF375E38),
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
    id: 'section_5',
    color: blue1,
    name: 'Poetiska böcker 1',
    bookCodes: <String>[
      'JOB', // Job
      'PSA', // Psalms
    ],
  ),
  BibleSection(
    id: 'section_6',
    color: blue2,
    name: 'Poetiska böcker 2',
    bookCodes: <String>[
      'PRO', // Proverbs
      'ECC', // Ecclesiastes
      'SNG', // Song of Solomon
    ],
  ),
  BibleSection(
    id: 'section_7',
    color: purple1,
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
    color: purple2,
    name: 'Profetiska böcker 2',
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
    color: red,
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
    color: orange,
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
    color: yellow,
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
