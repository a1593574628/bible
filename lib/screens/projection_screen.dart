import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/bible_data.dart';
import 'bible_search_delegate.dart';

class ProjectionScreen extends StatefulWidget {
  final BibleBook book;
  final int chapter;
  final int verse;

  const ProjectionScreen({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
  });

  @override
  State<ProjectionScreen> createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends State<ProjectionScreen> {
  late ChapterContent _content;
  final List<GlobalKey> _verseKeys = [];
  
  // 用來追蹤目前滑鼠游標停在哪一節 (Hover effect)
  int? _hoveredIndex;
  
  // 記錄被選取的經文 Index (0-based)
  final Set<int> _selectedVerses = {};

  @override
  void initState() {
    super.initState();
    _content = getChapterContent(widget.book.name, widget.chapter);
    for (int i = 0; i < _content.verses.length; i++) {
      _verseKeys.add(GlobalKey());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedVerse();
    });
  }

  void _scrollToSelectedVerse() {
    final targetIndex = widget.verse - 1;
    if (targetIndex >= 0 && targetIndex < _verseKeys.length) {
      final key = _verseKeys[targetIndex];
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500), 
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedVerses.contains(index)) {
        _selectedVerses.remove(index);
      } else {
        _selectedVerses.add(index);
      }
    });
  }

  void _copySelectedVerses(DisplayMode mode) {
    if (_selectedVerses.isEmpty) return;

    final sortedIndices = _selectedVerses.toList()..sort();
    final buffer = StringBuffer();
    
    // 產生標題行: "創世記 1:1-3" 或 "創世記 1:1,5,6"
    String reference = '${widget.book.name} ${widget.chapter}:${_getFormattedReferenceString(sortedIndices)}';
    buffer.writeln(reference);

    // 產生內容行
    for (int index in sortedIndices) {
      final verse = _content.verses[index];
      final verseNum = index + 1;
      
      // 格式: (1) 起初神創造...
      // 或者只是: 1 起初神創造...
      // 這裡選擇簡單的: [1] 內容
      buffer.write('[$verseNum] ');
      
      if (mode == DisplayMode.chinese || mode == DisplayMode.both) {
        buffer.write(verse.textChi);
        if (mode == DisplayMode.both) buffer.write(' ');
      }
      
      if (mode == DisplayMode.english || mode == DisplayMode.both) {
        buffer.write(verse.textEng);
      }
      
      buffer.writeln();
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已複製: $reference')),
    );
    
    setState(() {
      _selectedVerses.clear();
    });
  }

  // 將 [0, 1, 2, 4, 6] (0-based) 轉換成 "1-3,5,7"
  String _getFormattedReferenceString(List<int> sortedIndices) {
    if (sortedIndices.isEmpty) return "";
    
    // 轉為 1-based
    final verses = sortedIndices.map((i) => i + 1).toList();
    
    List<String> parts = [];
    int? start = verses[0];
    int? end = verses[0];

    for (int i = 1; i < verses.length; i++) {
      if (verses[i] == end! + 1) {
        // 連續
        end = verses[i];
      } else {
        // 不連續，結算上一段
        if (start == end) {
          parts.add("$start");
        } else {
          parts.add("$start-$end");
        }
        // 開啟新一段
        start = verses[i];
        end = verses[i];
      }
    }
    
    // 結算最後一段
    if (start == end) {
      parts.add("$start");
    } else {
      parts.add("$start-$end");
    }

    return parts.join(',');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DisplayMode>(
      valueListenable: BibleData().displayModeNotifier,
      builder: (context, currentMode, child) {
        return ValueListenableBuilder<double>(
          valueListenable: BibleData().fontSizeNotifier,
          builder: (context, currentFontSize, child) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text('${widget.book.name} 第 ${widget.chapter} 章'),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                actions: [
                  // 縮小字體
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: '縮小字體',
                    onPressed: () {
                      if (currentFontSize > 10) {
                        BibleData().fontSizeNotifier.value -= 2;
                      }
                    },
                  ),
                  // 放大字體
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: '放大字體',
                    onPressed: () {
                      if (currentFontSize < 100) {
                        BibleData().fontSizeNotifier.value += 2;
                      }
                    },
                  ),
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
                    tooltip: '切換顯示模式',
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
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Column(
                  children: [
                    // 標題
                    if (_content.title.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        alignment: Alignment.center,
                        child: Text(
                          _content.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: currentFontSize * 2, // 標題是兩倍大
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    
                    // 經文列表
                    ...List.generate(_content.verses.length, (index) {
                      final verseIndex = index;
                      final verse = _content.verses[verseIndex];
                      
                      // 節數
                      final String verseNumStr = "${verseIndex + 1}";
                      final isHovered = _hoveredIndex == verseIndex;
                      final isSelected = _selectedVerses.contains(verseIndex);

                      return MouseRegion(
                        onEnter: (_) => setState(() => _hoveredIndex = verseIndex),
                        onExit: (_) => setState(() => _hoveredIndex = null),
                        child: GestureDetector(
                          onTap: () => _toggleSelection(verseIndex),
                          child: Container(
                            key: _verseKeys[verseIndex],
                            margin: const EdgeInsets.only(bottom: 24.0),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Colors.blue.withOpacity(0.3) 
                                  : (isHovered ? Colors.grey.shade900 : Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected ? Border.all(color: Colors.blueAccent, width: 2) : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center, // 改為置中
                              children: [
                                // 節數
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    verseNumStr,
                                    textAlign: TextAlign.center, // 文字置中
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : (isHovered ? Colors.yellow : Colors.grey),
                                      fontSize: currentFontSize, // 節數與基準字體相同
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                
                                // 中文經文 (若顯示模式包含中文)
                                if (currentMode == DisplayMode.both || currentMode == DisplayMode.chinese)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      verse.textChi,
                                      textAlign: TextAlign.center, // 文字置中
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : (isHovered ? Colors.yellow : Colors.white),
                                        fontSize: currentFontSize * 1.6, // 中文稍微大一點
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                
                                // 英文經文 (若顯示模式包含英文)
                                if (currentMode == DisplayMode.both || currentMode == DisplayMode.english)
                                  Text(
                                    verse.textEng,
                                    textAlign: TextAlign.center, // 文字置中
                                    style: TextStyle(
                                      color: isSelected ? Colors.white70 : (isHovered ? Colors.yellow.shade200 : Colors.grey.shade400),
                                      fontSize: currentFontSize * 1.2, // 英文比中文小
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              floatingActionButton: _selectedVerses.isNotEmpty
                  ? FloatingActionButton.extended(
                      onPressed: () => _copySelectedVerses(currentMode),
                      icon: const Icon(Icons.copy),
                      label: Text('複製 (${_selectedVerses.length})'),
                    )
                  : null,
            );
          }
        );
      }
    );
  }
}
