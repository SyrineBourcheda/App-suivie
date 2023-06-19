import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addUser(User_app user) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.PassWord,
    );

    // Récupérer le UID de l'utilisateur
    String uid = userCredential.user!.uid;

    // Enregistrer le UID de l'utilisateur dans l'objet User_app
    user.Id = uid;

    // Enregistrer les données de l'utilisateur dans Firestore
    await _firestore.collection("Users").doc(user.Id).set(user.toJson());
  } catch (error) {
    print(error);
  }
}
/*Future addUser(User_app user) async {
  final docUser = FirebaseFirestore.instance.collection("Users").doc();
  user.Id = docUser.id;
  await docUser.set(user.toJson());
}*/

String? getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    // L'utilisateur n'est pas connecté
    return null;
  }
}

Future<void> deleteUser(String userId) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.uid == userId) {
      // delete the user from Firebase Authentication
      await user.delete();
    }
    await FirebaseFirestore.instance.collection('Users').doc(userId).delete();

    print('Utilisateur supprimé avec succès.');
  } catch (e) {
    print('Erreur lors de la suppression de l\'utilisateur : $e');
  }
}

Future<String?> getNomUser(String? ParentId) async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(ParentId).get();

  if (documentSnapshot.exists) {
    Map<String, dynamic> parentData =
        documentSnapshot.data() as Map<String, dynamic>;
    String name = parentData['FullName'];
    return name;
  } else {
    return null;
  }
}

Future<String?> getEmailUser(String? ParentId) async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(ParentId).get();

  if (documentSnapshot.exists) {
    Map<String, dynamic> parentData =
        documentSnapshot.data() as Map<String, dynamic>;
    String email = parentData['email'];
    return email;
  } else {
    return null;
  }
}
