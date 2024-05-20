// import 'dart:math';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:rec_rec_app/pages/display_picture_screen/display_picture_screen.dart';

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
    _controller = CameraController(widget.camera, ResolutionPreset.ultraHigh,
        enableAudio: false);

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
    // Must wait for the controller to finish initializing
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Future is complete, display preview
          // return CameraPreview(_controller);
          final mediaSize = MediaQuery.of(context).size;
          final scale =
              1 / (_controller.value.aspectRatio * mediaSize.aspectRatio);

          return SafeArea(
              child: Stack(children: [
            ClipRect(
              clipper: _MediaSizeClipper(mediaSize),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: CameraPreview(_controller),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;

                        final image = await _controller.takePicture();

                        if (!context.mounted) return;

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DisplayPictureScreen(imagePath: image.path),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Icon(Icons.camera_alt)),
              ),
            ),
          ]));
        } else {
          // Else display loading indicator
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}