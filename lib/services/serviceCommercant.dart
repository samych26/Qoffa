import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/commerce_modele.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Commerce>> getCommercantsParCategorie(String categorie) {
    return _db
        .collection('Commerce')  // Changé de 'Commercant' à 'Commerce'
        .where('categorie', isEqualTo: categorie)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Commerce.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<Commerce>> getAllCommercants() {
    return _db.collection('Commerce')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Commerce.fromFirestore(doc);
      }).toList();
    });
  }

  Future<List<String>> getCategories() async {
    var result = await _db.collection('Commerce').get();
    return result.docs.map((doc) => doc['categorie'] as String).toList();
  }
}