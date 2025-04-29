import 'package:cloud_firestore/cloud_firestore.dart';

class Commercant {
  final String id;
  final String nomCommerce;
  final String categorie;
  final String adresseCommerce;
  final String description;
  final String etatCompteCommerce;
  final String horaire;
  final String numTelCommerce;


  Commercant({
    required this.id,
    required this.nomCommerce,
    required this.categorie,
    required this.adresseCommerce,
    required this.description,
    required this.etatCompteCommerce,
    required this.horaire,
    required this.numTelCommerce,
  });

  factory Commercant.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Commercant(
      id: doc.id,
      nomCommerce: data?['nomCommerce'] ?? 'Nom inconnu',
      categorie: data?['categorie'] ?? 'Catégorie non définie',
      adresseCommerce: data?['adresseCommerce'] ?? 'Adresse inconnue',
      description: data?['description'] ?? 'Description non disponible',
      etatCompteCommerce: data?['etatCompteCommerce'] ?? 'État non défini',
      horaire: data?['horaire'] ?? 'Horaire non disponible',
      numTelCommerce: data?['numTelCommerce'] ?? 'Numéro non disponible',
    );
  }
}