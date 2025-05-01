// Models/commerce.dart
import 'user_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Commerce extends UtilisateurModele {
  final String nomCommerce;
  final String adresseCommerce;
  final String numTelCommerce;
  final String horaires;
  final String description;
  final String? numRegistreCommerce; // Ajouté, rendu nullable car pas dans ton modèle
  final String? registreCommerce; // Ajouté, rendu nullable car pas dans ton modèle
  final String etatCompteCommercant;
  final double? note; // Ajouté, rendu nullable car pas dans ton modèle
  final int? nbNotes; // Ajouté, rendu nullable car pas dans ton modèle
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
    this.numRegistreCommerce,
    this.registreCommerce,
    required this.etatCompteCommercant,
    this.note,
    this.nbNotes,
    required this.categorie,
  }) : super(
          idUtilisateur: idUtilisateur,
          nom: nom,
          prenom: prenom,
          email: email,
          motDePasse: motDePasse,
          photoDeProfile: photoDeProfile,
          typeUtilisateur: typeUtilisateur,
        );

  factory Commerce.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Commerce(
      idUtilisateur: doc.id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      motDePasse: data['motDePasse'] ?? '',
      photoDeProfile: data['photoDeProfile'] ?? '',
      typeUtilisateur: data['typeUtilisateur'] ?? '',
      nomCommerce: data['nomCommerce'] ?? 'Nom inconnu',
      adresseCommerce: data['adresseCommerce'] ?? 'Adresse inconnue',
      numTelCommerce: data['numTelCommerce'] ?? 'Numéro non disponible',
      horaires: data['horaires'] ?? 'Horaire non disponible',
      description: data['description'] ?? 'Description non disponible',
      numRegistreCommerce: data['numRegistreCommerce'],
      registreCommerce: data['registreCommerce'],
      etatCompteCommercant: data['etatCompteCommercant'] ?? 'État non défini',
      note: (data['note'] ?? 0.0).toDouble(),
      nbNotes: data['nbNotes'] ?? 0,
      categorie: data['categorie'] ?? 'Catégorie non définie',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse,
      'photoDeProfile': photoDeProfile,
      'typeUtilisateur': typeUtilisateur,
      'nomCommerce': nomCommerce,
      'adresseCommerce': adresseCommerce,
      'numTelCommerce': numTelCommerce,
      'horaires': horaires,
      'description': description,
      'numRegistreCommerce': numRegistreCommerce,
      'registreCommerce': registreCommerce,
      'etatCompteCommercant': etatCompteCommercant,
      'note': note,
      'nbNotes': nbNotes,
      'categorie': categorie,
    };
  }

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
      numRegistreCommerce: data['numRegistreCommerce'],
      registreCommerce: data['registreCommerce'],
      etatCompteCommercant: data['etatCompteCommercant'] ?? '',
      note: (data['note'] ?? 0.0).toDouble(),
      nbNotes: data['nbNotes'] ?? 0,
      categorie: data['categorie'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse,
      'photoDeProfile': photoDeProfile,
      'typeUtilisateur': typeUtilisateur,
      'nomCommerce': nomCommerce,
      'adresseCommerce': adresseCommerce,
      'numTelCommerce': numTelCommerce,
      'horaires': horaires,
      'description': description,
      'numRegistreCommerce': numRegistreCommerce,
      'registreCommerce': registreCommerce,
      'etatCompteCommercant': etatCompteCommercant,
      'note': note,
      'nbNotes': nbNotes,
      'categorie': categorie,
    };
  }
}