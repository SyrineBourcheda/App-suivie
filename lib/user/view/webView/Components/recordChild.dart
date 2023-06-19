import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EnfantApp extends StatefulWidget {
  // Propriétés de l'enfant (à définir)
  final String idEnfant;
  final String nomEnfant;

  EnfantApp({required this.idEnfant, required this.nomEnfant});

  @override
  _EnfantAppState createState() => _EnfantAppState();
}

class _EnfantAppState extends State<EnfantApp> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
  }

  Future<void> _startRecording() async {
    try {
      await _recorder?.openAudioSession();
      await _recorder?.startRecorder(
          toFile: 'enfant_${widget.idEnfant}_recording');
      setState(() {
        _isRecording = true;
      });
    } catch (err) {
      print('Erreur lors du démarrage de l\'enregistrement: $err');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? recordingPath = await _recorder?.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      if (recordingPath != null) {
        // Envoyer l'enregistrement à Firebase Storage
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            //.child('enfant_${widget.idEnfant}')
            .child('enregistrement_${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask = storageRef.putFile(File(recordingPath));
        await uploadTask;

        // Enregistrer l'URL de l'enregistrement dans Firebase Realtime Database
        final DatabaseReference dbRef = FirebaseDatabase.instance
            .reference()
            .child('enfants')
            //.child(widget.idEnfant)
            .child('enregistrements');
        final String downloadURL = await storageRef.getDownloadURL();
        await dbRef.push().set({'url': downloadURL});
      }
    } catch (err) {
      print('Erreur lors de l\'arrêt de l\'enregistrement: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enfant: ${widget.nomEnfant}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isRecording
                ? ElevatedButton(
                    onPressed: _stopRecording,
                    child: Text('Arrêter enregistrement'),
                  )
                : ElevatedButton(
                    onPressed: _startRecording,
                    child: Text('Démarrer enregistrement'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _recorder?.closeAudioSession();
    super.dispose();
  }
}
