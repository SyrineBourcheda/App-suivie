/*import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';

class ListeningScreen extends StatefulWidget {
  final String filePath;

  ListeningScreen({required this.filePath});

  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  FlutterSoundPlayer _player = FlutterSoundPlayer();

  Future<void> _startPlaying() async {
    await _player.startPlayer(
      fromURI: widget.filePath, // utilise un argument nommé
    );
  }

  Future<void> _stopPlaying() async {
    await _player.stopPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startPlaying,
          child: Text('Start Listening'),
        ),
      ),
    );
  }
}
*/
/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

class ParentPageE extends StatefulWidget {
  @override
  _ParentPageEState createState() => _ParentPageEState();
}

class _ParentPageEState extends State<ParentPageE> {
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Écouter'),
              onPressed: () async {
                String url =
                    await downloadFile(); // Récupération du fichier à partir du réseau
                await _audioPlayer.setUrl(url);
                await _audioPlayer.play();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> downloadFile() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('enregistrements/mon-enfant');
    String url = await ref.getDownloadURL();
    return url;
  }
}
*/
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class ParentApp extends StatefulWidget {
  // Propriétés du parent (à définir)
  final String idParent;
  final String nomParent;
  final String idEnfant;

  ParentApp(
      {required this.idParent,
      required this.nomParent,
      required this.idEnfant});

  @override
  _ParentAppState createState() => _ParentAppState();
}

class _ParentAppState extends State<ParentApp> {
  List<String> _enregistrements = [];

  @override
  void initState() {
    super.initState();

    // Récupérer les enregistrements de l'enfant en temps réel depuis Firebase Realtime Database
    final DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child('enfants')
        .child(widget.idEnfant)
        .child('enregistrements');
    dbRef.onChildAdded.listen((event) {
      final Object? downloadURL = event.snapshot.child('url').value;

      setState(() {
        if (downloadURL != null) {
          _enregistrements.add(downloadURL as String);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parent: ${widget.nomParent}')),
      body: Center(
        child: ListView.builder(
          itemCount: _enregistrements.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Enregistrement ${index + 1}'),
              onTap: () {
                // Lire l'enregistrement à partir de Firebase Storage
                final Reference storageRef = FirebaseStorage.instance
                    .ref()
                    .child(_enregistrements[index]);
                storageRef.getDownloadURL().then((url) {
                  AudioPlayer().setSourceUrl(url);
                  AudioPlayer().play(UrlSource(url));
                });
              },
            );
          },
        ),
      ),
    );
  }
}
