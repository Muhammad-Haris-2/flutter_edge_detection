// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_edge_detection_example/image_screen.dart';

import 'edge_detection_shape/edge_detection_shape.dart';

class CroppingScreen extends StatefulWidget {
  const CroppingScreen({super.key, required this.imagePath, required this.edgeDetectionResult});

  final String imagePath;
  final EdgeDetectionResult edgeDetectionResult;

  @override
  State<CroppingScreen> createState() => _CroppingScreenState();
}

class _CroppingScreenState extends State<CroppingScreen> {
  GlobalKey imageWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3341),
      appBar: AppBar(
        title: const Text("Crop Image"),
        backgroundColor: const Color(0xFF24272E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.file(
              File(widget.imagePath),
              fit: BoxFit.contain,
              key: imageWidgetKey,
            ),
            FutureBuilder(
              future: _loadUiImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final keyContext = imageWidgetKey.currentContext;
                final box = keyContext!.findRenderObject() as RenderBox;

                return EdgeDetectionShape(
                  originalImageSize: Size(snapshot.data!.width.toDouble(), snapshot.data!.height.toDouble()),
                  renderedImageSize: Size(box.size.width, box.size.height),
                  edgeDetectionResult: widget.edgeDetectionResult,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        height: 70,
        decoration: const BoxDecoration(color: Color(0xFF24272E)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.rotate_90_degrees_ccw), color: Colors.white),
            IconButton(onPressed: () {}, icon: Transform(transform: Matrix4.rotationX(0), child: const Icon(Icons.rotate_90_degrees_cw_outlined)), color: Colors.white),
            GestureDetector(
              onTap: _processImage,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.green),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ui.Image> _loadUiImage() async {
    final Uint8List data = await File(widget.imagePath).readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image image) {
      return completer.complete(image);
    });
    return completer.future;
  }

  void _processImage() async {
    if (!mounted) return;

    bool result = await EdgeDetector().processImage(widget.imagePath, widget.edgeDetectionResult, 0);

    if (!result) return;

    imageCache.clearLiveImages();
    imageCache.clear();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(imagePath: widget.imagePath),
      ),
    );
  }
}
