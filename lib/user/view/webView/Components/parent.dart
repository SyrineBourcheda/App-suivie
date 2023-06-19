import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ParentPage extends StatefulWidget {
  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
    _demarrerServeur();
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    setState(() {
      _storagePermissionStatus = status;
    });
  }

  void _demarrerServeur() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
    print('Serveur démarré sur le port ${server.port}');

    await for (final request in server) {
      if (request.uri.path == '/sos') {
        print("notif");
        _jouerSonSOS();
        print("son joué");
      }
    }
  }

  void _jouerSonSOS() async {
    final player = AudioPlayer();
    print("hello");
    await player.play(AssetSource('sounds/sos.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Application parent"),
      ),
      body: Center(
        child: Text("En attente de SOS..."),
      ),
    );
  }
}
