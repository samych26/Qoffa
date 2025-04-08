import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour se connecter avec Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Déclencher le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        return null;
      }

      // Obtenir les détails d'authentification du compte Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Créer un nouvel identifiant
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Se connecter à Firebase avec les identifiants Google
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Enregistrer/mettre à jour les informations de l'utilisateur dans Firestore
      await _saveUserToFirestore(userCredential.user);
      
      return userCredential;
    } catch (e) {
      print('Erreur de connexion Google: $e');
      return null;
    }
  }

  // Enregistrer les informations de l'utilisateur dans Firestore
  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) return;
    
    // Référence à la collection 'users'
    final userRef = _firestore.collection('users').doc(user.uid);
    
    // Vérifier si l'utilisateur existe déjà
    final docSnapshot = await userRef.get();
    
    if (docSnapshot.exists) {
      // Mettre à jour la dernière connexion
      await userRef.update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      // Créer un nouveau document utilisateur
      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'phoneNumber': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'userType': 'customer', // Vous pouvez ajuster selon vos besoins
      });
    }
  }
}