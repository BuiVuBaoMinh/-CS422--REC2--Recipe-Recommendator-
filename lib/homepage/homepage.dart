import 'package:flutter/material.dart';
import 'package:rec_rec_app/camera_page/camera_page.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'random_recipes.dart';
import 'package:rec_rec_app/main.dart' show firstCamera;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                        'Welcome, User',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 20.0),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
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
                          IconButton(
                            onPressed: () {
                              print('user');
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
            HomePageScanButton(),
          ],
        ),
      ),
    );
  }
}

class HomePageScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ScanIngredientsPage(
              camera: firstCamera,)
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
                        Image.asset('assets/scan_btn_bg.jpg', fit: BoxFit.cover),
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
