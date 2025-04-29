import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔴 Gestion des erreurs
  String? emailError;
  String? passwordError;
  String? generalError;

  // 🧹 Réinitialiser les erreurs
  void clearErrors() {
    emailError = null;
    passwordError = null;
    generalError = null;
    notifyListeners();
  }

  // 🔐 Connexion avec validation et redirection selon le type
  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    clearErrors();

    // ✅ Validation locale simple
    if (email.isEmpty) {
      emailError = "L'email est requis";
    } else if (!email.contains('@')) {
      emailError = "Format d'email invalide";
    }

    if (password.isEmpty) {
      passwordError = "Le mot de passe est requis";
    } else if (password.length < 6) {
      passwordError = "Mot de passe trop court (min 6 caractères)";
    }

    if (emailError != null || passwordError != null) {
      notifyListeners();
      return;
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user?.uid;
      if (userId == null) {
        generalError = "Utilisateur introuvable.";
        notifyListeners();
        return;
      }

      final doc = await FirebaseFirestore.instance.collection("Utilisateur").doc(userId).get();
      if (!doc.exists) {
        generalError = "Utilisateur introuvable dans la base de données.";
        notifyListeners();
        return;
      }

      final data = doc.data()!;
      final type = data['typeUtilisateur'];

      switch (type) {
        case "Client":
          Navigator.pushReplacementNamed(context, "/client_home");
          break;
        case "Commerçant":
          Navigator.pushReplacementNamed(context, "/business_home");
          break;
        case "Administrateur":
          Navigator.pushReplacementNamed(context, "/admin_home");
          break;
        default:
          generalError = "Type d'utilisateur inconnu.";
          notifyListeners();
      }

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          emailError = "Email invalide";
          break;
        case 'user-not-found':
          emailError = "Aucun utilisateur trouvé avec cet email";
          break;
        case 'wrong-password':
          passwordError = "Mot de passe incorrect";
          break;
        default:
          generalError = e.message ?? "Erreur inconnue";
      }
      notifyListeners();
    } catch (e) {
      generalError = "Erreur : ${e.toString()}";
      notifyListeners();
    }
  }

  // 📝 Création de compte
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("SignUp Error: $e");
      return null;
    }
  }

  // 🔓 Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // 🔍 Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // 📡 Flux d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
