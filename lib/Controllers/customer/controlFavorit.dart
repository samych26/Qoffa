import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/favoris_modele.dart';
import '../../Models/commerce_modele.dart';

class FavoritControl {
  static const String pastry_Type = "pastry";
  static const String bakery_Type = "bakery";
  static const String restaurant_Type = "restaurant";
  static const String market_Type = "market";

  Future<List<Map<String, dynamic>>> fetchAllFavorites(
      {String? category, String? userId}) async {
    try {
      Query<Map<String, dynamic>> query =
      FirebaseFirestore.instance.collection('Favoris');

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (category != null) {
        query = query.where('categorie', isEqualTo: category);
      }

      final snapshot = await query.get();

      print(
          'Nombre de favoris trouvés pour l\'utilisateur $userId et categorie $category: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> commercesList = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          if (data == null) continue;

          final commercantRef = data['idCommerce'];
          if (commercantRef == null) {
            print('Avertissement: idCommerce est null pour le favori ${doc.id}');
            continue;
          }

          DocumentSnapshot<Map<String, dynamic>> commercantDoc;

          if (commercantRef is String && commercantRef.isNotEmpty) {
            commercantDoc = await FirebaseFirestore.instance
                .doc('/Commerce/$commercantRef')
                .get();
          } else if (commercantRef is DocumentReference) {
            commercantDoc =
            await commercantRef.get() as DocumentSnapshot<Map<String, dynamic>>;
          } else {
            print(
                'Avertissement: idCommerce a un format incorrect pour le favori ${doc.id}: $commercantRef');
            continue;
          }

          if (commercantDoc.exists) {
            final commercantData = commercantDoc.data();
            if (commercantData != null) {
              commercesList.add({
                'id': commercantDoc.id,
                'nomCommerce': commercantData['nomCommerce'] ?? 'Nom inconnu',
                'note': commercantData['note'] ?? 0,
                'categorie': data['categorie'] ?? '',
              });
            }
          }
        } catch (e) {
          print('Erreur lors de la récupération du commerçant: $e');
        }
      }

      return commercesList;
    } catch (e) {
      print(
          'Erreur lors du chargement des favoris pour l\'utilisateur $userId: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFavoritesByCategory(
      String category, String userId) async {
    return fetchAllFavorites(category: category, userId: userId);
  }

  Future<List<Map<String, dynamic>>> fetchPastryFavorites(String userId) {
    return _fetchFavoritesByCategory(pastry_Type, userId);
  }

  Future<List<Map<String, dynamic>>> fetchBakeryFavorites(String userId) {
    return _fetchFavoritesByCategory(bakery_Type, userId);
  }

  Future<List<Map<String, dynamic>>> fetchRestaurantFavorites(String userId) {
    return _fetchFavoritesByCategory(restaurant_Type, userId);
  }

  Future<List<Map<String, dynamic>>> fetchMarketFavorites(String userId) {
    return _fetchFavoritesByCategory(market_Type, userId);
  }
}
