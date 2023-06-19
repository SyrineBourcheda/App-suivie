import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/help.model.dart';

Future addHelpMessage(Help_Message message) async {
  final docUser = FirebaseFirestore.instance.collection("Help_Messages").doc();
  message.Id = docUser.id;
  await docUser.set(message.toJson());
}
