/*import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EnfantPage extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _envoyerNotificationSOS() async {
    await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.sendMessage(
      to: "fiKFfw02RL-dOiChQkMNJC:APA91bGFVPWylfvmk_HK7Hay7CCx2ypqp2PLLmdFP6ncsavjCBNPYTvKivAuWyjJeSz0FBZIvTx2xoWGMQyUhZxlqZWCyK-leRXuZFQHuawAmFmONu5ysCdlyDGtSMZQCCk_LRVdhQFh",
      data: {
        "type": "sos",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Application enfant"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("SOS"),
          onPressed: () {
            _envoyerNotificationSOS();
          },
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class EnfantPage extends StatefulWidget {
  @override
  _EnfantPageState createState() => _EnfantPageState();
}

class _EnfantPageState extends State<EnfantPage> {
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    setState(() {
      _storagePermissionStatus = status;
    });
  }

  void _jouerSonSOS() async {
    final url = 'http://192.168.1.156:3000/sos';
    await http.get(Uri.parse(url));
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/sos.mp3'));
    print("tfghbjk");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Application enfant"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("SOS"),
          onPressed: () {
            _jouerSonSOS();
          },
        ),
      ),
    );
  }
}
