import 'package:cloud_firestore/cloud_firestore.dart';
import 'Utilisateur.dart';

class Client extends Utilisateur {
  static int dernierId = 0; 
  
  int idClient;
  String adresseClient;
  String numTelClient;
  int cptCommandeEnCours;
  int cptAnnulation;
  int cptAchats;
  bool etatCompteClient; 

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Client(
    super.nom,
    super.prenom,
    super.email,
    super.motDePasse,
    super.typeUtilisateur,
    this.adresseClient,
    this.numTelClient,
    this.cptCommandeEnCours,
    this.cptAnnulation,
    this.cptAchats,
    this.etatCompteClient,
  ) : idClient = genererNouvelId();

  // Méthode statique pour générer un nouvel ID unique
  static int genererNouvelId() {
    dernierId += 1;
    return dernierId;
  }

  // Getters et Setters
  int get getIdClient => idClient;

  String get getAdresseClient => adresseClient;
  set setAdresseClient(String value) => adresseClient = value;

  String get getNumTelClient => numTelClient;
  set setNumTelClient(String value) => numTelClient = value;

  int get getCptCommandeEnCours => cptCommandeEnCours;
  set setCptCommandeEnCours(int value) => cptCommandeEnCours = value;

  int get getCptAnnulation => cptAnnulation;
  set setCptAnnulation(int value) => cptAnnulation = value;

  int get getCptAchats => cptAchats;
  set setCptAchats(int value) => cptAchats = value;

  bool get getEtatCompteClient => etatCompteClient;
  set setEtatCompteClient(bool value) => etatCompteClient = value;

  // Fonction d'inscription pour un client
  Future<bool> inscriptionClient() async {
    try {
      // Vérifier si l'email existe déjà
      QuerySnapshot snapshot = await _firestore
          .collection('Utilisateur')
          .where('email', isEqualTo: this.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print("Un utilisateur avec cet email existe déjà.");
        return false;
      }

      // Ajouter un nouveau client dans Firestore
      await _firestore.collection('Utilisateur').add({
        'id': idClient,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': motDePasse,
        'adresseClient': adresseClient,
        'numTelClient': numTelClient,
        'cptCommandeEnCours': cptCommandeEnCours,
        'cptAnnulation': cptAnnulation,
        'cptAchats': cptAchats,
        'etatCompteClient': etatCompteClient, 
        'typeUtilisateur': typeUtilisateur,
      });

      print("Inscription client réussie avec id: $idClient");
      return true;
    } catch (e) {
      print("Erreur lors de l'inscription du client : $e");
      return false;
    }
  }
}
