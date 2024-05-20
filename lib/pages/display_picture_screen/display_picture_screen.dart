import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:rec_rec_app/main.dart' show model;
import 'package:rec_rec_app/model/recipe_class.dart';
import 'package:rec_rec_app/pages/homepage/edit_recipe_page.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  UserRecipe? userRecipe;

  Future<void> submitPrompt() async {
    final ingredientsImage = await File(widget.imagePath).readAsBytes();
    final imagePart = DataPart('image/jpeg', ingredientsImage);

    // print("file submitted $imagePath");

    final prompt = TextPart("""
    Recommend a recipe based on the provided image.
    The recipe only contains real, edible ingredients.
    Return the recipe as an object of the class below.
    Only return the Recipe, do not rewrite the class definition.
    If there is no edible object, return null.

    class Recipe {
      String title;
      List<String> ingredients; // The ingredients and amount
      List<String> directions; // Just the step without step count
      List<String> ner; // Ingredients but without amount, brand and such
    }

    Return in a Map<String, values> JSON format and only in English.
    """);

    // print("getting recipe from model");
    final response = await model.generateContent([
      Content.multi([prompt, imagePart])
    ]);

    // print(response.text);
    final rawData = response.text!.substring(8, response.text!.length - 3);
    // print(rawData);
    Map<String, dynamic> data = jsonDecode(rawData);
    // print(data["title"]);
    // print(data["ingredients"]);
    // print(data["directions"]);
    // print(data["ner"]);

    setState(() {
      userRecipe = UserRecipe(
          data["title"],
          data["ingredients"].cast<String>(),
          data["directions"].cast<String>(),
          data["ner"].cast<String>(),
          "",
          "",
          "");
    });
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditRecipePage(
                  userRecipe: userRecipe,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(widget.imagePath)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          submitPrompt();
        },
        child: const Icon(IconData(0xf05d, fontFamily: 'MaterialIcons')),
      ),
    );
  }
}
