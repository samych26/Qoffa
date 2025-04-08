import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Connexion avec Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Déclencher le flux de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      // Obtenir les détails d'authentification de la requête
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Créer un nouvel identifiant
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion à Firebase avec les identifiants Google
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);

      // Sauvegarder les informations utilisateur dans Firestore
      await _saveUserToFirestore(userCredential.user!);

      return userCredential;
    } catch (e) {
      print('Erreur de connexion Google: $e');
      rethrow;
    }
  }

  // Sauvegarder les données utilisateur dans Firestore
  Future<void> _saveUserToFirestore(User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      
      // Vérifier si l'utilisateur existe déjà
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        // Créer un nouveau document utilisateur s'il n'existe pas
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'userType': 'customer', // ou 'business' selon votre logique
        });
      } else {
        // Mettre à jour la dernière connexion
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
        });
      }
    } catch (e) {
      print('Erreur lors de la sauvegarde dans Firestore: $e');
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  // Vérifier si l'utilisateur est connecté
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  // Obtenir l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}