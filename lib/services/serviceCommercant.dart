import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/modelCommercant.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Méthode pour récupérer les commerces par catégorie
  Stream<List<Commercant>> getCommercantsParCategorie(String categorie) {
    return _db
        .collection('Commercant')
        .where('categorie', isEqualTo: categorie)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Commercant.fromFirestore(doc);
      }).toList();
    });
  }

  // Méthode pour récupérer tous les commerçants
  Stream<List<Commercant>> getAllCommercants() {
    return _db.collection('Commercant').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Commercant.fromFirestore(doc);
      }).toList();
    });
  }

  // Méthode pour récupérer toutes les catégories
  Future<List<String>> getCategories() async {
    var result = await _db.collection('CategorieMagasin').get();
    return result.docs.map((doc) => doc['categorie'] as String).toList();
  }
}