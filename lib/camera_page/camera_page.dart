import 'dart:math';
import 'dart:io';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScanIngredientsPage extends StatefulWidget {

  final CameraDescription camera;
  
  const ScanIngredientsPage({
    super.key,
    required this.camera,
  });
  
  @override
  State<StatefulWidget> createState() {
    return ScanIngredientsPageState();
  }
}

class ScanIngredientsPageState extends State<ScanIngredientsPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Controller needed to display current output of Camera
    // --> create one
    _controller = CameraController(
      widget.camera, 
      ResolutionPreset.medium,);

    // Initialize the controller.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose the controller along with its widget
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan your ingredients!'),),
        body:
          // Must wait for the controller to finish initializing
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Future is complete, display preview
                return CameraPreview(_controller);
              } else {
                // Else display loading indicator
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButton: FloatingActionButton (
            onPressed: () async {
              try {
                await _initializeControllerFuture;

                final image = await _controller.takePicture();

                if (!context.mounted) return;

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(imagePath: image.path),
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),),
      )
    );
  }
}


// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

