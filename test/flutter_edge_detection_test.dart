// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_edge_detection/flutter_edge_detection.dart';
// import 'package:flutter_edge_detection/flutter_edge_detection_platform_interface.dart';
// import 'package:flutter_edge_detection/flutter_edge_detection_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterEdgeDetectionPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterEdgeDetectionPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final FlutterEdgeDetectionPlatform initialPlatform = FlutterEdgeDetectionPlatform.instance;

//   test('$MethodChannelFlutterEdgeDetection is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterEdgeDetection>());
//   });

//   test('getPlatformVersion', () async {
//     FlutterEdgeDetection flutterEdgeDetectionPlugin = FlutterEdgeDetection();
//     MockFlutterEdgeDetectionPlatform fakePlatform = MockFlutterEdgeDetectionPlatform();
//     FlutterEdgeDetectionPlatform.instance = fakePlatform;

//     expect(await flutterEdgeDetectionPlugin.getPlatformVersion(), '42');
//   });
// }
