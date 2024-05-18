import 'package:flutter/material.dart';

import 'homepage/homepage.dart';

void main() {
  runApp(const RecRecApp());
}

class RecRecApp extends StatelessWidget {
  const RecRecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Recommendator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 170, 228, 255)),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
