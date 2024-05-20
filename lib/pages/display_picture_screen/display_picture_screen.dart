import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:rec_rec_app/main.dart' show model;

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed submit");
          print("file $imagePath");
          submitPrompt(imagePath);
        },
        child: const Icon(IconData(0xf05d, fontFamily: 'MaterialIcons')),
      ),
    );
  }
}

void submitPrompt(String imagePath) async {
  final ingredientsImage = await File(imagePath).readAsBytes();
  final imagePart = DataPart('image/jpeg', ingredientsImage);

  print("file submitted $imagePath");

  final prompt = TextPart("""
    Recommend a recipe based on the provided image.
    The recipe only contains real, edible ingredients.
    Return the recipe as an object of the class below.
    Only return the Recipe, do not rewrite the class definition.

    class Recipe {
      String title;
      List<String> ingredients; // The ingredients and amount
      List<String> directions;
      List<String> ner; // Ingredients but without amount, brand and such
    }

    Return in a Map<String, values> JSON format.
    """);

  print("getting recipe from model");
  final response = await model.generateContent([
    Content.multi([prompt, imagePart])
  ]);

  print(response.text);
}
