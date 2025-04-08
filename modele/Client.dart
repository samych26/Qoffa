import 'Utilisateur.dart';

class Client extends Utilisateur {
  int idClient;
  String adresseClient;
  String numTelClient;
  int cptCommandeEnCours;
  int cptAnnulation;
  int cptAchats;
  String etatCompteClient;

  Client(
      String nom,
      String prenom,
      String email,
      String motDePasse,
      TypeUtilisateur typeUtilisateur,  
      this.idClient,
      this.adresseClient,
      this.numTelClient,
      this.cptCommandeEnCours,
      this.cptAnnulation,
      this.cptAchats,
      this.etatCompteClient)
      : super(nom, prenom, email, motDePasse, typeUtilisateur);

  int get getIdClient => idClient;
  set setIdClient(int value) => idClient = value;

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

  String get getEtatCompteClient => etatCompteClient;
  set setEtatCompteClient(String value) => etatCompteClient = value;
}
