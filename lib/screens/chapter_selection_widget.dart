import 'package:flutter/material.dart';
import '../data/bible_data.dart';
import 'verse_selection_widget.dart';

class ChapterSelectionWidget extends StatelessWidget {
  final BibleBook book;

  const ChapterSelectionWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // 佔螢幕高一點
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            '選擇 ${book.name} 章節',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // 一列5個
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: book.chapterCount,
              itemBuilder: (context, index) {
                final chapter = index + 1;
                return InkWell(
                  onTap: () {
                    // 選擇章節後，關閉目前的 BottomSheet (或是疊加另一個)
                    // 這裡選擇先關閉目前的，再開啟節的選擇，或者直接疊加上去
                    // 為了體驗流暢，我們嘗試直接疊加顯示「選擇節」的視窗
                    // 但通常 ModalBottomSheet 疊加可能會有 UX 問題
                    // 這裡改為：點選後 Pop 掉目前的，然後 Push 一個新的 Route 或顯示另一個 Dialog
                    // 為了符合 "跳出" 的感覺，我們在目前的 Sheet 上面再蓋一層，或者切換內容
                    
                    // 簡單作法：關閉選章，開啟選節
                    Navigator.pop(context); 
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => VerseSelectionWidget(
                        book: book,
                        chapter: chapter,
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$chapter',
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
