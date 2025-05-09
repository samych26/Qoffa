import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/favoris_modele.dart';
import '../../Models/commerce_modele.dart';

class FavoritControl {
  static const String pastry_Type = "pastry";
  static const String bakery_Type = "bakery";
  static const String restaurant_Type = "restaurant";
  static const String market_Type = "market";

  Future<List<Map<String, dynamic>>> fetchAllFavorites() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('favoris').get();

      print('Nombre total de favoris trouvés : ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> commercesList = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          if (data == null) continue;

          final commercantRef = data['idCommercant'];
          if (commercantRef == null) continue;

          DocumentSnapshot<Map<String, dynamic>> commercantDoc;

          if (commercantRef is String) {
            commercantDoc =
                await FirebaseFirestore.instance
                    .doc('/Commercant/$commercantRef')
                    .get();
          } else if (commercantRef is DocumentReference) {
            commercantDoc =
                await commercantRef.get()
                    as DocumentSnapshot<Map<String, dynamic>>;
          } else {
            continue;
          }

          if (commercantDoc.exists) {
            final commercantData = commercantDoc.data();
            if (commercantData != null) {
              commercesList.add({
                'id': commercantDoc.id,
                'nomCommerce': commercantData['nomCommerce'] ?? 'Nom inconnu',
                'note': commercantData['note'] ?? 0, // <= AJOUT ICI
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
      print('Erreur lors du chargement des favoris: $e');
      return [];
    }
  }

  //  méthode pour récupérer les favoris de type pastry
  Future<List<Map<String, dynamic>>> fetchPastryFavorites() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('favoris')
              .where('categorie', isEqualTo: pastry_Type)
              .get();

      print('Nombre de favoris pastry trouvés : ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> commercesList = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          if (data == null) continue;

          final commercantRef = data['idCommercant'];

          if (commercantRef == null) continue;

          DocumentSnapshot<Map<String, dynamic>> commercantDoc;

          if (commercantRef is String) {
            commercantDoc =
                await FirebaseFirestore.instance
                    .doc('/Commercant/$commercantRef')
                    .get();
          } else if (commercantRef is DocumentReference) {
            commercantDoc =
                await commercantRef.get()
                    as DocumentSnapshot<Map<String, dynamic>>;
          } else {
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
      print('Erreur lors du chargement des favoris pastry: $e');
      return [];
    }
  }

  // Récupérer les favoris avec la catégorie "bakery"
  Future<List<Map<String, dynamic>>> fetchBakeryFavorites() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('favoris')
              .where('categorie', isEqualTo: bakery_Type)
              .get();

      print('Nombre de favoris bakery trouvés : ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> commercesList = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          if (data == null) continue;

          final commercantRef = data['idCommercant'];

          if (commercantRef == null) continue;

          DocumentSnapshot<Map<String, dynamic>> commercantDoc;

          if (commercantRef is String) {
            commercantDoc =
                await FirebaseFirestore.instance
                    .doc('/Commercant/$commercantRef')
                    .get();
          } else if (commercantRef is DocumentReference) {
            commercantDoc =
                await commercantRef.get()
                    as DocumentSnapshot<Map<String, dynamic>>;
          } else {
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
      print('Erreur lors du chargement des favoris  bakery: $e');
      return [];
    }
  }

  // Récupérer les favoris avec la catégorie "restaurant"
  Future<List<Map<String, dynamic>>> fetchRestaurantFavorites() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('favoris')
              .where('categorie', isEqualTo: restaurant_Type)
              .get();

      print('Nombre de favoris res trouvés : ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> commercesList = [];
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          if (data == null) continue;

          final commercantRef = data['idCommercant'];

          if (commercantRef == null) continue;

          DocumentSnapshot<Map<String, dynamic>> commercantDoc;

          if (commercantRef is String) {
            commercantDoc =
                await FirebaseFirestore.instance
                    .doc('/Commercant/$commercantRef')
                    .get();
          } else if (commercantRef is DocumentReference) {
            commercantDoc =
                await commercantRef.get()
                    as DocumentSnapshot<Map<String, dynamic>>;
          } else {
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
      print('Erreur lors du chargement des favoris  bakery: $e');
      return [];
    }
  }

  // Récupérer les favoris avec la catégorie "market"
  Future<List<Map<String, dynamic>>> fetchMarketFavorites() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('favoris')
              .where('categorie', isEqualTo: market_Type)
              .get();

      print('Nombre de favoris market trouvés : ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> commercesList = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          if (data == null) continue;

          final commercantRef = data['idCommercant'];

          if (commercantRef == null) continue;

          DocumentSnapshot<Map<String, dynamic>> commercantDoc;

          if (commercantRef is String) {
            commercantDoc =
                await FirebaseFirestore.instance
                    .doc('/Commercant/$commercantRef')
                    .get();
          } else if (commercantRef is DocumentReference) {
            commercantDoc =
                await commercantRef.get()
                    as DocumentSnapshot<Map<String, dynamic>>;
          } else {
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
      print('Erreur lors du chargement des favoris  market: $e');
      return [];
    }
  }

  static List<String> getFavorisTypes() {
    return [pastry_Type];
  }
}
