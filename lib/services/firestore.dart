import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/recipe_class.dart';

class FirestoreService {
  // get collections
  final CollectionReference recipes =
      FirebaseFirestore.instance.collection("recipes");
  final CollectionReference userRecipes =
      FirebaseFirestore.instance.collection("userRecipes");

  // Query
  Future<void> getUserRecipes(String userEmail) {
    return userRecipes.where("email", isEqualTo: userEmail).get();
  }

  // Create
  Future<void> addRecipe(Recipe recipe) {
    return recipes.add({
      "title": recipe.title,
      "ingredients": recipe.ingredients,
      "directions": recipe.directions,
      "NER": recipe.ner,
    });
  }

  Future<void> addUserRecipe(UserRecipe userRecipe) {
    return userRecipes.add({
      "title": userRecipe.title,
      "ingredients": userRecipe.ingredients,
      "directions": userRecipe.directions,
      "NER": userRecipe.ner,
      "email": userRecipe.userEmail,
      "imageUrl": userRecipe.imageUrl,
    });
  }

  // Read
  Stream<QuerySnapshot> getUserRecipesStream(String userEmail) {
    final recipesStream =
        userRecipes.where("email", isEqualTo: userEmail).snapshots();

    return recipesStream;
  }

  // Update

  // Delete
}
