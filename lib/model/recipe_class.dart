class Recipe {
  String title;
  List<String> ingredients;
  List<String> directions;
  List<String> ner;

  // Recipe(this.title, this.ingredients, this.directions, this.ner);

  Recipe(
    this.title,
    this.ingredients,
    this.directions,
    this.ner,
  );
}

class UserRecipe extends Recipe {
  String userEmail;
  String imageName;
  String imageUrl;

  UserRecipe(
    super.title,
    super.ingredients,
    super.directions,
    super.ner,
    this.userEmail,
    this.imageName,
    this.imageUrl);
}
