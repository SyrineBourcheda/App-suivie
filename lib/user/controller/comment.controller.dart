import 'package:app_geo/user/view/webView/adminView/Comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/Comment.model.dart';

Future addComment(Comment comment) async {
  final docUser = FirebaseFirestore.instance.collection("Comments").doc();
  comment.Id = docUser.id;
  await docUser.set(comment.toJson());
}

void updateComment(String Id) {
  FirebaseFirestore.instance
      .collection('Comments')
      .doc(Id)
      .update({'isPublished': true});
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<Map<String, String>>> getPublishedComments() async {
  List<Map<String, String>> comments = [];
  QuerySnapshot querySnapshot = await _firestore
      .collection('Comments')
      .where('isPublished', isEqualTo: true)
      .limit(3)
      .get();
  querySnapshot.docs.forEach((doc) {
    comments.add({
      'name': doc['Name'],
      'message': doc['message'],
    });
  });
  return comments;
}
