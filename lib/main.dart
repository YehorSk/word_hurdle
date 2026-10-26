import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'hurdle_provider.dart';
import 'word_hurdle_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HurdleProvider()..init(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Hurdle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.green,
      ),
      home: const WordHurdlePage(),
    );
  }
}
