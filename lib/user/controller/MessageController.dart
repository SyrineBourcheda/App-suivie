


import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/message.model.dart';

Future addMessage(Message message) async {
  final docUser=FirebaseFirestore.instance.collection("Messages").doc();
  message.idMessage=docUser.id;
  await docUser.set(message.toJson());
}
final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('Messages');
 void markAllAsSeen(String otherUsername) async {
    await messageCollection
        .where('sender', isEqualTo: otherUsername)
        .where('isSeen', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'isSeen': true});
      });
    });
  }