import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/child.model.dart';

Future addChild(Child child) async {
  final docUser = FirebaseFirestore.instance.collection("Childs").doc();
  child.Id = docUser.id;
  await docUser.set(child.toJson());
}

Future<Child> getChildById(String? idd) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('Childs')
      .where('parentId', isEqualTo: idd)
      .get();

  List<Child> childs = [];

  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
    Child child = Child.fromJson(documentSnapshot.data());
    childs.add(child);
  }

  return childs[0];
}
