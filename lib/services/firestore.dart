import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/recipe_class.dart';

class FirestoreService {
  // get collections
  // for firestore (data)
  final CollectionReference recipes =
      FirebaseFirestore.instance.collection("recipes");
  final CollectionReference userRecipes =
      FirebaseFirestore.instance.collection("userRecipes");

  // for fire cloud storage (image)
  final storageRef = FirebaseStorage.instance.ref();

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
      "imageName": userRecipe.imageName,
      "imageUrl": userRecipe.imageUrl,
    });
  }

  // Read
  Future<List<Recipe>> getRecipesFromIngredients(List<String> ingredients) async {
    late Query query = recipes;
    late List<Recipe> result = [];
    
    query = query.where("NER", arrayContains: ingredients[0]);

    final matchedRecipes = await query.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          bool allIngredientsFound = true;
          final nerFieldString = docSnapshot.get("NER").toString();
          final nerFieldList = nerFieldString.substring(1, nerFieldString.length-1).split(', ');
          for (var i = 1; i < ingredients.length; i++) {
            if (!nerFieldList.contains(ingredients[i])) {
              allIngredientsFound = false;
              break;
            }
          }
          if (allIngredientsFound) {
            // print('${docSnapshot.id} => NER: $nerFieldList');
            result.add(Recipe(
              docSnapshot.get("title").toString(),
              convertFieldToList(docSnapshot.get("ingredients")),
              convertFieldToList(docSnapshot.get("directions")),
              nerFieldList));
          }
        }
      }
    );
    print("got ${result.length}");
    for (var recipe in result) {
      print(recipe.directions);
    }
    return result;
  }

  Stream<QuerySnapshot> getUserRecipesStream(String userEmail) {
    final recipesStream =
        userRecipes.where("email", isEqualTo: userEmail).snapshots();

    return recipesStream;
  }

  // Update

  // Delete
}

List<String> convertFieldToList(dynamic field) {
  final fieldString = field.toString(); // Removes brackets at 2 ends
  return fieldString.substring(1, fieldString.length).split(', '); // get items by spliting
}
