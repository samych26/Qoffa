import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreInitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEmptyCollections() async {
    final collections = [
      'Utilisateur',
      'Client',
      'Commercant',
      'Administrateur',
      'Panier',
      'Avis',
      'Reservation',
      'Notification',
      'Signalement',
      'Interaction',
      'CategorieMagasin',
      'test',

    ];

    for (String name in collections) {
      await _firestore.collection(name).add({'init': true}); // ✅ auto-ID
    }

    print("✅ Collections Firestore créées (vides)");
  }

}
