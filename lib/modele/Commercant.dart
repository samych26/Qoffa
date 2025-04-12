import 'package:cloud_firestore/cloud_firestore.dart';
import 'Utilisateur.dart';

class Commercant extends Utilisateur {
  static int dernierId = 0; 

  int idCommerce;
  String nomCommerce;
  String adresseCommerce;
  String numTelCommerce;
  String horaires;
  String description;
  int cptVentes;
  String numRegistreCommercant;
  String registreCommerce;
  bool etatCompteCommercant; 

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Commercant(
    super.nom,
    super.prenom,
    super.email,
    super.motDePasse,
    super.typeUtilisateur,
    this.nomCommerce,
    this.adresseCommerce,
    this.numTelCommerce,
    this.horaires,
    this.description,
    this.cptVentes,
    this.numRegistreCommercant,
    this.registreCommerce,
    this.etatCompteCommercant, 
  ) : idCommerce = genererNouvelId();

  static int genererNouvelId() {
    dernierId += 1;
    return dernierId;
  }

  // Getters / Setters
  int get getIdCommerce => idCommerce;
  String get getNomCommerce => nomCommerce;
  set setNomCommerce(String value) => nomCommerce = value;

  String get getAdresseCommerce => adresseCommerce;
  set setAdresseCommerce(String value) => adresseCommerce = value;

  String get getNumTelCommerce => numTelCommerce;
  set setNumTelCommerce(String value) => numTelCommerce = value;

  String get getHoraires => horaires;
  set setHoraires(String value) => horaires = value;

  String get getDescription => description;
  set setDescription(String value) => description = value;

  int get getCptVentes => cptVentes;
  set setCptVentes(int value) => cptVentes = value;

  String get getNumRegistreCommercant => numRegistreCommercant;
  set setNumRegistreCommercant(String value) => numRegistreCommercant = value;

  String get getRegistreCommerce => registreCommerce;
  set setRegistreCommerce(String value) => registreCommerce = value;

  bool get getEtatCompteCommercant => etatCompteCommercant;
  set setEtatCompteCommercant(bool value) => etatCompteCommercant = value;

  Future<bool> inscriptionCommercant() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Utilisateur')
          .where('email', isEqualTo: this.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print("Un utilisateur avec cet email existe déjà.");
        return false;
      }

      await _firestore.collection('Utilisateur').add({
        'id': idCommerce,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'motDePasse': motDePasse,
        'nomCommerce': nomCommerce,
        'adresseCommerce': adresseCommerce,
        'numTelCommerce': numTelCommerce,
        'horaires': horaires,
        'description': description,
        'cptVentes': cptVentes,
        'numRegistreCommercant': numRegistreCommercant,
        'registreCommerce': registreCommerce,
        'etatCompteCommercant': etatCompteCommercant, // bool enregistré
        'typeUtilisateur': typeUtilisateur,
      });

      print("Inscription commerçant réussie avec id: $idCommerce");
      return true;
    } catch (e) {
      print("Erreur lors de l'inscription du commerçant : $e");
      return false;
    }
  }
}
