import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/firebase_options.dart';

import 'package:camera/camera.dart';

import 'homepage/homepage.dart';

late CameraDescription firstCamera;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras.first;

  runApp(const RecRecApp());
}

class RecRecApp extends StatelessWidget {
  const RecRecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Recommender',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 4, 24, 33)),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
