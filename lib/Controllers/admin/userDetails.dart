import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/client_model.dart';
import '../../Models/user_modele.dart';
import '../../Models/commerce_modele.dart';



class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  String getClientFullName(Client client) {
    return '${client.prenom} ${client.nom}';
  }


  Future<Client?> getClientDetails(String idClient) async {
    try {
      // Récupérer les données de l'utilisateur
      final userDoc = await _firestore.collection('Utilisateur').doc(idClient).get();
      
      if (!userDoc.exists) {
        print('Aucun utilisateur trouvé avec cet ID: $idClient');
        return null;
      }
      
      // Créer un modèle utilisateur à partir des données
      final userData = userDoc.data() as Map<String, dynamic>;
      final user = UtilisateurModele.fromMap(idClient, userData);
      
      // Récupérer les données spécifiques au client
      final clientDoc = await _firestore.collection('Client').doc(idClient).get();
      
      if (!clientDoc.exists) {
        print('Données client non trouvées pour cet ID: $idClient');
        return null;
      }
      
      final clientData = clientDoc.data() as Map<String, dynamic>;
      
      // Créer et retourner un objet Client complet
      return Client(
        idUtilisateur: user.idUtilisateur,
        nom: user.nom,
        prenom: user.prenom,
        email: user.email,
        motDePasse: user.motDePasse,
        photoDeProfile: user.photoDeProfile,
        numTelClient: clientData['numTelClient'] ?? '',
        adresseClient: clientData['adresseClient'] ?? '',
        typeUtilisateur: "Client"
      );
    } catch (e) {
      print('Erreur lors de la récupération des détails du client: $e');
      return null;
    }
  }


  Future<Commerce?> getBusinessDetails(String idCommerce) async {
    try {
      // Récupérer les données de l'utilisateur
      final userDoc = await _firestore.collection('Utilisateur').doc(idCommerce).get();
      
      if (!userDoc.exists) {
        print('Aucun utilisateur trouvé avec cet ID: $idCommerce');
        return null;
      }
      
      // Créer un modèle utilisateur à partir des données
      final userData = userDoc.data() as Map<String, dynamic>;
      final user = UtilisateurModele.fromMap(idCommerce, userData);
      
      // Récupérer les données spécifiques au commerce
      final businessDoc = await _firestore.collection('Commerce').doc(idCommerce).get();
      
      if (!businessDoc.exists) {
        print('Données commerce non trouvées pour cet ID: $idCommerce');
        return null;
      }
      
      final businessData = businessDoc.data() as Map<String, dynamic>;
      
      // Créer et retourner un objet Commerce complet
      return Commerce(
        idUtilisateur: user.idUtilisateur,
        nom: user.nom,
        prenom: user.prenom,
        email: user.email,
        motDePasse: user.motDePasse,
        photoDeProfile: user.photoDeProfile,
        numTelCommerce: businessData['numTelCommerce'] ?? '',
        adresseCommerce: businessData['adresseCommerce'] ?? '',
        typeUtilisateur: "Commerce", 
        nomCommerce: businessData['nomCommerce'] ?? '',
        numRegistreCommerce: businessData['numRegistreCommerce'] ?? '',
        categorie: businessData['categorie'] ?? '', 
        nbNotes: (businessData['nbNotes'] is int) ? businessData['nbNotes'] : 0, 
        note: (businessData['note'] is num) ? businessData['note'].toDouble() : 0.0,
        horaires: businessData['horaires'] ?? '', 
        description: businessData['description'] ?? '', 
        registreCommerce: businessData['registreCommerce'] ?? '', 
        etatCompteCommercant: businessData['etatCompteCommercant'] ?? ''
      );
    } catch (e) {
      print('Erreur lors de la récupération des détails du commercant: $e');
      return null;
    }
  }



  Future<bool> verifyBusinessAccount(String idCommerce) async {
    try {
      // Mettre à jour le statut du compte dans Firestore
      await _firestore.collection('Commerce').doc(idCommerce).update({
        'etatCompteCommercant': 'verified',
        'dateVerification': FieldValue.serverTimestamp(),
      });
      
      print('Compte commerce vérifié avec succès: $idCommerce');
      return true;
    } catch (e) {
      print('Erreur lors de la vérification du compte commerce: $e');
      return false;
    }
  }
  



  Future<bool> rejectBusinessAccount(String idCommerce, {String? motifRejet}) async {
    try {
      // Mettre à jour le statut du compte dans Firestore
      await _firestore.collection('Commerce').doc(idCommerce).update({
        'etatCompteCommercant': 'rejected',
        'dateRejet': FieldValue.serverTimestamp(),
        if (motifRejet != null) 'motifRejet': motifRejet,
      });
      
      print('Compte commerce rejeté avec succès: $idCommerce');
      return true;
    } catch (e) {
      print('Erreur lors du rejet du compte commerce: $e');
      return false;
    }
  }



  Future<List<Map<String, dynamic>>> getFavouriteShops(String idClient) async {
    try {
      // Récupérer les favoris du client
      final favouritesSnapshot = await _firestore
          .collection('Favoris')
          .where('idClient', isEqualTo: idClient)
          .get();
      
      List<Map<String, dynamic>> shops = [];
      
      // Pour chaque favori, récupérer les détails du commerce
      for (var doc in favouritesSnapshot.docs) {
        final favouriteData = doc.data();
        final commerceId = favouriteData['idCommerce'];
        
        // Récupérer les données du commerce
        final commerceDoc = await _firestore.collection('Commerce').doc(commerceId).get();
        final userDoc = await _firestore.collection('Utilisateur').doc(commerceId).get();
        
        if (commerceDoc.exists && userDoc.exists) {
          final commerceData = commerceDoc.data() as Map<String, dynamic>;
          final userData = userDoc.data() as Map<String, dynamic>;
          
          shops.add({
            'id': commerceId,
            'name': commerceData['nomCommerce'] ?? 'Sans nom',
            'category': commerceData['categorie'] ?? 'Restaurant',
            'image': userData['photoDeProfile'] ?? 'assets/images/shop_placeholder.jpg',
          });
        }
      }
      
      return shops;
    } catch (e) {
      print('Erreur lors de la récupération des magasins favoris: $e');
      return [];
    }
  }




  Future<List<Map<String, dynamic>>> getClientReviews(String idClient) async {
    try {
      // Récupérer les avis du client
      final reviewsSnapshot = await _firestore
          .collection('Avis')
          .where('idClient', isEqualTo: idClient)
          .get();
      
      List<Map<String, dynamic>> reviews = [];
      
      for (var doc in reviewsSnapshot.docs) {
        final reviewData = doc.data();
        final commerceId = reviewData['idCommerce'];
        
        // Récupérer le nom du commerce
        String commerceName = 'Commerce inconnu';
        final commerceDoc = await _firestore.collection('Commerce').doc(commerceId).get();
        
        if (commerceDoc.exists) {
          final commerceData = commerceDoc.data() as Map<String, dynamic>;
          commerceName = commerceData['nomCommerce'] ?? 'Commerce inconnu';
        }
        
        // Créer un objet Avis avec le nom du commerce
        reviews.add({
          'id': doc.id,
          'note': (reviewData['note'] ?? 0).toDouble(),
          'commentaire': reviewData['commentaire'] ?? '',
          'idClient': reviewData['idClient'] ?? '',
          'idCommerce': commerceId,
          'commerceName': commerceName,
          'date': reviewData['date'] != null 
              ? (reviewData['date'] as Timestamp).toDate() 
              : DateTime.now(),
        });
      }
      
      // Trier les avis par date (du plus récent au plus ancien)
      reviews.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      
      return reviews;
    } catch (e) {
      print('Erreur lors de la récupération des avis: $e');
      return [];
    }
  }




  Future<List<Map<String, dynamic>>> getReservedQoffas(String idClient) async {
    try {
      // Récupérer les réservations du client
      final reservationsSnapshot = await _firestore
          .collection('Reserver')
          .where('idClient', isEqualTo: idClient)
          .get();
      
      List<Map<String, dynamic>> reservedQoffas = [];
      
      // Pour chaque réservation, récupérer les détails du panier
      for (var doc in reservationsSnapshot.docs) {
        final reservationData = doc.data();
        final panierId = reservationData['idPanier'];
        
        // Récupérer les données du panier
        final panierDoc = await _firestore.collection('Panier').doc(panierId).get();
        
        if (panierDoc.exists) {
          final panierData = panierDoc.data() as Map<String, dynamic>;
          final commerceId = panierData['idCommerce'];
          
          // Récupérer le nom du commerce
          final commerceDoc = await _firestore.collection('Commerce').doc(commerceId).get();
          String commerceName = 'Commerce inconnu';
          String category = '';
          
          if (commerceDoc.exists) {
            final commerceData = commerceDoc.data() as Map<String, dynamic>;
            commerceName = commerceData['nomCommerce'] ?? 'Commerce inconnu';
            category = commerceData['categorie'] ?? '';
          }
          
          reservedQoffas.add({
            'id': panierId,
            'name': commerceName,
            'category': category,
            'price': '${panierData['prixFinal']}DA',
            'image': panierData['photoPanier'] ?? 'assets/images/panier_placeholder.jpg',
            'code': reservationData['codeRecuperation'] ?? 'N/A',
            'date': reservationData['dateReservation'] != null 
                ? (reservationData['dateReservation'] as Timestamp).toDate() 
                : DateTime.now(),
          });
        }
      }
      
      // Trier les réservations par date (du plus récent au plus ancien)
      reservedQoffas.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      
      return reservedQoffas;
    } catch (e) {
      print('Erreur lors de la récupération des paniers réservés: $e');
      return [];
    }
  }
  

  
  
}