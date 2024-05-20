import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final controller = TextEditingController();

  late String title = widget.userRecipe?.title ?? "Recipe Title";

  late List<String> ingredients = widget.userRecipe?.ingredients ?? [];

  late List<String> directions = widget.userRecipe?.directions ?? [];

  late List<String> ner = widget.userRecipe?.ner ?? [];

  final user = FirebaseAuth.instance.currentUser!;
  late String imageName = widget.userRecipe?.imageName ?? "";
  late String imageUrl = widget.userRecipe?.imageUrl ?? "";

  final FirestoreService firestoreService = FirestoreService();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  UserRecipe? newUserRecipe;

  Future selectFile() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        final result = await FilePicker.platform.pickFiles();
        if (result == null) return;

        setState(() {
          pickedFile = result.files.first;
          imageName = pickedFile!.name;
        });
      } on PlatformException catch (e) {
        print("Error picking file: $e");
      }
    } else {
      print("Permission denied");
    }
  }

  Future uploadFile() async {
    if (pickedFile != null) {
      final String path;
      if (imageName != "") {
        path = "recipeImage/$imageName";
      } else {
        path = "recipeImage/${pickedFile!.name}";
      }
      final File file = File(pickedFile!.path!);

      uploadTask = firestoreService.storageRef.child(path).putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      final returnUrl = await snapshot.ref.getDownloadURL();

      if (mounted) {
        setState(() {
          imageUrl = returnUrl;
        });
      }
    }
    newUserRecipe = UserRecipe(
        title, ingredients, directions, ner, user.email!, imageName, imageUrl);
    if (widget.docID != null) {
      firestoreService.updateUserRecipe(widget.docID!, newUserRecipe!);
    } else {
      firestoreService.addUserRecipe(newUserRecipe!);
    }
    Navigator.pop(context);
  }

  Future<void> deleteUserRecipe() async {
    print("check");
    firestoreService.deleteUserRecipe(widget.docID!);
    final desertRef =
        firestoreService.storageRef.child("recipeImage/${imageName}");
    await desertRef.delete();
    Navigator.pop(context);
  }

  openRecipeConfigureBox(
      {required BuildContext context,
      required DialogField dialogType,
      int index = -1}) {
    String? heading;
    Function()? onPressed;

    if (dialogType == DialogField.title) {
      heading = "Recipe Title";
      onPressed = () {
        setState(() {
          title = controller.text;
        });
      };
    } else if (dialogType == DialogField.ingredients) {
      heading = "Ingredients";
      if (index != -1) {
        var nerLength = ner[index].length;
        var ingreLength = ingredients[index].length;
        controller.text =
            ingredients[index].substring(0, ingreLength - nerLength);
      }
      onPressed = () {
        setState(() {
          ingredients[index] = "${controller.text} ${ner[index]}";
        });
      };
    } else if (dialogType == DialogField.directions) {
      if (index != -1) {
        heading = "Step $index";

        controller.text = directions[index];
        onPressed = () {
          setState(() {
            directions[index] = controller.text;
          });
        };
      } else {
        heading = "Step ${(directions.length + 1)}";
        onPressed = () {
          setState(() {
            directions.add(controller.text);
          });
        };
      }
    } else if (dialogType == DialogField.ner) {
      if (index != -1) {
        heading = "Ingredient $index";

        controller.text = ner[index];
        onPressed = () {
          setState(() {
            directions[index] = controller.text;
          });
        };
      } else {
        heading = "Ingredient ${(ner.length + 1)}";
        onPressed = () {
          setState(() {
            ingredients.add(controller.text);
            ner.add(controller.text);
          });
        };
      }
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
            onPressed: () {
              controller.text = "";
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          // save button
          MaterialButton(
            onPressed: () {
              // Pop the dialog
              Navigator.pop(context);

              // Handle the data
              onPressed!();
              controller.text = "";
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  deleteElement({required DialogField dialogType, required int index}) {
    if (dialogType == DialogField.directions) {
      setState(() {
        directions.removeAt(index);
      });
    } else if (dialogType == DialogField.ner) {
      setState(() {
        ingredients.removeAt(index);
        ner.removeAt(index);
      });
    } else {}
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
              // ignore: unnecessary_null_comparison
              imageUrl != ""
                  ? Image.network(imageUrl)

                  // or a file is selected
                  : pickedFile != null
                      ? Image.file(
                          File(pickedFile!.path!),
                          fit: BoxFit.cover,
                        )

                      // default image
                      : Image.network(
                          "https://th.bing.com/th/id/OIP.yyAPXYtG6gF1US5fxoJc4gHaFO?rs=1&pid=ImgDetMain"),

              GestureDetector(
                onTap: selectFile,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 15, right: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "Select image",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                          title,
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("\t+ ${ingredients[index]}",
                                  style: const TextStyle(fontSize: 18)),
                            ),
                            IconButton(
                              onPressed: () {
                                openRecipeConfigureBox(
                                    context: context,
                                    dialogType: DialogField.ingredients,
                                    index: index);
                              },
                              icon: const Icon(Icons.settings),
                            )
                          ],
                        );
                      },
                    ),

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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  "\t${index + 1}. ${directions[index]}",
                                  style: const TextStyle(fontSize: 18)),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    openRecipeConfigureBox(
                                        context: context,
                                        dialogType: DialogField.directions,
                                        index: index);
                                  },
                                  icon: const Icon(Icons.settings),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteElement(
                                        dialogType: DialogField.directions,
                                        index: index);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "\t+ ${ner[index]}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    openRecipeConfigureBox(
                                        context: context,
                                        dialogType: DialogField.ner,
                                        index: index);
                                  },
                                  icon: const Icon(Icons.settings),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteElement(
                                        dialogType: DialogField.ner,
                                        index: index);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              MyButton(
                  onTap: () {
                    uploadFile();
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
            margin: const EdgeInsets.only(top: 25, left: 25),
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

      // delete button
      if (widget.docID != null)
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 25, right: 25),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteUserRecipe();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ]);
  }
}
