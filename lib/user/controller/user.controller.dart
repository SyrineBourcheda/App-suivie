import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addUser(User_app user) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final docUser=FirebaseFirestore.instance.collection("Users").doc();
  user.Id=docUser.id;
  await docUser.set(user.toJson());
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.PassWord,
    );
    } catch (error) {
    print(error);
  }
  
}


String? getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    // L'utilisateur n'est pas connecté
    return null;
  }
}




// ...
