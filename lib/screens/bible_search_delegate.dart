import 'package:flutter/material.dart';
import '../data/bible_data.dart';
import 'projection_screen.dart';

class BibleSearchDelegate extends SearchDelegate<SearchResult?> {
  @override
  String get searchFieldLabel => '搜尋經文...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('請輸入關鍵字'));
    }

    final results = BibleData().searchVerses(query);

    if (results.isEmpty) {
      return const Center(child: Text('找不到相關經文'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ListTile(
          title: Text(
            '${result.book.name} ${result.chapter}:${result.verse}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.textChi.isNotEmpty) 
                _buildHighlightedText(result.textChi, query, Colors.black),
              if (result.textEng.isNotEmpty) 
                _buildHighlightedText(result.textEng, query, Colors.grey[600]!),
            ],
          ),
          onTap: () {
            close(context, result);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectionScreen(
                  book: result.book,
                  chapter: result.chapter,
                  verse: result.verse,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('輸入關鍵字搜尋經文', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Helper method to highlight query in text
  Widget _buildHighlightedText(String text, String query, Color defaultColor) {
    if (query.isEmpty) {
      return Text(text, style: TextStyle(color: defaultColor));
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    
    int start = 0;
    while (true) {
      final int index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        // Append remaining text
        spans.add(TextSpan(
          text: text.substring(start),
          style: TextStyle(color: defaultColor),
        ));
        break;
      }

      // Append text before match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(color: defaultColor),
        ));
      }

      // Append matched text
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          color: Colors.black, // Text color on yellow background
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = index + query.length;
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
