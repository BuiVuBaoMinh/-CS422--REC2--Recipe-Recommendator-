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
              title: docSnapshot.get("title").toString(),
              ingredients: convertFieldToList(docSnapshot.get("ingredients")),
              directions: convertFieldToList(docSnapshot.get("directions")),
              ner: nerFieldList));
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

  // Update

  // Delete
}

List<String> convertFieldToList(dynamic field) {
  final fieldString = field.toString(); // Removes brackets at 2 ends
  return fieldString.substring(1, fieldString.length).split(', '); // get items by spliting
}
