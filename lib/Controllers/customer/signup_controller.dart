import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? emailError;
  String? passwordError;
  String? nomError;
  String? prenomError;
  String? phoneError;
  String? generalError;
  String? successMessage;

  void clearErrors() {
    emailError = null;
    passwordError = null;
    nomError = null;
    prenomError = null;
    phoneError = null;
    generalError = null;
    successMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    generalError = null;
    successMessage = null;
    notifyListeners();
  }

  bool _validateFields({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String phone,
  }) {
    clearErrors();
    bool isValid = true;

    if (nom.isEmpty) {
      nomError = 'Le nom est requis';
      isValid = false;
    }

    if (prenom.isEmpty) {
      prenomError = 'Le prénom est requis';
      isValid = false;
    }

    if (email.isEmpty) {
      emailError = 'L\'email est requis';
      isValid = false;
    } else if (!email.endsWith('@gmail.com')) {
      emailError = 'Utilisez une adresse @gmail.com';
      isValid = false;
    }

    if (password.length < 6) {
      passwordError = 'Mot de passe trop court (min 6 caractères)';
      isValid = false;
    }

    if (phone.isEmpty) {
      phoneError = 'Le numéro de téléphone est requis';
      isValid = false;
    } else if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      phoneError = 'Numéro invalide (10 chiffres requis)';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> registerClient({
    required BuildContext context,
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (!_validateFields(nom: nom, prenom: prenom, email: email, password: password, phone: phone)) {
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        generalError = "Erreur lors de la création du compte.";
        notifyListeners();
        return;
      }

      await _firestore.collection('Utilisateur').doc(uid).set({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': password,
        'typeUtilisateur': 'Client',
        'photoDeProfile': '',
      });

      await _firestore.collection('Client').doc(uid).set({
        'idClient': uid,
        'adresseClient': '',
        'numTelClient': phone,
        'cptCommandeEnCours': 0,
        'cptAnnulation': 0,
        'cptAchats': 0,
        'etatCompteClient': 'actif',
      });

      successMessage = 'Compte créé avec succès !';
      notifyListeners();

      // Efface le message après 3 secondes
      Future.delayed(const Duration(seconds: 3), () {
        successMessage = null;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emailError = 'Cet email est déjà utilisé.';
      } else {
        generalError = e.message ?? 'Erreur inconnue.';
      }
      notifyListeners();
    } catch (e) {
      generalError = 'Erreur: $e';
      notifyListeners();
    }
  }
}
