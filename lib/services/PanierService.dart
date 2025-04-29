import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/PanierModel.dart';

class PanierService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PanierModel>> streamPaniersDisponiblesAujourdhui() {
    print("PanierService: Début de streamPaniersDisponiblesAujourdhui");

    // Obtenez le début et la fin de la journée actuelle en timestamp Firestore.
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    return _firestore
        .collection('Panier')
        .where('estDisponible', isEqualTo: true)
        .where('heureCreation', isGreaterThanOrEqualTo: startTimestamp)
        .where('heureCreation', isLessThanOrEqualTo: endTimestamp)
        .snapshots()
        .map((snapshot) {
      print("PanierService: Nouveau snapshot reçu (streamPaniersDisponiblesAujourdhui) - Nombre de documents: ${snapshot.docs.length}");
      final paniers = snapshot.docs
          .map((doc) {
        print("PanierService: Données du document (streamPaniersDisponiblesAujourdhui): ${doc.id}, ${doc.data()}");
        return PanierModel.fromMap(doc.id, doc.data());
      })
          .toList();
      print("PanierService: Liste des paniers émise (streamPaniersDisponiblesAujourdhui): ${paniers.length}");
      return paniers;
    });
  }

  // L'ancienne méthode reste si vous en avez besoin ailleurs
  Stream<List<PanierModel>> streamPaniersDisponibles() {
    print("PanierService: Début de streamPaniersDisponibles");
    return _firestore
        .collection('Panier')
        .where('estDisponible', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      print("PanierService: Nouveau snapshot reçu (streamPaniersDisponibles) - Nombre de documents: ${snapshot.docs.length}");
      final paniers = snapshot.docs
          .map((doc) {
        print("PanierService: Données du document (streamPaniersDisponibles): ${doc.id}, ${doc.data()}");
        return PanierModel.fromMap(doc.id, doc.data());
      })
          .toList();
      print("PanierService: Liste des paniers émise (streamPaniersDisponibles): ${paniers.length}");
      return paniers;
    });
  }

  // Méthode pour récupérer les paniers disponibles une seule fois (utilisée dans votre HomePage)
  Future<List<PanierModel>> getPaniersDisponiblesAujourdhui() async {
    print("PanierService: Début de getPaniersDisponiblesAujourdhui");
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Panier')
          .where('estDisponible', isEqualTo: true)
          .where('heureCreation', isGreaterThanOrEqualTo: startTimestamp)
          .where('heureCreation', isLessThanOrEqualTo: endTimestamp)
          .get();

      print("PanierService: Nombre de documents récupérés (getPaniersDisponiblesAujourdhui): ${snapshot.docs.length}");
      final paniers = snapshot.docs.map((doc) {
        print("PanierService: Données du document (getPaniersDisponiblesAujourdhui): ${doc.id}, ${doc.data()}");
        return PanierModel.fromMap(doc.id, doc.data());
      }).toList();
      print("PanierService: Liste des paniers créés (getPaniersDisponiblesAujourdhui): ${paniers.length}");
      return paniers;
    } catch (e) {
      print("PanierService: Erreur lors de la récupération des paniers disponibles aujourd'hui: $e");
      return [];
    }
  }
}