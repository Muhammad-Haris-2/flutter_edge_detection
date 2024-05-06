import 'package:flutter/material.dart';

import 'camera_screen.dart';

void main() {
  runApp(const EdgeDetectionApp());
}

class EdgeDetectionApp extends StatelessWidget {
  const EdgeDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const CameraScreen(),
    );
  }
}
