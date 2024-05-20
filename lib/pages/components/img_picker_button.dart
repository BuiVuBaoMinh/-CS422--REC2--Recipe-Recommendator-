import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/pages/camera_page/camera_page.dart';
import 'scan_button.dart';
import 'package:rec_rec_app/pages/display_picture_screen/display_picture_screen.dart';


class PickImageButton extends ScanButton {
  const PickImageButton({super.key, required super.assetPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final image = await _pickImageFromGallery();
        if (image != null) {
          await Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                      imagePath: image.path,
                    )),
          );
        }
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
                fit: BoxFit.cover,
              ),
              Center(
                  child: Icon(
                Icons.add_photo_alternate_outlined,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

Future _pickImageFromGallery() async {
  final returnedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  return returnedImage;
}
