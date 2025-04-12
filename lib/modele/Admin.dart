import 'package:cloud_firestore/cloud_firestore.dart';
import 'Utilisateur.dart';

class Administrateur extends Utilisateur {
  static int dernierId = 0;

  int idAdmin;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Administrateur(
      super.nom,
      super.prenom,
      super.email,
      super.motDePasse,
      super.typeUtilisateur,
      this.idAdmin)
      ; 

  // Méthode statique pour générer un nouvel ID unique
  static int genererNouvelId() {
    dernierId += 1;
    return dernierId;
  }

  // Fonction d'inscription pour l'administrateur
  Future<bool> inscriptionAdmin() async {
    try {
      // Ajouter un nouvel administrateur dans Firestore
      await _firestore.collection('Utilisateur').add({
        'id': idAdmin,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': motDePasse,
        'typeUtilisateur': typeUtilisateur, 
      });

      print("Inscription admin réussie avec id: $idAdmin");
      return true;
    } catch (e) {
      print("Erreur lors de l'inscription de l'admin : $e");
      return false;
    }
  }
}
