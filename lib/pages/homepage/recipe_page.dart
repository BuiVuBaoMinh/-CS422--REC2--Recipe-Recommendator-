import 'package:flutter/material.dart';
import 'package:rec_rec_app/model/recipe_class.dart';
import 'package:rec_rec_app/pages/components/my_button.dart';
import 'package:rec_rec_app/pages/homepage/edit_recipe_page.dart';

class RecipePage extends StatefulWidget {
  final UserRecipe userRecipe;
  final String docID;

  const RecipePage({super.key, required this.userRecipe, required this.docID});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // recipe content
      Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // recipe image
              widget.userRecipe.imageUrl != ""
                  ? Image.network(widget.userRecipe.imageUrl)
                  : Image.network(
                      "https://th.bing.com/th/id/R.e47325df69964a48a7baad4bf45664e5?rik=rHZDtvLbqg6KZg&pid=ImgRaw&r=0"),

              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // recipe title
                    Text(
                      widget.userRecipe.title,
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
                        itemCount: widget.userRecipe.ingredients.length,
                        itemBuilder: (context, index) {
                          return Text(
                              "\t+ ${widget.userRecipe.ingredients[index]}",
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
                        itemCount: widget.userRecipe.directions.length,
                        itemBuilder: (context, index) {
                          return Text(
                              "\t+ ${widget.userRecipe.directions[index]}",
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
                        itemCount: widget.userRecipe.ner.length,
                        itemBuilder: (context, index) {
                          return Text(
                            "\t+ ${widget.userRecipe.ner[index]}",
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
                            builder: (context) => EditRecipePage(
                                  userRecipe: widget.userRecipe,
                                  docID: widget.docID,
                                )));
                  },
                  text: "Edit"),
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
