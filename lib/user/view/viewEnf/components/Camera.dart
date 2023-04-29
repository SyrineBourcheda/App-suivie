/*import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  StreamController<List<Face>> _facesController = StreamController<List<Face>>();

  Future<void> start() async {
    // Initialisation de Firebase
    await Firebase.initializeApp();
    final storage = FirebaseStorage.instance;

    // Initialisation de la caméra
    _cameras = await availableCameras();
    final camera = _cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium);
    await _controller.initialize();

    // Démarrage de la détection de visages en continu
    _controller.startImageStream((CameraImage image) {
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromBytes(image.planes[0].bytes, buildMetaData(image));
      final faceDetector = FirebaseVision.instance.faceDetector();
      faceDetector.processImage(visionImage).then((faces) {
        _facesController.add(faces);
        for (var i = 0; i < faces.length; i++) {
          // Stockage d'image dans Firebase
          final File imageFile = File('$i.jpg');
          imageFile.writeAsBytes(image.planes[0].bytes);
          final reference = storage.ref().child('images/${DateTime.now()}.jpg');
          reference.putFile(imageFile);
        }
      });
    });
  }

  // Retourne les métadonnées d'une image de la caméra
  FirebaseVisionImageMetadata buildMetaData(CameraImage image) {
    return FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        planeData: image.planes
            .map((Plane plane) => FirebaseVisionImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width,
                ))
            .toList(),
        rotation: ImageRotation.rotation90);
  }

  Future<void> stop() async {
    // Arrêt de la détection de visages
    await _controller.stopImageStream();
    await _controller.dispose();
    await _facesController.close();
  }

  Stream<List<Face>> get faceStream => _facesController.stream;
}*/