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
            return ValueListenableBuilder<Color>(
              valueListenable: BibleData().backgroundColorNotifier,
              builder: (context, bgColor, child) {
                return ValueListenableBuilder<Color>(
                  valueListenable: BibleData().textColorNotifier,
                  builder: (context, textColor, child) {
                    return Scaffold(
                      backgroundColor: bgColor,
              appBar: AppBar(
                title: Text('${widget.book.name} 第 ${widget.chapter} 章'),
                backgroundColor: bgColor,
                foregroundColor: textColor,
                actions: [
                  // 縮小字體
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: '縮小字體',
                    onPressed: () {
                      if (currentFontSize > 10) {
                        BibleData().fontSizeNotifier.value -= 2;
                        BibleData().saveSettings();
                      }
                    },
                  ),
                  // 顯示目前字體大小百分比
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      '${(currentFontSize / 20 * 100).round()}%',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // 放大字體
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: '放大字體',
                    onPressed: () {
                      if (currentFontSize < 100) {
                        BibleData().fontSizeNotifier.value += 2;
                        BibleData().saveSettings();
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
                      BibleData().saveSettings();
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
                  // 顏色設定按鈕
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.palette),
                    tooltip: '投影顏色設定',
                    onSelected: (String value) {
                      if (value == 'dark') {
                        BibleData().backgroundColorNotifier.value = Colors.black;
                        BibleData().textColorNotifier.value = Colors.white;
                      } else if (value == 'light') {
                        BibleData().backgroundColorNotifier.value = Colors.white;
                        BibleData().textColorNotifier.value = Colors.black;
                      }
                      BibleData().saveSettings();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'light',
                        child: Row(
                          children: [
                            Container(
                              width: 20, 
                              height: 20, 
                              decoration: BoxDecoration(
                                color: Colors.white, 
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('淺色模式'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'dark',
                        child: Row(
                          children: [
                            Container(
                              width: 20, 
                              height: 20, 
                              decoration: const BoxDecoration(color: Colors.black),
                            ),
                            const SizedBox(width: 8),
                            const Text('深色模式'),
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
                            color: textColor,
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
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected ? Border.all(color: Colors.blueAccent, width: 2) : null,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 節數區塊 (固定寬度，靠左對齊)
                                SizedBox(
                                  width: 50, // 固定寬度給節數
                                  child: Text(
                                    verseNumStr,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: isSelected ? textColor : (isHovered ? (bgColor == Colors.white ? Colors.red : Colors.yellow) : textColor.withOpacity(0.6)),
                                      fontSize: currentFontSize * 1.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // 經文區塊 (填滿剩餘空間，靠左對齊)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 中文經文
                                      if (currentMode == DisplayMode.both || currentMode == DisplayMode.chinese)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 4.0),
                                          child: Text(
                                            verse.textChi,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: isSelected ? textColor : (isHovered ? (bgColor == Colors.white ? Colors.red : Colors.yellow) : textColor),
                                              fontSize: currentFontSize * 1.6,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      // 英文經文
                                      if (currentMode == DisplayMode.both || currentMode == DisplayMode.english)
                                        Text(
                                          verse.textEng,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: isSelected ? textColor.withOpacity(0.7) : (isHovered ? (bgColor == Colors.white ? Colors.red.shade300 : Colors.yellow.shade200) : textColor.withOpacity(0.5)),
                                            fontSize: currentFontSize * 1.6,
                                            fontStyle: FontStyle.italic,
                                            height: 1.4,
                                          ),
                                        ),
                                    ],
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
        );
      }
    );
  }
}
