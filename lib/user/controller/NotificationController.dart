
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/Notification.model.dart';

Future addNotification(notifications notif) async {
  final docUser=FirebaseFirestore.instance.collection("Notification").doc();
  notif.idNotif=docUser.id;
  await docUser.set(notif.toJson());
}