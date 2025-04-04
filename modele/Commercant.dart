import 'Utilisateur.dart';

class Commercant extends Utilisateur {
  int idCommerce;
  String nomCommerce;
  String adresseCommerce;
  String numTelCommerce;
  String horaires;
  String description;
  int cptVentes;
  String numRegistreCommercant;
  String registreCommerce;
  String etatCompteCommercant;

  Commercant(
      String nom,
      String prenom,
      String email,
      String motDePasse,
      TypeUtilisateur typeUtilisateur,
      this.idCommerce,
      this.nomCommerce,
      this.adresseCommerce,
      this.numTelCommerce,
      this.horaires,
      this.description,
      this.cptVentes,
      this.numRegistreCommercant,
      this.registreCommerce,
      this.etatCompteCommercant)
      : super(nom, prenom, email, motDePasse, typeUtilisateur);

  int get getIdCommerce => idCommerce;
  set setIdCommerce(int value) => idCommerce = value;

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

  String get getEtatCompteCommercant => etatCompteCommercant;
  set setEtatCompteCommercant(String value) => etatCompteCommercant = value;
}
