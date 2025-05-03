import '../services/serviceCommercant.dart';
import '../Models/commerce_modele.dart';



class CommercantController {
  final FirestoreService _service = FirestoreService();

  Stream<List<Commerce>> chargerCommercantsParCategorie(String categorie) {
    print('CommercantController: chargerCommercantsParCategorie appelé pour la catégorie: $categorie');
    return _service.getCommercantsParCategorie(categorie).map((commerces) {
      print('CommercantController: Commerces récupérés du service pour $categorie: ${commerces.length}');
      return commerces;
    });
  }

  Stream<List<Commerce>> chargerTousLesCommercants() {
    print('CommercantController: chargerTousLesCommercants appelé');
    return _service.getAllCommercants().map((commerces) {
      print('CommercantController: Commerces récupérés du service (tous): ${commerces.length}');
      return commerces;
    });
  }

  Future<List<String>> chargerCategories() async {
    print('CommercantController: chargerCategories appelé');
    final categories = await _service.getCategories();
    print('CommercantController: Catégories récupérées du service: $categories');
    return categories;
  }
}