import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rec_rec_app/firebase_options.dart';

import 'homepage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RecRecApp());
}

class RecRecApp extends StatelessWidget {
  const RecRecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Recommendator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:  Color.fromARGB(255, 4, 24, 33)),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
