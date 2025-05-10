import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_modele.dart';
import '../views/business/account_pending_view.dart';
import '../views/customer/HomePage.dart';
import '../views/business/BusinessHomeView.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? emailError;
  String? passwordError;
  String? generalError;

  void clearErrors() {
    emailError = null;
    passwordError = null;
    generalError = null;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    clearErrors();

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

      final utilisateur = UtilisateurModele.fromMap(doc.id, doc.data()!);

      switch (utilisateur.typeUtilisateur) {
        case "Client":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(idUtilisateur: userId),
            ),
          );
          break;
        case "Commerce":
          final commerceDoc = await FirebaseFirestore.instance
              .collection("Commerce")
              .doc(userId)
              .get();

          if (!commerceDoc.exists) {
            generalError = "Informations commerçant introuvables.";
            notifyListeners();
            return;
          }

          final etatCompte = commerceDoc.data()?['etatCompteCommercant'];
          if (etatCompte == "Verified") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BusinessHomeView(idUtilisateur: userId),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AccountPendingView(),
              ),
            );

          }
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

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
