import 'package:flutter/material.dart';
import 'package:rec_rec_app/model/recipe_class.dart';

class MyRecipeTile extends StatelessWidget {
  final UserRecipe userRecipe;
  final Function()? onTap;

  const MyRecipeTile({super.key, required this.userRecipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userRecipe.title,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Ingredients: ${userRecipe.ner.join(", ")}",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14)),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                // Recipe image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    userRecipe.imageUrl,
                    height: 120,
                    width: 120,
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
