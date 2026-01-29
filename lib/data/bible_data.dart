import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'dart:convert';

// 顯示模式列舉 (共用)
enum DisplayMode {
  both,      // 同時顯示中英文
  chinese,   // 僅顯示中文
  english,   // 僅顯示英文
}

// 經文模型
class Verse {
  final String textChi;
  final String textEng;

  Verse({required this.textChi, required this.textEng});
}

// 書卷模型
class BibleBook {
  final String name; // 中文卷名 (由對照表取得)
  final String englishName; // 英文卷名 (JSON Key)
  final List<List<Verse>> chapters; // 章節資料: chapters[0] = 第一章的經文列表(Verse)

  BibleBook({
    required this.name,
    required this.englishName,
    required this.chapters,
  });

  int get chapterCount => chapters.length;
}

class ChapterContent {
  final String title;
  final List<Verse> verses;

  ChapterContent({required this.title, required this.verses});
}

// 全域資料管理
class BibleData {
  static final BibleData _instance = BibleData._internal();
  factory BibleData() => _instance;
  BibleData._internal();

  List<BibleBook> oldTestamentBooks = [];
  List<BibleBook> newTestamentBooks = [];
  bool isLoaded = false;
  
  // 全域顯示模式狀態 (預設為 中文)
  final ValueNotifier<DisplayMode> displayModeNotifier = ValueNotifier(DisplayMode.chinese);
  
  // 全域字體大小狀態 (預設由 UI 決定基準，這裡設為 20.0 作為參考值)
  final ValueNotifier<double> fontSizeNotifier = ValueNotifier(20.0);

  // 書卷名稱對照表 (英文 -> 中文)
  static final Map<String, String> bookNameMap = {
    // Old Testament
    "Genesis": "創世記", "Exodus": "出埃及記", "Leviticus": "利未記", "Numbers": "民數記", "Deuteronomy": "申命記",
    "Joshua": "約書亞記", "Judges": "士師記", "Ruth": "路得記", "1 Samuel": "撒母耳記上", "2 Samuel": "撒母耳記下",
    "1 Kings": "列王紀上", "2 Kings": "列王紀下", "1 Chronicles": "歷代志上", "2 Chronicles": "歷代志下", 
    "Ezra": "以斯拉記", "Nehemiah": "尼希米記", "Esther": "以斯帖記", "Job": "約伯記", "Psalms": "詩篇", 
    "Proverbs": "箴言", "Ecclesiastes": "傳道書", "Song of Solomon": "雅歌", "Isaiah": "以賽亞書", 
    "Jeremiah": "耶利米書", "Lamentations": "耶利米哀歌", "Ezekiel": "以西結書", "Daniel": "但以理書", 
    "Hosea": "何西阿書", "Joel": "約珥書", "Amos": "阿摩司書", "Obadiah": "俄巴底亞書", "Jonah": "約拿書", 
    "Micah": "彌迦書", "Nahum": "那鴻書", "Habakkuk": "哈巴谷書", "Zephaniah": "西番雅書", "Haggai": "哈該書", 
    "Zechariah": "撒迦利亞書", "Malachi": "瑪拉基書",
    // New Testament
    "Matthew": "馬太福音", "Mark": "馬可福音", "Luke": "路加福音", "John": "約翰福音", "Acts": "使徒行傳", 
    "Romans": "羅馬書", "1 Corinthians": "哥林多前書", "2 Corinthians": "哥林多後書", "Galatians": "加拉太書", 
    "Ephesians": "以弗所書", "Philippians": "腓立比書", "Colossians": "歌羅西書", "1 Thessalonians": "帖撒羅尼迦前書", 
    "2 Thessalonians": "帖撒羅尼迦後書", "1 Timothy": "提摩太前書", "2 Timothy": "提摩太後書", 
    "Titus": "提多書", "Philemon": "腓利門書", "Hebrews": "希伯來書", "James": "雅各書", 
    "1 Peter": "彼得前書", "2 Peter": "彼得後書", "1 John": "約翰一書", "2 John": "約翰二書", 
    "3 John": "約翰三書", "Jude": "猶大書", "Revelation": "啟示錄"
  };

  // 標準書卷順序
  static const List<String> orderedBooks = [
    "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy",
    "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel",
    "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", 
    "Ezra", "Nehemiah", "Esther", "Job", "Psalms", 
    "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", 
    "Jeremiah", "Lamentations", "Ezekiel", "Daniel", 
    "Hosea", "Joel", "Amos", "Obadiah", "Jonah", 
    "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", 
    "Zechariah", "Malachi",
    "Matthew", "Mark", "Luke", "John", "Acts", 
    "Romans", "1 Corinthians", "2 Corinthians", "Galatians", 
    "Ephesians", "Philippians", "Colossians", "1 Thessalonians", 
    "2 Thessalonians", "1 Timothy", "2 Timothy", 
    "Titus", "Philemon", "Hebrews", "James", 
    "1 Peter", "2 Peter", "1 John", "2 John", 
    "3 John", "Jude", "Revelation"
  ];

