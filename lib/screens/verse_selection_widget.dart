import 'package:flutter/material.dart';
import '../data/bible_data.dart';
import 'projection_screen.dart';

class VerseSelectionWidget extends StatelessWidget {
  final BibleBook book;
  final int chapter;

  const VerseSelectionWidget({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    // 取得該章節數 (目前暫時用假資料)
    final verseCount = getVerseCount(book.name, chapter);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // 可以在此實作返回選章的功能，目前先以此關閉
                  Navigator.pop(context);
                },
              ),
              Text(
                '選擇 ${book.name} 第 $chapter 章 節數',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: verseCount,
              itemBuilder: (context, index) {
                final verse = index + 1;
                return InkWell(
                  onTap: () {
                    // 選擇節後，進入投影畫面
                    // 先關閉 BottomSheet
                    Navigator.pop(context);
                    // 導航到投影頁面
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectionScreen(
                          book: book,
                          chapter: chapter,
                          verse: verse,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$verse',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
