import 'package:flutter/material.dart';
import 'package:rec_rec_app/pages/camera_page/camera_page.dart';
import 'package:rec_rec_app/main.dart' show firstCamera;

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

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
        width: 210,
        height: 140,
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
                'assets/scan_btn_bg.jpg',
                fit: BoxFit.fill,
              ),
              Center(
                  child: Icon(
                Icons.camera_alt_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