  Future<void> loadData() async {
    if (isLoaded) return;

    try {
      // 讀取這兩個 JSON 檔案
      final String jsonChiString = await rootBundle.loadString('assets/cuvmp.json');
      final String jsonEngString = await rootBundle.loadString('assets/niv.json');

      final Map<String, dynamic> dataChi = json.decode(jsonChiString);
      final Map<String, dynamic> dataEng = json.decode(jsonEngString);

      List<BibleBook> allBooks = [];

      // 依照標準順序建立 BibleBook
      for (String enName in orderedBooks) {
        if (!dataChi.containsKey(enName) || !dataEng.containsKey(enName)) {
           print("Missing book data for: $enName");
           continue; 
        }

        final bookDataChi = dataChi[enName] as Map<String, dynamic>;
        final bookDataEng = dataEng[enName] as Map<String, dynamic>; // structure: "ChapterNum": { "VerseNum": "Text" }

        List<List<Verse>> chapters = [];
        
        // 找出最大的章數
        // 因為 map keys 是字串 "1", "2"... 需要轉換成 int 來找最大值，或者假設按順序遍歷
        // 安全起見，我們遍歷 map keys 轉 int
        List<int> chapterNums = bookDataChi.keys.map((k) => int.tryParse(k) ?? 0).toList();
        chapterNums.sort(); // 1, 2, 3...

        for (int chNum in chapterNums) {
          if (chNum == 0) continue;
          
          String chKey = chNum.toString();
          Map<String, dynamic> versesChi = bookDataChi[chKey] as Map<String, dynamic>? ?? {};
          Map<String, dynamic> versesEng = bookDataEng[chKey] as Map<String, dynamic>? ?? {};

          List<Verse> verseList = [];
          
          // 找出該章最大的節數
          List<int> verseNums = versesChi.keys.map((k) => int.tryParse(k) ?? 0).toList();
          if (verseNums.isEmpty) {
             // 嘗試看英文版是否有節數 (萬一中文缺漏)
             verseNums = versesEng.keys.map((k) => int.tryParse(k) ?? 0).toList();
          }
          verseNums.sort();

          for (int vNum in verseNums) {
            String vKey = vNum.toString();
            String textC = versesChi[vKey] as String? ?? "";
            String textE = versesEng[vKey] as String? ?? "";
            
            verseList.add(Verse(textChi: textC, textEng: textE));
          }
          chapters.add(verseList);
        }

        allBooks.add(BibleBook(
          name: bookNameMap[enName] ?? enName,
          englishName: enName,
          chapters: chapters
        ));
      }


      if (allBooks.length >= 66) {
        oldTestamentBooks = allBooks.sublist(0, 39);
        newTestamentBooks = allBooks.sublist(39);
      } else {
        // Fallback catch-all if data is incomplete
        oldTestamentBooks = allBooks;
        newTestamentBooks = [];
      }

      isLoaded = true;
    } catch (e) {
      print("Error loading bible data: $e");
      // Fallback empty state
      oldTestamentBooks = [];
      newTestamentBooks = [];
    }
  }

  List<SearchResult> searchVerses(String query) {
    List<SearchResult> results = [];
    if (query.trim().isEmpty) return results;
    
    final lowerQuery = query.toLowerCase();

    void searchBooks(List<BibleBook> books) {
      for (var book in books) {
        for (int c = 0; c < book.chapters.length; c++) {
          final chapterVerses = book.chapters[c];
          for (int v = 0; v < chapterVerses.length; v++) {
            final verse = chapterVerses[v];
            if (verse.textChi.contains(query) || verse.textEng.toLowerCase().contains(lowerQuery)) {
              results.add(SearchResult(
                book: book,
                chapter: c + 1,
                verse: v + 1,
                textChi: verse.textChi,
                textEng: verse.textEng,
              ));
            }
          }
        }
      }
    }

    searchBooks(oldTestamentBooks);
    searchBooks(newTestamentBooks);
    return results;
  }
}

class SearchResult {
  final BibleBook book;
  final int chapter;
  final int verse;
  final String textChi;
  final String textEng;

  SearchResult({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.textChi,
    required this.textEng,
  });
}

List<BibleBook> get oldTestamentBooks => BibleData().oldTestamentBooks;
List<BibleBook> get newTestamentBooks => BibleData().newTestamentBooks;

int getVerseCount(String bookName, int chapter) {
  BibleBook? book = _findBook(bookName);
  if (book != null && chapter > 0 && chapter <= book.chapters.length) {
    return book.chapters[chapter - 1].length;
  }
  return 0;
}

ChapterContent getChapterContent(String bookName, int chapter) {
  BibleBook? book = _findBook(bookName);
  if (book != null && chapter > 0 && chapter <= book.chapters.length) {
    List<Verse> verses = book.chapters[chapter - 1];
    return ChapterContent(
      title: (chapter == 1) ? book.name : '', 
      verses: verses,
    );
  }
  return ChapterContent(title: '查無資料', verses: []);
}

BibleBook? _findBook(String name) {
  try {
    return BibleData().oldTestamentBooks.firstWhere((b) => b.name == name || b.englishName == name);
  } catch (e) {
    try {
      return BibleData().newTestamentBooks.firstWhere((b) => b.name == name || b.englishName == name);
    } catch (e2) {
      return null;
    }
  }
}
