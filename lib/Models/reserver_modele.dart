import 'package:cloud_firestore/cloud_firestore.dart';

class Reserver {
  final String idReservation;
  final DateTime dateReservation;
  final String codeRecuperation;
  final String idClient;
  final String idPanier;

  Reserver({
    required this.idReservation,
    required this.dateReservation,
    required this.codeRecuperation,
    required this.idClient,
    required this.idPanier,
  });

  factory Reserver.fromMap(String id, Map<String, dynamic> data) {
    return Reserver(
      idReservation: id,
      dateReservation: (data['dateReservation'] as Timestamp).toDate(),
      codeRecuperation: data['codeRecuperation'] ?? '',
      idClient: data['idClient'] ?? '',
      idPanier: data['idPanier'] ?? '',
    );
  }
}
