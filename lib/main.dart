import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      routes: {
        '/home': (context) => MyHomePage(),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ARKitController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ARKitSceneView(
          showFeaturePoints: true,
          enableTapRecognizer: true,
          planeDetection: ARPlaneDetection.horizontalAndVertical,
          onARKitViewCreated: (ARKitController controller) {
            this.controller = controller;
            controller.onARTap = (hit) {
              final point = hit.firstWhere(
                  (hit) => hit.type == ARKitHitTestResultType.featurePoint);
              if (point != null) {
                _onArtapHandler(point);
              }
            };
          },
        ));
  }

  void _onArtapHandler(ARKitTestResult point) {
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );
    final node = _getNodeFromFlutterAssets(position);
    controller.add(node);
  }

  ARKitGltfNode _getNodeFromFlutterAssets(vector.Vector3 position) {
    return ARKitGltfNode(
        assetType: AssetType.flutterAsset,
        url: 'assets/3d_weird_bubble.gltf',
        scale: vector.Vector3.all(0.5),
        position: position);
  }
}
