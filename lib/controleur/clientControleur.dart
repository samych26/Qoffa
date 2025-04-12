import 'package:cloud_firestore/cloud_firestore.dart';
import '../modele/Client.dart';

class ClientControleur {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Nouvelle méthode pour valider les champs et retourner une map d'erreurs
  Map<String, String?> validerChamps({
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String confirmationMotDePasse,
    required String numTelClient,
  }) {
    Map<String, String?> erreurs = {};

    if (nom.isEmpty) {
      erreurs['nom'] = "Le nom est requis.";
    }

    if (prenom.isEmpty) {
      erreurs['prenom'] = "Le prénom est requis.";
    }

    if (email.trim().isEmpty) {
      erreurs['email'] = "L'email est requis.";
    } else if (!_estEmailValide(email)) {
      erreurs['email'] = "Email invalide.";
    }

    if (motDePasse.isEmpty) {
      erreurs['motDePasse'] = "Le mot de passe est requis.";
    } else if (motDePasse.length < 5) {
      erreurs['motDePasse'] = "Le mot de passe doit contenir au moins 5 caractères.";
    }

    if (confirmationMotDePasse != motDePasse) {
      erreurs['confirmationMotDePasse'] = "Les mots de passe ne correspondent pas.";
    }

    if (numTelClient.isEmpty) {
      erreurs['numTelClient'] = "Le numéro de téléphone est requis.";
    } else if (!_estTelephoneValide(numTelClient)) {
      erreurs['numTelClient'] = "Numéro de téléphone invalide. Il doit commencer par 0 et contenir 10 chiffres.";
    }

    return erreurs;
  }

  bool _estEmailValide(String email) {
    RegExp emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegExp.hasMatch(email);
  }

  bool _estTelephoneValide(String numTel) {
    RegExp phoneRegExp = RegExp(r"^0[0-9]{9}$");
    return phoneRegExp.hasMatch(numTel);
  }

  // Inscription du client après validation
  Future<String> inscrireClient({
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String confirmationMotDePasse,
    required String adresseClient,
    required String numTelClient,
  }) async {
    try {
      Map<String, String?> erreurs = validerChamps(
        nom: nom,
        prenom: prenom,
        email: email,
        motDePasse: motDePasse,
        confirmationMotDePasse: confirmationMotDePasse,
        numTelClient: numTelClient,
      );

      if (erreurs.isNotEmpty) {
        return "Champs invalides"; // On peut aussi remonter la map d'erreurs si besoin
      }

      if (await emailExiste(email)) {
        return "Un compte avec cet email existe déjà.";
      }

      Client nouveauClient = Client(
        nom,
        prenom,
        email,
        motDePasse,
        'client',
        adresseClient,
        numTelClient,
        0,
        0,
        0,
        true,
      );

      bool inscriptionReussie = await nouveauClient.inscriptionClient();
      return inscriptionReussie ? "ok" : "Échec de l'inscription.";
    } catch (e) {
      return "Erreur interne lors de l'inscription : $e";
    }
  }

  Future<bool> emailExiste(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Utilisateur')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
