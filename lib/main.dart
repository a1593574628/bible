import 'package:flutter/material.dart';
import 'screens/book_selection_screen.dart';
import 'data/bible_data.dart';

void main() async {
  // 確保 Flutter 綁定初始化，因為要讀取 Assets
  WidgetsFlutterBinding.ensureInitialized();
  
  // 啟動前先載入資料 (或是顯示 Loading 頁面)
  // 因為檔案有 4MB，可能會花一點點時間，建議加個 Loading 狀態
  // 但為了簡單，先 await
  await BibleData().loadSettings();  // 載入儲存的設定
  await BibleData().loadData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Projection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BookSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
