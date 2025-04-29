import '../services/serviceCommercant.dart';
import '../Models/modelCommercant.dart';

class CommercantController {
  final FirestoreService _service = FirestoreService();

  Stream<List<Commercant>> chargerCommercantsParCategorie(String categorie) {
    print('CommercantController: chargerCommercantsParCategorie appelé pour la catégorie: $categorie');
    return _service.getCommercantsParCategorie(categorie).map((commercants) {
      print('CommercantController: Commerçants récupérés du service pour $categorie: ${commercants.length}');
      return commercants;
    });
  }

  Stream<List<Commercant>> chargerTousLesCommercants() {
    print('CommercantController: chargerTousLesCommercants appelé');
    return _service.getAllCommercants().map((commercants) {
      print('CommercantController: Commerçants récupérés du service (tous): ${commercants.length}');

      return commercants;
    });
  }

  Future<List<String>> chargerCategories() async {
    print('CommercantController: chargerCategories appelé');
    final categories = await _service.getCategories();
    print('CommercantController: Catégories récupérées du service: $categories');
    return categories;
  }
}