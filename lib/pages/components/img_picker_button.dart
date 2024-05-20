import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/pages/camera_page/camera_page.dart';
import 'scan_button.dart';

class PickImageButton extends ScanButton {
  PickImageButton({required super.assetPath});

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