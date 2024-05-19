import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/model/recipe_class.dart';
import 'package:rec_rec_app/pages/components/my_recipe_tile.dart';
import 'package:rec_rec_app/pages/components/my_silver_app_bar.dart';
import 'package:rec_rec_app/pages/components/scan_button.dart';
import 'package:rec_rec_app/pages/homepage/recipe_page.dart';
import 'package:rec_rec_app/pages/my_drawer.dart';
import 'package:rec_rec_app/services/firestore.dart';
// import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final FirestoreService firestoreService = FirestoreService();
  // List<UserRecipe> userRecipe;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MyDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrollled) => [
            const MySilverAppBar(
                title: Text(
                  "Your recipes",
                  style: TextStyle(fontSize: 20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ScanButton(),
                  ],
                )),
          ],
          body: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getUserRecipesStream(user.email!),
            builder: (context, snapshot) {
              // if we have data, get all the docs
              if (snapshot.hasData) {
                List recipesList = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: recipesList.length,
                  itemBuilder: (context, index) {
                    // get doc id
                    DocumentSnapshot document = recipesList[index];
                    String docID = document.id;

                    // get recipe from each doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    UserRecipe userRecipe = UserRecipe(
                        data["title"],
                        data["ingredients"].cast<String>(),
                        data["directions"].cast<String>(),
                        data["NER"].cast<String>(),
                        data["email"],
                        data["imageUrl"]);

                    return MyRecipeTile(
                      userRecipe: userRecipe,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipePage(
                                    userRecipe: userRecipe,
                                    docID: docID,
                                  ))),
                    );
                  },
                );
              } else {
                return const Text("There is no data");
              }
            },
          ),
        ),
      ),
    );
  }
}
