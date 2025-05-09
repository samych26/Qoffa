import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>?> fetchUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('Utilisateur').doc(uid).get();
    return doc.data();
  }

  static Future<void> updateUserData({
    required String phone,
    required String email,
    required String address,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('Utilisateur').doc(uid).update({
      'numTelClient': phone,
      'email': email,
      'adresseClient': address,
    });
  }
}
