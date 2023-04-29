/*import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late String _filePath;

  Future<void> _startRecording() async {
    // Demander la permission d'enregistrement audio
    if (await Permission.microphone.request().isGranted) {
      String tempPath = (await getTemporaryDirectory()).path;
      _filePath = '$tempPath/recording.mp3';
      await _recorder.openRecorder();
      await _recorder.startRecorder(toFile: _filePath);
    } else {
      // La permission d'enregistrement audio a été refusée
      // Faire quelque chose ici, comme afficher un message d'erreur
      print('Permission to access microphone denied');
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recording Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startRecording,
          child: Text('Start Recording'),
        ),
      ),
    );
  }
}*/

/*import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class EnfantPageE extends StatefulWidget {
  @override
  _EnfantPageEState createState() => _EnfantPageEState();
}

class _EnfantPageEState extends State<EnfantPageE> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late String _recordingPath;
  Future<bool> _requestMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.microphone.request();
    }
    return permission == PermissionStatus.granted;
  }

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    String appDocPath = (await getApplicationDocumentsDirectory()).path;
    //_recordingPath = '$appDocPath/recording.mp3';
    //await _recorder.openRecorder();
    await _recorder.startRecorder(toFile: _recordingPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enfant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Enregistrer'),
              onPressed: () async {
                //await _recorder.stopRecorder();
                //await uploadFile(_recordingPath);
                await _recorder.openAudioSession();
                await _recorder.startRecorder(toFile: _recordingPath);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadFile(String path) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String uuid = Uuid().v4();
    File file = File(path);
    if (await file.exists()) {
      Reference ref = storage.ref().child('enregistrements/$uuid.mp3');
      await ref.putFile(file);
    } else {
      print('File does not exist at path: $path');
    }
  }

  @override
  void dispose() {
    _recorder.stopRecorder();
    _recorder.closeAudioSession();
    super.dispose();
  }
}*/

/*fonctionnelle
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderPage extends StatefulWidget {
  @override
  _AudioRecorderPageState createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<AudioRecorderPage> {
  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  String _recordingPath = "jnjde";
  bool _isRecording = false;
  bool _hasRecordPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      setState(() {
        _hasRecordPermission = true;
      });
    } else {
      if (await Permission.microphone.request().isGranted) {
        setState(() {
          _hasRecordPermission = true;
        });
      }
    }
  }

  Future<void> _startRecording() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String recordingName =
        'recording_${DateTime.now().millisecondsSinceEpoch}.pcm';
    _recordingPath = '${appDirectory.path}/$recordingName';

    try {
      await _audioRecorder.openAudioSession(
        focus: AudioFocus.requestFocusAndDuckOthers,
        category: SessionCategory.record,
      );
      await _audioRecorder.startRecorder(
        toFile: _recordingPath,
        codec: Codec.pcm16,
      );
    } catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _audioRecorder.stopRecorder();
    await _audioRecorder.closeAudioSession();
    if (mounted) {
      setState(() {
        _isRecording = false;
      });
    }

    // Read audio data from file
    final file = File(_recordingPath);
    List<int> audioBytes = await file.readAsBytes();

    // Upload audio data to Firebase Storage
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('enregistrements')
        .child('recording_${DateTime.now().millisecondsSinceEpoch}.mp3');
    Uint8List audioData = Uint8List.fromList(audioBytes);
    UploadTask uploadTask = storageRef.putData(audioData);
    await uploadTask;
  }

  Future<void> _playRecording() async {
    AudioPlayer _audioPlayer = AudioPlayer();
    String url =
        await _recordingPath; // Récupération du fichier à partir du réseau
    await _audioPlayer.setUrl(url);
    await _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enregistreur audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_hasRecordPermission)
              Text('La permission d\'enregistrement n\'a pas été accordée.'),
            if (_isRecording) Text('Enregistrement en cours...'),
            if (_recordingPath != null)
              ElevatedButton(
                child: Text('Jouer l\'enregistrement'),
                onPressed: _playRecording,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
        onPressed: () {
          if (!_hasRecordPermission) {
            return;
          }

          setState(() {
            _isRecording = !_isRecording;
          });

          if (_isRecording) {
            _startRecording();
          } else {
            _stopRecording();
          }
        },
      ),
    );
  }
}
*/
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
