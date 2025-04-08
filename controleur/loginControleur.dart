// lib/controleur/loginControleur.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../modele/login.dart';

class ControleurLogin {
  // Instance du modèle de connexion
  final ModeleConnexion _modele = ModeleConnexion();

  // Variables pour gérer l'état
  bool enChargement = false;
  String? messageErreur;
  User? utilisateurActuel;

  // Méthode pour la connexion avec email et mot de passe
  Future<bool> verifierConnexion(String email, String motDePasse) async {
    try {
      // Indiquer que le chargement commence
      enChargement = true;
      messageErreur = null;

      // Vérifier si les champs sont vides
      if (email.isEmpty || motDePasse.isEmpty) {
        messageErreur = 'Veuillez remplir tous les champs';
        return false;
      }

      // Appeler la méthode d'authentification du modèle
      final resultat = await _modele.authentifier(email, motDePasse);

      // Traiter le résultat
      if (resultat['succes']) {
        utilisateurActuel = resultat['utilisateur'];
        return true;
      } else {
        messageErreur = resultat['message'];
        return false;
      }

    } catch (e) {
      // Gérer les erreurs inattendues
      messageErreur = 'Une erreur inattendue est survenue';
      return false;
    } finally {
      // Toujours indiquer que le chargement est terminé
      enChargement = false;
    }
  }

  // Méthode pour la connexion avec Google
  Future<bool> connexionGoogle() async {
    try {
      enChargement = true;
      messageErreur = null;

      // Appeler la méthode d'authentification Google du modèle
      final resultat = await _modele.authentifierAvecGoogle();

      if (resultat['succes']) {
        utilisateurActuel = resultat['utilisateur'];
        return true;
      } else {
        messageErreur = resultat['message'];
        return false;
      }

    } catch (e) {
      messageErreur = 'Erreur lors de la connexion avec Google';
      return false;
    } finally {
      enChargement = false;
    }
  }

  // Méthode pour la déconnexion
  Future<bool> deconnecter() async {
    try {
      enChargement = true;
      messageErreur = null;

      // Appeler la méthode de déconnexion du modèle
      final resultat = await _modele.deconnecter();

      if (resultat['succes']) {
        utilisateurActuel = null;
        return true;
      } else {
        messageErreur = resultat['message'];
        return false;
      }

    } catch (e) {
      messageErreur = 'Erreur lors de la déconnexion';
      return false;
    } finally {
      enChargement = false;
    }
  }

  // Méthode pour réinitialiser le mot de passe
  Future<bool> reinitialiserMotDePasse(String email) async {
    try {
      enChargement = true;
      messageErreur = null;

      // Vérifier si l'email est vide
      if (email.isEmpty) {
        messageErreur = 'Veuillez entrer votre email';
        return false;
      }

      // Appeler la méthode de réinitialisation du modèle
      final resultat = await _modele.reinitialiserMotDePasse(email);

      if (resultat['succes']) {
        messageErreur = 'Email de réinitialisation envoyé';
        return true;
      } else {
        messageErreur = resultat['message'];
        return false;
      }

    } catch (e) {
      messageErreur = 'Erreur lors de la réinitialisation du mot de passe';
      return false;
    } finally {
      enChargement = false;
    }
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  bool estConnecte() {
    return _modele.estConnecte();
  }

  // Méthode pour obtenir l'utilisateur actuel
  User? obtenirUtilisateur() {
    return _modele.obtenirUtilisateurActuel();
  }

  // Méthode pour mettre à jour le profil utilisateur
  Future<bool> mettreAJourProfil({String? nom, String? photoURL}) async {
    try {
      enChargement = true;
      messageErreur = null;

      final resultat = await _modele.mettreAJourProfil(
        displayName: nom,
        photoURL: photoURL,
      );

      if (resultat['succes']) {
        messageErreur = 'Profil mis à jour avec succès';
        return true;
      } else {
        messageErreur = resultat['message'];
        return false;
      }

    } catch (e) {
      messageErreur = 'Erreur lors de la mise à jour du profil';
      return false;
    } finally {
      enChargement = false;
    }
  }

  // Méthode pour vérifier l'email de l'utilisateur
  Future<bool> verifierEmail() async {
    try {
      enChargement = true;
      messageErreur = null;

      final resultat = await _modele.verifierEmail();

      if (resultat['succes']) {
        messageErreur = 'Email de vérification envoyé';
        return true;
      } else {
        messageErreur = resultat['message'];
        return false;
      }

    } catch (e) {
      messageErreur = 'Erreur lors de l\'envoi de l\'email de vérification';
      return false;
    } finally {
      enChargement = false;
    }
  }

  // Méthode pour obtenir l'état de chargement
  bool estEnChargement() {
    return enChargement;
  }

  // Méthode pour obtenir le dernier message d'erreur
  String? obtenirMessageErreur() {
    return messageErreur;
  }

  // Méthode pour réinitialiser les erreurs
  void reinitialiserErreurs() {
    messageErreur = null;
  }
}