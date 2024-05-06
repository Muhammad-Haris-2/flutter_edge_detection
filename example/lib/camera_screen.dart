// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'cropping_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;

  bool _isPickLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3341),
      appBar: AppBar(
        title: const Text("Click Image"),
        backgroundColor: const Color(0xFF24272E),
        foregroundColor: Colors.white,
      ),
      body: cameraController != null
          ? Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(cameraController!),
                ),
                if (_isPickLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black38,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Please wait for a while",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 15),
                        CupertinoActivityIndicator(color: Colors.white, radius: 18),
                      ],
                    ),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Color(0xFF24272E)),
        child: Row(
          children: [
            const Spacer(),
            Expanded(
              child: GestureDetector(
                onTap: onTakePictureButtonPressed,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.white),
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: _onGalleryButtonPressed,
                icon: const Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
                color: Colors.white,
                iconSize: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _initializeController() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras.first, ResolutionPreset.ultraHigh, enableAudio: false);
    await cameraController?.initialize();
    if (!mounted) return;
    setState(() {});
  }

  void onTakePictureButtonPressed() async {
    if (_isPickLoading) return null;
    setState(() => _isPickLoading = true);

    final filePath = await takePicture();

    if (filePath == null) {
      setState(() => _isPickLoading = false);
      return;
    }

    log('Picture saved to $filePath');

    final result = await _detectEdges(filePath);

    if (result == null) {
      setState(() => _isPickLoading = false);
      return;
    }

    setState(() => _isPickLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CroppingScreen(
          edgeDetectionResult: result,
          imagePath: filePath,
        ),
      ),
    );
  }

  void _onGalleryButtonPressed() async {
    if (_isPickLoading) return null;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final filePath = pickedFile.path;

    log('Picture saved to $filePath');

    final result = await _detectEdges(filePath);

    if (result == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CroppingScreen(
          edgeDetectionResult: result,
          imagePath: filePath,
        ),
      ),
    );
  }

  Future<String?> takePicture() async {
    try {
      if (cameraController == null) return null;
      if (!cameraController!.value.isInitialized) return null;
      if (cameraController!.value.isTakingPicture) return null;

      final image = await cameraController!.takePicture();

      return image.path;
    } on CameraException catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<EdgeDetectionResult?> _detectEdges(String filePath) async {
    if (!mounted) return null;

    final EdgeDetectionResult result = await EdgeDetector().detectEdges(filePath);

    return result;
  }
}
