import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EnfantApp extends StatefulWidget {
  @override
  _EnfantAppState createState() => _EnfantAppState();
  final String? idEnfant;
  EnfantApp({required this.idEnfant});
}

class _EnfantAppState extends State<EnfantApp> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                size: 48.0,
                color: Colors.red,
              ),
              onPressed: _toggleRecording,
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
