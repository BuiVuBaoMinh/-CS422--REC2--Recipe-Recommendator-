import 'package:flutter/material.dart';
import 'package:rec_rec_app/pages/camera_page/camera_page.dart';
import 'package:rec_rec_app/main.dart' show firstCamera;

class ScanButton extends StatelessWidget {
  const ScanButton({
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
