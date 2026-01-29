import 'package:flutter/material.dart';
import '../data/bible_data.dart';
import 'chapter_selection_widget.dart';
import 'bible_search_delegate.dart';

class BookSelectionScreen extends StatefulWidget {
  const BookSelectionScreen({super.key});

  @override
  State<BookSelectionScreen> createState() => _BookSelectionScreenState();
}

class _BookSelectionScreenState extends State<BookSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DisplayMode>(
      valueListenable: BibleData().displayModeNotifier,
      builder: (context, currentMode, child) {
        return DefaultTabController(
          length: 2, // 舊約、新約
          child: Scaffold(
            appBar: AppBar(
              title: const Text('聖經目錄'),
              actions: [
                // 搜尋按鈕
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: '搜尋經文',
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: BibleSearchDelegate(),
                    );
                  },
                ),
                // 顯示模式切換按鈕
                PopupMenuButton<DisplayMode>(
                  icon: const Icon(Icons.translate),
                  tooltip: '切換語言顯示',
                  onSelected: (DisplayMode mode) {
                    BibleData().displayModeNotifier.value = mode;
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: DisplayMode.both,
                      child: Row(
                        children: [
                          Icon(
                            currentMode == DisplayMode.both ? Icons.check : null,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text('中英對照'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: DisplayMode.chinese,
                      child: Row(
                        children: [
                          Icon(
                            currentMode == DisplayMode.chinese ? Icons.check : null,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text('僅中文'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: DisplayMode.english,
                      child: Row(
                        children: [
                          Icon(
                            currentMode == DisplayMode.english ? Icons.check : null,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text('僅英文'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: '舊約'),
                  Tab(text: '新約'),
                ],
                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            body: TabBarView(
              children: [
                _buildBookList(context, oldTestamentBooks, currentMode),
                _buildBookList(context, newTestamentBooks, currentMode),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildBookList(BuildContext context, List<BibleBook> books, DisplayMode mode) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          title: Text(
            _getBookDisplayName(book, mode),
            style: const TextStyle(fontSize: 24),
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, 
              builder: (context) => ChapterSelectionWidget(book: book),
            );
          },
        );
      },
    );
  }

  String _getBookDisplayName(BibleBook book, DisplayMode mode) {
    switch (mode) {
      case DisplayMode.chinese:
        return book.name;
      case DisplayMode.english:
        // 如果英文名為空，回退到中文
        return book.englishName.isNotEmpty ? book.englishName : book.name;
      case DisplayMode.both:
        if (book.englishName.isNotEmpty) {
          return '${book.name} ${book.englishName}';
        }
        return book.name;
    }
  }
}
