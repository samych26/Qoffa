import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      // Authentification Firebase
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupération depuis Firestore
      final uid = userCred.user!.uid;
      final doc =
      await _firestore.collection('Utilisateur').doc(uid).get();

      if (!doc.exists) throw Exception("Utilisateur introuvable.");

      return UserModel.fromMap(uid, doc.data()!);
    } catch (e) {
      throw Exception("Erreur de connexion : ${e.toString()}");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
