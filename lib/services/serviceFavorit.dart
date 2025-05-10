import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/favoris_modele.dart';
import '../Models/commerce_modele.dart';

class FirestoreFavoriService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Méthode pour récupérer les favoris par catégorie
  Future<List<Favoris>> getFavorisParCategorie(String categorie) async {
    try {
      final favorisSnapshot = await _db.collection('Favoris').get();

      List<Favoris> favorisFiltres = [];

      for (var doc in favorisSnapshot.docs) {
        final data = doc.data();
        final idCommercant = data['idCommerce'];

        if (idCommercant == null) continue;

        final commercantDoc =
        await _db.collection('Commerce').doc(idCommercant).get();

        if (commercantDoc.exists) {
          final commercantData = commercantDoc.data();
          if (commercantData != null &&
              commercantData['categorie'] == categorie) {
            favorisFiltres.add(Favoris.fromMap(data));
          }
        }
      }

      return favorisFiltres;
    } catch (e) {
      print('Erreur dans getFavorisParCategorie : $e');
      return [];
    }
  }

  Stream<List<Favoris>> getFavorisByClient(String idClient) {
    return FirebaseFirestore.instance
        .collection('Favoris')
        .where('idClient', isEqualTo: idClient)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                Favoris.fromMap(doc.data() as Map<String, dynamic>),
          )
              .toList(),
    );
  }

  // Méthode pour récupérer tous les favoris d'un client
  Future<List<Favoris>> getFavorisParClient(String idClient) async {
    final snapshot =
    await _db
        .collection('Favoris')
        .where('idClient', isEqualTo: _db.doc('Client/$idClient'))
        .get();

    return snapshot.docs
        .map((doc) => Favoris.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Méthode pour récupérer un commercant à partir de son id
  Future<Commerce> getCommercantById(String commercantId) async {
    final doc = await _db.collection('Commerce').doc(commercantId).get();
    if (doc.exists) {
      return Commerce.fromFirestore(doc);
    } else {
      throw Exception('Commercant non trouvé');
    }
  }

  Future<List<Commerce>> getCommercesFavorisParCategorie({
    required String idClient,
    required String categorie,
  }) async {
    try {
      // Récupérer les favoris du client
      final favorisSnapshot =
      await _db
          .collection('Favoris')
          .where('idClient', isEqualTo: idClient)
          .get();

      List<Commerce> commercesFiltres = [];

      for (var doc in favorisSnapshot.docs) {
        final data = doc.data();
        final idCommercant = data['idCommerce'];

        if (idCommercant == null) continue;

        final commercantDoc =
        await _db.collection('Commerce').doc(idCommercant).get();

        if (commercantDoc.exists) {
          final commercantData = commercantDoc.data();
          if (commercantData != null &&
              commercantData['categorie'] == categorie) {
            commercesFiltres.add(Commerce.fromFirestore(commercantDoc));
          }
        }
      }

      return commercesFiltres;
    } catch (e) {
      print('Erreur dans getCommercesFavorisParCategorie : $e');
      return [];
    }
  }
}
