import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/recipe_class.dart';

class FirestoreService {
  // get collections
  final CollectionReference recipes =
      FirebaseFirestore.instance.collection("recipes");

  // Create
  Future<void> addRecipe(Recipe recipe) {
    return recipes.add({
      "title": recipe.title,
      "ingredients": recipe.ingredients,
      "directions": recipe.directions,
      "NER": recipe.ner,
    });
  }

  // Read

  // Update

  // Delete
}
