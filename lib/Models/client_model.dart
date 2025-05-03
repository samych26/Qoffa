import 'user_modele.dart';

class Client extends UtilisateurModele {
  final String adresseClient;
  final String numTelClient;

  Client({
    required String idUtilisateur,
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String photoDeProfile,
    required String typeUtilisateur,
    required this.adresseClient,
    required this.numTelClient,
  }) : super(
<<<<<<< HEAD
          idUtilisateur: idUtilisateur,
          nom: nom,
          prenom: prenom,
          email: email,
          motDePasse: motDePasse,
          photoDeProfile: photoDeProfile,
          typeUtilisateur: typeUtilisateur,
        );
=======
    idUtilisateur: idUtilisateur,
    nom: nom,
    prenom: prenom,
    email: email,
    motDePasse: motDePasse,
    photoDeProfile: photoDeProfile,
    typeUtilisateur: typeUtilisateur,
  );
>>>>>>> 85e60e86762bcf4d654f7f22ac1aa28f43900f60

  factory Client.fromMap(String id, Map<String, dynamic> data) {
    return Client(
      idUtilisateur: id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      motDePasse: data['motDePasse'] ?? '',
      photoDeProfile: data['photoDeProfile'] ?? '',
      typeUtilisateur: data['typeUtilisateur'] ?? '',
      adresseClient: data['adresseClient'] ?? '',
      numTelClient: data['numTelClient'] ?? '',
    );
<<<<<<< HEAD
=======
  }

  // Ajoute ceci :
  Map<String, dynamic> toMapUtilisateur() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse,
      'photoDeProfile': photoDeProfile,
      'typeUtilisateur': typeUtilisateur,
    };
  }

  Map<String, dynamic> toMapClient() {
    return {
      'idClient': idUtilisateur,
      'adresseClient': adresseClient,
      'numTelClient': numTelClient,
      'etatCompteClient': 'actif',
    };
>>>>>>> 85e60e86762bcf4d654f7f22ac1aa28f43900f60
  }
}
