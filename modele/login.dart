import 'package:firebase_auth/firebase_auth.dart';

class ModeleConnexion {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Authentifier l'utilisateur avec Firebase Authentication
  Future<bool> authentifier(String identifiant, String motDePasse) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: identifiant,
        password: motDePasse,
      );
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Aucun utilisateur trouvé pour cet email.');
      } else if (e.code == 'wrong-password') {
        print('Mot de passe incorrect.');
      } else {
        print("Erreur Firebase: ${e.message}");
      }
      return false;
    } catch (e) {
      print("Erreur inconnue: $e");
      return false;
    }
  }

  // Déconnecter l'utilisateur
  Future<void> deconnecter() async {
    await _auth.signOut();
  }
}
