import 'package:cloud_firestore/cloud_firestore.dart';
class Avis {
  final String idAvis;
  final double note;
  final String commentaire;
  final String idClient;
  final String idCommerce;
   final DateTime datePublication;

  Avis({
    required this.idAvis,
    required this.note,
    required this.commentaire,
    required this.idClient,
    required this.idCommerce,
     required this.datePublication,
  });

  factory Avis.fromMap(String id, Map<String, dynamic> data) {
    return Avis(
      idAvis: id,
      note: (data['note'] ?? 0).toDouble(),
      commentaire: data['commentaire'] ?? '',
      idClient: data['idClient'] ?? '',
      idCommerce: data['idCommerce'] ?? '',
      datePublication: data['datePublication'] != null 
          ? (data['datePublication'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
}
