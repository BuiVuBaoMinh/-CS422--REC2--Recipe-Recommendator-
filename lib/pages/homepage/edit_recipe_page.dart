import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/model/recipe_class.dart';
import 'package:rec_rec_app/pages/components/my_button.dart';
import 'package:rec_rec_app/services/firestore.dart';

class EditRecipePage extends StatefulWidget {
  final UserRecipe? userRecipe;
  final String? docID;

  const EditRecipePage({super.key, this.userRecipe, this.docID});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  // text controller
  final titleController = TextEditingController();

  late List<String> ingredients = widget.userRecipe?.ingredients ?? [];
  final ingredientController = TextEditingController();

  late List<String> directions = widget.userRecipe?.directions ?? [];
  final directionController = TextEditingController();

  late List<String> ner = widget.userRecipe?.ner ?? [];
  final nerController = TextEditingController();

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    if (pickedFile != null) {
      final String path;
      if (widget.userRecipe != null) {
        path = "images/${widget.userRecipe!.imageName}";
      } else {
        path = "images/${pickedFile!.name}";
      }
      final File file = File(pickedFile!.path!);

      final FirestoreService firestoreService = FirestoreService();
      firestoreService.storageRef.child(path).putFile(file);
    }

    UserRecipe newUserRecipe;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // recipe content
      Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // recipe image
              // if we have user recipe
              widget.userRecipe != null
                  ? Image.network(widget.userRecipe!.imageUrl)

                  // or a file is selected
                  : pickedFile != null
                      ? Image.file(
                          File(pickedFile!.path!),
                          fit: BoxFit.cover,
                        )

                      // default image
                      : Image.network(
                          "https://th.bing.com/th/id/OIP.yyAPXYtG6gF1US5fxoJc4gHaFO?rs=1&pid=ImgDetMain"),

              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // recipe title
                    Text(
                      widget.userRecipe != null
                          ? widget.userRecipe!.title
                          : "Recipe title",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),

                    // recipe ingredients
                    const Text(
                      "Ingredients: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          return Text("\t+ ${ingredients[index]}",
                              style: const TextStyle(fontSize: 18));
                        }),

                    const SizedBox(
                      height: 25,
                    ),

                    // recipe directions
                    const Text(
                      "Directions: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: directions.length,
                        itemBuilder: (context, index) {
                          return Text("\t+ ${directions[index]}",
                              style: const TextStyle(fontSize: 18));
                        }),

                    const SizedBox(
                      height: 25,
                    ),

                    // recipe ner
                    const Text(
                      "NER: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ner.length,
                        itemBuilder: (context, index) {
                          return Text(
                            "\t+ ${ner[index]}",
                            style: const TextStyle(fontSize: 18),
                          );
                        }),
                  ],
                ),
              ),

              MyButton(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditRecipePage()));
                  },
                  text:
                      widget.userRecipe != null ? "Update" : "Add new recipe"),
            ],
          ),
        ),
      ),

      // back button
      SafeArea(
        child: Opacity(
          opacity: 0.6,
          child: Container(
            margin: const EdgeInsets.only(left: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    ]);
  }
}
