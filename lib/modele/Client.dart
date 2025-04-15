import 'Utilisateur.dart';

abstract class Client extends Utilisateur {
  static int dernierId = 0; 

  int idClient;
  String adresseClient;
  String numTelClient;
  int cptCommandeEnCours;
  int cptAnnulation;
  int cptAchats;
  bool etatCompteClient; 

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

  // Fonctions abstraites
  Future<bool> inscriptionClient(); 
  Future<void> miseAJourClient();
  Future<void> supprimerClient();
}
