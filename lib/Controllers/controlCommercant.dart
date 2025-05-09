import '../services/serviceCommercant.dart';
import '../Models/commerce_modele.dart';



class CommercantController {
  final FirestoreService _service = FirestoreService();

  Stream<List<Commerce>> chargerCommercantsParCategorie(String categorie) {
    print('CommercantController: chargerCommercantsParCategorie appelé pour la catégorie: $categorie');
    return _service.getCommercantsParCategorie(categorie).map((Commerce) {
      print('CommercantController: Commerces récupérés du service pour $categorie: ${Commerce.length}');
      return Commerce;
    });
  }

  Stream<List<Commerce>> chargerTousLesCommercants() {
    print('Début de chargement des commerçants');
    return _service.getAllCommercants().map((Commerce) {
      print('Nombre de commerçants reçus: ${Commerce.length}');
      if (Commerce.isEmpty) {
        print('Aucun document trouvé dans la collection');
      }
      return Commerce;
    });
  }

  Future<List<String>> chargerCategories() async {
    print('CommercantController: chargerCategories appelé');
    final categories = await _service.getCategories();
    print('CommercantController: Catégories récupérées du service: $categories');
    return categories;
  }
}
