import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/firebase_options.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:rec_rec_app/pages/login_pages/auth_page.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


late CameraDescription firstCamera;

late GenerativeModel model;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras.first;

  // Set up Gemini API
  // Access your API key as an environment variable (see "Set up your API key" above)
  final apiKey = String.fromEnvironment('API_KEY');
  if (apiKey == null) {
    print('No environment variable');
    exit(1);
  }
  else {
    print(apiKey);
  }

  model = await GenerativeModel(model: 'gemini-pro-vision', apiKey: 'AIzaSyCF14Ra_sT9pqMHPFtrHrymrB8k3k5AZUE');

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
      home: const AuthPage(),
    );
  }
}
