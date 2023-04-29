


import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/message.model.dart';

Future addMessage(Message message) async {
  final docUser=FirebaseFirestore.instance.collection("Messages").doc();
  message.idMessage=docUser.id;
  await docUser.set(message.toJson());
}
