import 'package:cloud_firestore/cloud_firestore.dart';

class Panier {
  final String idPanier;
  final String photoPanier;
  final double prixInitial;
  final double prixFinal;
  final DateTime heureCreation;
  final String description;
  final bool estDisponible;
  final String idUtilisateur;

  Panier({
    required this.idPanier,
    required this.photoPanier,
    required this.prixInitial,
    required this.prixFinal,
    required this.heureCreation,
    required this.description,
    required this.estDisponible,
    required this.idUtilisateur,
  });



  factory Panier.fromMap(String id, Map<String, dynamic> data) {
    return Panier(
      idPanier: id,
      photoPanier: data['photoPanier'] ?? '',
      prixInitial: (data['prixInitial'] ?? 0).toDouble(),
      prixFinal: (data['prixFinal'] ?? 0).toDouble(),
      heureCreation: (data['heureCreation'] as Timestamp).toDate(), // si Firestore
      description: data['description'] ?? '',
      estDisponible: data['estDisponible'] ?? false,
      idUtilisateur: data['idUtilisateur'] ?? '',
    );
  }
}
