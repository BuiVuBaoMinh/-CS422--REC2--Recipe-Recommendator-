import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rec_rec_app/pages/camera_page/camera_page.dart';
import 'package:rec_rec_app/pages/user_profile.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'random_recipes.dart';
import 'package:rec_rec_app/main.dart' show firstCamera;
import 'package:rec_rec_app/services/firestore.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final FirestoreService firestoreService = FirestoreService();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome, ${user.email!}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 20.0),
                      ),
                      Row(
                        children: [
                          IconButton( // History button
                            onPressed: () {
                              firestoreService.getRecipesFromIngredients(['beef', 'garlic']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ParallaxRecipe()),
                              );
                            },
                            icon: const Icon(
                              IconData(0xee2d, fontFamily: 'MaterialIcons'),
                              size: 30.0,
                            ),
                          ),
                          IconButton( // User button
                            onPressed: () {
                              print('user');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserProfile()),
                              );
                            },
                            icon: const Icon(
                              IconData(0xe491, fontFamily: 'MaterialIcons'),
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            HomePageScanButton(assetPath: 'assets/scan_btn_bg.jpg'),
            HomePagePickImageButton(assetPath: 'assets/pick_image_btn_bg.jpg'),
          ],
        ),
      ),
    );
  }
}

class HomePageScanButton extends StatelessWidget {
  const HomePageScanButton({
    super.key,
    required this.assetPath,
    });

  final String assetPath;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScanIngredientsPage(
                          camera: firstCamera,
                        )
                ),
              );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: AspectRatio(
          aspectRatio: 1.5 / 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                Image.asset(assetPath, fit: BoxFit.cover),
                Center(
                    child: Icon(
                  const IconData(0xf60b, fontFamily: 'MaterialIcons'),
                  size: 100,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePagePickImageButton extends HomePageScanButton {
  HomePagePickImageButton({required super.assetPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final image = await _pickImageFromGallery();
        if (image != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                      imagePath: image.path,
                    )
            ),
          );
        }
        
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: AspectRatio(
          aspectRatio: 1.5 / 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                Image.asset(assetPath, fit: BoxFit.cover),
                Center(
                    child: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 100,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future _pickImageFromGallery() async {
  final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  return returnedImage;
}