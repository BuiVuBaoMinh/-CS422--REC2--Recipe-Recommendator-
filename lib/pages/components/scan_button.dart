import 'package:flutter/material.dart';
import 'package:rec_rec_app/pages/camera_page/camera_page.dart';
import 'package:rec_rec_app/main.dart' show firstCamera;

class ScanButton extends StatelessWidget {
  final String assetPath;

  const ScanButton({
    super.key,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanIngredientsPage(
                    camera: firstCamera,
                  )),
        );
      },
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.asset(
                assetPath,
                fit: BoxFit.fill,
              ),
              Center(
                  child: Icon(
                Icons.camera_alt_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
