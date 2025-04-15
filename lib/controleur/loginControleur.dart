import 'package:flutter/material.dart';
import '../modele/loginModel.dart'; // Assure-toi d’avoir ce fichier

class LoginControleur {
  final String identifiant;
  final String motDePasse;

  bool estValide = false;
  String typeUtilisateur = '';
  String? messageErreur;

  LoginControleur({
    required this.identifiant,
    required this.motDePasse,
  });

  // Expression régulière pour valider l'email
  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  Future<void> verifierConnexion() async {
    // Vérifie que les champs ne sont pas vides
    if (identifiant.isEmpty || motDePasse.isEmpty) {
      messageErreur = "Veuillez remplir tous les champs.";
      return;
    }

    // Vérifie le format de l’email
    if (!_emailRegex.hasMatch(identifiant)) {
      messageErreur = "Adresse email invalide.";
      return;
    }

    // Appelle le modèle pour l’authentification
    final result = await LoginModel.authentifier(identifiant, motDePasse);

    estValide = result['estValide'];
    typeUtilisateur = result['typeUtilisateur'];
    messageErreur = result['message'] ?? null;
  }
}
