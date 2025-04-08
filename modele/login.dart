// lib/modele/login.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ModeleConnexion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Authentification avec email et mot de passe
  Future<Map<String, dynamic>> authentifier(
      String email, String motDePasse) async {
    try {
      // Vérifier le format de l'email
      if (!_estEmailValide(email)) {
        return {
          'succes': false,
          'message': 'Format d\'email invalide',
        };
      }

      // Vérifier la longueur du mot de passe
      if (motDePasse.length < 6) {
        return {
          'succes': false,
          'message': 'Le mot de passe doit contenir au moins 6 caractères',
        };
      }

      // Tentative de connexion
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: motDePasse,
      );

      if (userCredential.user != null) {
        // Mettre à jour les informations de connexion dans Firestore
        await _mettreAJourDerniereConnexion(userCredential.user!.uid);

        return {
          'succes': true,
          'utilisateur': userCredential.user,
          'message': 'Connexion réussie',
        };
      }

      return {
        'succes': false,
        'message': 'Erreur de connexion',
      };
    } on FirebaseAuthException catch (e) {
      return _gererErreurFirebase(e);
    } catch (e) {
      return {
        'succes': false,
        'message': 'Une erreur inattendue est survenue',
      };
    }
  }

  // Connexion avec Google
  Future<Map<String, dynamic>> authentifierAvecGoogle() async {
    try {
      // Déclencher le flux de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {
          'succes': false,
          'message': 'Connexion Google annulée',
        };
      }

      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion à Firebase avec les identifiants Google
      final userCredential = await _auth.signInWithCredential(credential);

      // Sauvegarder/Mettre à jour les informations utilisateur dans Firestore
      await _sauvegarderUtilisateurGoogle(userCredential.user!);

      return {
        'succes': true,
        'utilisateur': userCredential.user,
        'message': 'Connexion Google réussie',
      };
    } on FirebaseAuthException catch (e) {
      return _gererErreurFirebase(e);
    } catch (e) {
      return {
        'succes': false,
        'message': 'Erreur lors de la connexion avec Google',
      };
    }
  }

  // Déconnexion
  Future<Map<String, dynamic>> deconnecter() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);

      return {
        'succes': true,
        'message': 'Déconnexion réussie',
      };
    } catch (e) {
      return {
        'succes': false,
        'message': 'Erreur lors de la déconnexion',
      };
    }
  }

  // Vérifier si l'utilisateur est connecté
  bool estConnecte() {
    return _auth.currentUser != null;
  }

  // Obtenir l'utilisateur actuel
  User? obtenirUtilisateurActuel() {
    return _auth.currentUser;
  }

  // Mettre à jour la dernière connexion dans Firestore
  Future<void> _mettreAJourDerniereConnexion(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'derniere_connexion': FieldValue.serverTimestamp(),
        'derniere_mise_a_jour': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erreur lors de la mise à jour de la dernière connexion: $e');
    }
  }

  // Sauvegarder les informations de l'utilisateur Google
  Future<void> _sauvegarderUtilisateurGoogle(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'nom': user.displayName,
        'photo_url': user.photoURL,
        'provider': 'google',
        'derniere_connexion': FieldValue.serverTimestamp(),
        'date_creation': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erreur lors de la sauvegarde des données utilisateur: $e');
    }
  }

  // Vérifier le format de l'email
  bool _estEmailValide(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Gérer les erreurs Firebase
  Map<String, dynamic> _gererErreurFirebase(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'Aucun utilisateur trouvé avec cet email';
        break;
      case 'wrong-password':
        message = 'Mot de passe incorrect';
        break;
      case 'invalid-email':
        message = 'Format d\'email invalide';
        break;
      case 'user-disabled':
        message = 'Ce compte a été désactivé';
        break;
      case 'too-many-requests':
        message = 'Trop de tentatives. Veuillez réessayer plus tard';
        break;
      case 'operation-not-allowed':
        message = 'La connexion avec email/mot de passe n\'est pas activée';
        break;
      case 'email-already-in-use':
        message = 'Cet email est déjà utilisé par un autre compte';
        break;
      case 'weak-password':
        message = 'Le mot de passe est trop faible';
        break;
      case 'network-request-failed':
        message = 'Erreur de connexion réseau';
        break;
      default:
        message = 'Une erreur est survenue: ${e.message}';
    }

    return {
      'succes': false,
      'message': message,
      'code': e.code,
    };
  }

  // Réinitialiser le mot de passe
  Future<Map<String, dynamic>> reinitialiserMotDePasse(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'succes': true,
        'message': 'Email de réinitialisation envoyé',
      };
    } on FirebaseAuthException catch (e) {
      return _gererErreurFirebase(e);
    } catch (e) {
      return {
        'succes': false,
        'message': 'Erreur lors de la réinitialisation du mot de passe',
      };
    }
  }

  // Vérifier l'état de l'email
  Future<Map<String, dynamic>> verifierEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return {
          'succes': true,
          'message': 'Email de vérification envoyé',
        };
      }
      return {
        'succes': false,
        'message': 'Impossible d\'envoyer l\'email de vérification',
      };
    } catch (e) {
      return {
        'succes': false,
        'message': 'Erreur lors de l\'envoi de l\'email de vérification',
      };
    }
  }

  // Mettre à jour le profil utilisateur
  Future<Map<String, dynamic>> mettreAJourProfil({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateProfile(
          displayName: displayName,
          photoURL: photoURL,
        );

        // Mettre à jour Firestore
        await _firestore.collection('users').doc(user.uid).update({
          if (displayName != null) 'nom': displayName,
          if (photoURL != null) 'photo_url': photoURL,
          'derniere_mise_a_jour': FieldValue.serverTimestamp(),
        });

        return {
          'succes': true,
          'message': 'Profil mis à jour avec succès',
        };
      }
      return {
        'succes': false,
        'message': 'Utilisateur non connecté',
      };
    } catch (e) {
      return {
        'succes': false,
        'message': 'Erreur lors de la mise à jour du profil',
      };
    }
  }
}
