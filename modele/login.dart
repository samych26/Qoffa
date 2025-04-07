import 'package:cloud_firestore/cloud_firestore.dart';

class login {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variable statique pour stocker l'ID en mémoire
  static int dernierId = 0; 

  // Méthode pour générer un nouvel ID
  static int genererNouvelId() {
    return dernierId + 1;
  }

  Future<Map<String, dynamic>> authentifier(String email, String motDePasse) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Utilisateur')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        print("Aucun utilisateur trouvé avec cet email.");
        return {'estValide': false, 'typeUtilisateur': ''};
      }
//recuperer les infos de l'utilisateur
      var userData = snapshot.docs.first.data() as Map<String, dynamic>;
      String mdpStocke = userData['motDePasse'];

      if (motDePasse == mdpStocke) {
        String typeUtilisateur = userData['typeUtilisateur'];
        print("Connexion réussie !");
        return {'estValide': true, 'typeUtilisateur': typeUtilisateur};
      } else {
        print("Mot de passe incorrect.");
        return {'estValide': false, 'typeUtilisateur': ''};
      }
    } catch (e) {
      print("Erreur lors de la connexion : $e");
      return {'estValide': false, 'typeUtilisateur': ''};
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
      print("Erreur lors de la vérification de l'email : $e");
      throw Exception("Impossible de vérifier l'email.");
    }
  }

  // Inscription consommateur
  Future<bool> inscriptionConsommateur({
    required String nom,
    required String prenom,
    required String email,
    required String numTel,
    required String motDePasse,
    required String adresse,
  }) async {
    try {
      if (await emailExiste(email)) {
        print("Un utilisateur avec cet email existe déjà.");
        return false;
      }

      int nouvelId = genererNouvelId(); 

      await _firestore.collection('Utilisateur').add({
        'id': nouvelId,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'numTel': numTel,
        'motDePasse': motDePasse,
        'adresseClient': adresse,
        'typeUtilisateur': 'consommateur',
      });

      print("Inscription consommateur réussie avec id: $nouvelId");
      return true;
    } catch (e) {
      print("Erreur lors de l'inscription : $e");
      return false;
    }
  }

  // Inscription admin
  Future<bool> inscriptionAdmin({
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
  }) async {
    try {
      if (await emailExiste(email)) {
        print("Un utilisateur avec cet email existe déjà.");
        return false;
      }

      int nouvelId = genererNouvelId();

      await _firestore.collection('Utilisateur').add({
        'id': nouvelId,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': motDePasse,
        'typeUtilisateur': 'admin',
      });

      print("Inscription admin réussie avec id: $nouvelId");
      return true;
    } catch (e) {
      print("Erreur lors de l'inscription de l'admin : $e");
      return false;
    }
  }

  // Inscription vendeur
  Future<bool> inscriptionVendeur({
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String idCommerce,
    required String nomCommerce,
    required String adresseCommerce,
    required String numTelCommerce,
    required String horaires,
    required String description,
    required String numRegistreCommercant,
  }) async {
    try {
      if (await emailExiste(email)) {
        print("Un utilisateur avec cet email existe déjà.");
        return false;
      }

      int nouvelId = genererNouvelId(); 

      await _firestore.collection('Utilisateur').add({
        'id': nouvelId,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': motDePasse,
        'typeUtilisateur': 'vendeur',
        'idCommerce': idCommerce,
        'nomCommerce': nomCommerce,
        'adresseCommerce': adresseCommerce,
        'numTelCommerce': numTelCommerce,
        'horaires': horaires,
        'description': description,
        'numRegistreCommercant': numRegistreCommercant,
      });

      print("Inscription vendeur réussie avec id: $nouvelId");
      return true;
    } catch (e) {
      print("Erreur lors de l'inscription du vendeur : $e");
      return false;
    }
  }
}
