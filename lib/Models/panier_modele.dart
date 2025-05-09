// Models/Panier.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Panier {
  final String id;
  final String description;
  final bool estDisponible;
  final DateTime? heureCreation;
  final DocumentReference<Map<String, dynamic>> idCommercantRef;
  final String photoPanier;
  final double prixFinal;
  final double prixInitial;

  Panier({
    required this.id,
    required this.description,
    required this.estDisponible,
    this.heureCreation,
    required this.idCommercantRef,
    required this.photoPanier,
    required this.prixFinal,
    required this.prixInitial,
  });

  factory Panier.fromMap(String id, Map<String, dynamic> map) {
    print("Panier.fromMap: ID du document: $id");
    print("Panier.fromMap: Données du document: $map");
    return Panier(
      id: id,
      description: map['description'] ?? '',
      estDisponible: map['estDisponible'] ?? false,
      heureCreation: (map['heureCreation'] as Timestamp?)?.toDate(),
      idCommercantRef: map['idCommercant'] as DocumentReference<Map<String, dynamic>>,
      photoPanier: map['photoPanier'] ?? '',
      prixFinal: (map['prixFinal'] ?? 0.0).toDouble(),
      prixInitial: (map['prixInitial'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'estDisponible': estDisponible,
      'heureCreation': heureCreation,
      'idCommercant': idCommercantRef,
      'photoPanier': photoPanier,
      'prixFinal': prixFinal,
      'prixInitial': prixInitial,
    };
  }

  factory Panier.fromJson(Map<String, dynamic> json) {
    return Panier(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      estDisponible: json['estDisponible'] ?? false,
      heureCreation: DateTime.tryParse(json['heureCreation'] ?? ''),
      idCommercantRef: FirebaseFirestore.instance.doc('Commercant/${json['idCommercant']}') as DocumentReference<Map<String, dynamic>>,
      photoPanier: json['photoPanier'] ?? '',
      prixFinal: (json['prixFinal'] ?? 0.0).toDouble(),
      prixInitial: (json['prixInitial'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'estDisponible': estDisponible,
      'heureCreation': heureCreation?.toIso8601String(),
      'idCommercant': idCommercantRef.id,
      'photoPanier': photoPanier,
      'prixFinal': prixFinal,
      'prixInitial': prixInitial,
    };
  }
}
