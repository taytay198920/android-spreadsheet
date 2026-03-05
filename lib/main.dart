import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/spreadsheet.dart';
import 'screens/spreadsheet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SpreadsheetModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '简易表格',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SpreadsheetScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}