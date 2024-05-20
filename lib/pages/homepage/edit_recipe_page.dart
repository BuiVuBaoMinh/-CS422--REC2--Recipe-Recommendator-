import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/model/recipe_class.dart';
import 'package:rec_rec_app/pages/components/my_button.dart';
import 'package:rec_rec_app/pages/homepage/enum.dart';
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
  late String title = widget.userRecipe?.title ?? "Recipe Title";
  final titleController = TextEditingController();

  late List<String> ingredients = widget.userRecipe?.ingredients ?? [];
  final ingredientController = TextEditingController();

  late List<String> directions = widget.userRecipe?.directions ?? [];
  final directionController = TextEditingController();

  late List<String> ner = widget.userRecipe?.ner ?? [];
  final nerController = TextEditingController();

  late String imageUrl = widget.userRecipe?.imageUrl ?? "";

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

  openRecipeConfigureBox(
      {required BuildContext context,
      required DialogField dialogType,
      int index = 0}) {
    String? heading;
    Function()? onPressed;
    TextEditingController? controller;

    if (dialogType == DialogField.title) {
      heading = "Recipe Title";
      onPressed = () {
        setState(() {
          title = titleController.text;
        });
      };
      controller = titleController;
    } else if (dialogType == DialogField.ingredients) {
      heading = "Ingredients";
      onPressed = () {
        setState(() {
          ingredients[index] = "${ingredientController.text} ${ner[index]}";
        });
      };
      controller = ingredientController;
    } else if (dialogType == DialogField.directions) {
      heading = "Step ${(directions.length + 1)}";
      onPressed = () {
        setState(() {
          directions.add(directionController.text);
        });
      };
      controller = directionController;
    } else if (dialogType == DialogField.ner) {
      heading = "Ingredient ${(ner.length + 1)}";
      onPressed = () {
        setState(() {
          ingredients.add(nerController.text);
          ner.add(nerController.text);
        });
      };
      controller = nerController;
    } else {
      heading = "Error occur";
      onPressed = () {};
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(heading!),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "eggs or milk or beef"),
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // save button
          MaterialButton(
            onPressed: () {
              // Pop the dialog
              Navigator.pop(context);

              // Handle the data
              onPressed!();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () => openRecipeConfigureBox(
                              context: context, dialogType: DialogField.title),
                        )
                      ],
                    ),

                    // recipe ingredients
                    const Text(
                      "Ingredients (configure amount): ",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Directions: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => openRecipeConfigureBox(
                              context: context,
                              dialogType: DialogField.directions),
                        )
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Ingredients without amount: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => openRecipeConfigureBox(
                              context: context, dialogType: DialogField.ner),
                        )
                      ],
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
