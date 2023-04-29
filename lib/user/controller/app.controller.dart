import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/App.model.dart';

Future addApp(App app) async {
  final docUser = FirebaseFirestore.instance.collection("App").doc();
  app.id = docUser.id;
  await docUser.set(app.toJson());
}
