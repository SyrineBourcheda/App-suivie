import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> signOut() async {
   FirebaseFirestore.instance
      .collection('Users')
      .doc(_auth.currentUser!.uid)
      .update({'isLoggedIn': false});
  await _auth.signOut();
 
}