import 'user_modele.dart';

class Commerce extends UtilisateurModele {
  final String nomCommerce;
  final String adresseCommerce;
  final String numTelCommerce;
  final String horaires;
  final String description;
  final String numRegistreCommerce;
  final String registreCommerce;
  final String etatCompteCommercant;
  final double note;
  final int nbNotes;
  final String categorie;

  Commerce({
    required String idUtilisateur,
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String photoDeProfile,
    required String typeUtilisateur,
    required this.nomCommerce,
    required this.adresseCommerce,
    required this.numTelCommerce,
    required this.horaires,
    required this.description,
    required this.numRegistreCommerce,
    required this.registreCommerce,
    required this.etatCompteCommercant,
    required this.note,
    required this.nbNotes,
    required this.categorie,
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

  // Pour la collection Utilisateur
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

  // Pour la collection Commercant
  Map<String, dynamic> toMapCommercant() {
    return {
      'idCommerce': idUtilisateur,
      'nomCommerce': nomCommerce,
      'adresseCommerce': adresseCommerce,
      'numTelCommerce': numTelCommerce,
      'horaires': horaires,
      'description': description,
      'numRegistreCommerce': numRegistreCommerce,
      'registreCommerce': registreCommerce,
      'etatCompteCommercant': etatCompteCommercant,
      'categorie': categorie,
      'note': note,
      'nbNotes': nbNotes,
    };
  }
>>>>>>> 85e60e86762bcf4d654f7f22ac1aa28f43900f60

  factory Commerce.fromMap(String id, Map<String, dynamic> data) {
    return Commerce(
      idUtilisateur: id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      motDePasse: data['motDePasse'] ?? '',
      photoDeProfile: data['photoDeProfile'] ?? '',
      typeUtilisateur: data['typeUtilisateur'] ?? '',
      nomCommerce: data['nomCommerce'] ?? '',
      adresseCommerce: data['adresseCommerce'] ?? '',
      numTelCommerce: data['numTelCommerce'] ?? '',
      horaires: data['horaires'] ?? '',
      description: data['description'] ?? '',
      numRegistreCommerce: data['numRegistreCommerce'] ?? '',
      registreCommerce: data['registreCommerce'] ?? '',
      etatCompteCommercant: data['etatCompteCommercant'] ?? '',
      note: (data['note'] ?? 0).toDouble(),
      nbNotes: data['nbNotes'] ?? 0,
      categorie: data['categorie'] ?? '',
    );
  }
}
