import 'dart:io';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  GlobalKey imageWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3341),
      appBar: AppBar(
        title: const Text("Filter Image"),
        backgroundColor: const Color(0xFF24272E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Image.file(File(widget.imagePath), fit: BoxFit.contain)),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        height: 70,
        decoration: const BoxDecoration(color: Color(0xFF24272E)),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
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
}
