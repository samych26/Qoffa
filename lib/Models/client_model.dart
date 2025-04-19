// models/client_model.dart
class ClientModel {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String typeUtilisateur;
  final String adresseClient;
  final String numTelClient;

  ClientModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.typeUtilisateur,
    required this.adresseClient,
    required this.numTelClient,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUtilisateur': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'typeUtilisateur': typeUtilisateur,
      'adresseClient': adresseClient,
      'numTelClient': numTelClient,
      'cptCommandesEnCours': 0,
      'cptAnnulations': 0,
      'cptAchats': 0,
      'etatCompteClient': 'actif',
      'photoDeProfile': '',
    };
  }
}
