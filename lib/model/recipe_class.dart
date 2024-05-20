class Recipe {
  String title;
  List<String> ingredients;
  List<String> directions;
  List<String> ner;

  // Recipe(this.title, this.ingredients, this.directions, this.ner);

  Recipe({
    required this.title,
    required this.ingredients,
    required this.directions,
    required this.ner,
  });
}
