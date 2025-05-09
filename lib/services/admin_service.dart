import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/client_model.dart';
import '../Models/commerce_modele.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Models/user_modele.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getNombreUtilisateurs() async {
    final snapshot = await _firestore.collection('Utilisateur').get();
    return snapshot.size;
  }

  Future<int> getNombreCommercant() async {
    final snapshot = await _firestore.collection('Commerce').get();
    return snapshot.size;
  }

  Future<int> getNombreClient() async {
    final snapshot = await _firestore.collection('Client').get();
    return snapshot.size;
  }

  Future<int> getTotalSales() async {
    final snapshot = await _firestore.collection('Reserver').get();
    return snapshot.size;
  }

  Future<List<Map<String, dynamic>>> getListeCommerces() async {
    final snapshot = await _firestore.collection('Commerce').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id, // Inclure l'ID du document
        'name': data['nomCommerce'] ?? 'Commerce inconnu',
        'status': data['etatCompteCommercant'] ?? 'In Progress',
      };
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return const Color.fromARGB(255, 48, 209, 56);
      case 'in progress':
        return Colors.purple.shade400;
      case 'pending':
        return Colors.blue.shade500;
      case 'suspended':
        return Colors.amber.shade500;
      case 'rejected':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade400;
    }
  }


  
  String getClientFullName(Client client) {
    return '${client.prenom} ${client.nom}';
  }

  Future<Client?> getClientDetails(String idClient) async {
  try {
    if (idClient.isEmpty) {
      print('ID client vide');
      return null;
    }
    
    // Récupérer les données de l'utilisateur
    final userDoc = await _firestore.collection('Utilisateur').doc(idClient).get();
    
    if (!userDoc.exists || userDoc.data() == null) {
      print('Aucun utilisateur trouvé avec cet ID: $idClient');
      return null;
    }
    
    // Créer un modèle utilisateur à partir des données
    final userData = userDoc.data() as Map<String, dynamic>;
    final user = UtilisateurModele.fromMap(idClient, userData);
    
    // Récupérer les données spécifiques au client
    final clientDoc = await _firestore.collection('Client').doc(idClient).get();
    
    if (!clientDoc.exists || clientDoc.data() == null) {
      print('Données client non trouvées pour cet ID: $idClient');
      // Retourner un client avec des valeurs par défaut si les données spécifiques ne sont pas trouvées
      return Client(
        idUtilisateur: user.idUtilisateur,
        nom: user.nom,
        prenom: user.prenom,
        email: user.email,
        motDePasse: user.motDePasse,
        photoDeProfile: user.photoDeProfile,
        numTelClient: '',
        adresseClient: '',
        typeUtilisateur: "Client"
      );
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
        'etatCompteCommercant': 'Verified',
      });
      
      print('Compte commerce vérifié avec succès: $idCommerce');
      return true;
    } catch (e) {
      print('Erreur lors de la vérification du compte commerce: $e');
      return false;
    }
  }

  Future<bool> rejectBusinessAccount(String idCommerce) async {
    try {
      // Mettre à jour le statut du compte dans Firestore
      await _firestore.collection('Commerce').doc(idCommerce).update({
        'etatCompteCommercant': 'Rejected',
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
            'name': commerceData['nomCommerce'] ?? 'Inconnu',
            'category': commerceData['categorie'] ?? 'Commerce',
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
        
        // Créer un objet Avis enrichi avec le nom du commerce
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

      // Formater les dates pour l'affichage
      reviews = reviews.map((review) {
        final date = review['date'] as DateTime;
        review['dateFormatted'] = '${date.day}/${date.month}/${date.year.toString().substring(2)}';
        return review;
      }).toList();
      
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
          
          // Récupérer l'URL de l'image depuis Firebase Storage si nécessaire
          String photoUrl = 'assets/images/panier_placeholder.jpg';
          
          if (panierData['photoPanier'] != null) {
            // Si l'URL est déjà complète (commence par http ou https)
            if (panierData['photoPanier'].toString().startsWith('http')) {
              photoUrl = panierData['photoPanier'];
            } 
            // Si c'est un chemin dans Firebase Storage
            else {
              try {
                // Construire le chemin complet dans Storage
                String storagePath = panierData['photoPanier'];
                
                // Si le chemin ne commence pas par 'paniers/', ajoutez-le
                if (!storagePath.startsWith('paniers/')) {
                  storagePath = 'paniers/$storagePath';
                }
                
                // Récupérer l'URL de téléchargement
                final ref = FirebaseStorage.instance.ref().child(storagePath);
                photoUrl = await ref.getDownloadURL();
                
                print('URL de l\'image récupérée: $photoUrl');
              } catch (storageError) {
                print('Erreur lors de la récupération de l\'image: $storageError');
                // Garder l'URL par défaut en cas d'erreur
              }
            }
          }
          
          reservedQoffas.add({
            'id': panierId,
            'nomCommerce': commerceName,
            'category': category,
            'price': '${panierData['prixFinal']}DA',
            'photoPanier': photoUrl,
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




  Future<Map<String, dynamic>> getBusinessActivityStats(String idCommerce) async {
    try {
      // Statistiques initiales
      Map<String, dynamic> stats = {
        'qoffasSold': 0,
        'revenues': 0,
        'favouriteOf': 0,
        'reviews': 0,
      };

      // Étape 1 : Récupérer tous les paniers du commerce (pour identifier leurs IDs)
      final paniersSnapshot = await _firestore
          .collection('Panier')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();

      // Créer une map [idPanier => prixFinal]
      final Map<String, double> panierMap = {};
      for (var doc in paniersSnapshot.docs) {
        final data = doc.data();
        panierMap[doc.id] = (data['prixFinal'] ?? 0).toDouble();
      }

      // Étape 2 : Récupérer toutes les réservations
      final reservationsSnapshot = await _firestore
          .collection('Reserver')
          .get(); 

      int qoffasSold = 0;
      double totalRevenue = 0;

      for (var doc in reservationsSnapshot.docs) {
        final data = doc.data();
        final idPanier = data['idPanier'];

        // Vérifie si le panier réservé appartient à ce commerce
        if (panierMap.containsKey(idPanier)) {
          qoffasSold += 1;
          totalRevenue += panierMap[idPanier]!;
        }
      }

      stats['qoffasSold'] = qoffasSold;
      stats['revenues'] = totalRevenue.round();

      // Étape 3 : Récupérer les favoris
      final favouritesSnapshot = await _firestore
          .collection('Favoris')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      stats['favouriteOf'] = favouritesSnapshot.docs.length;

      // Étape 4 : Récupérer les avis
      final reviewsSnapshot = await _firestore
          .collection('Avis')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      stats['reviews'] = reviewsSnapshot.docs.length;

      return stats;
    } catch (e) {
      print('Erreur lors de la récupération des statistiques d\'activité: $e');
      return {
        'qoffasSold': 0,
        'revenues': 0,
        'favouriteOf': 0,
        'reviews': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getBusinessTransactions(String idCommerce) async {
    try {
      // Récupérer les paniers du commerce qui ont été réservés
      final paniersSnapshot = await _firestore
          .collection('Panier')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      
      List<String> panierIds = paniersSnapshot.docs.map((doc) => doc.id).toList();
      List<Map<String, dynamic>> transactions = [];
      
      // Pour chaque panier, vérifier s'il a été réservé
      for (String panierId in panierIds) {
        final reservationsSnapshot = await _firestore
            .collection('Reserver')
            .where('idPanier', isEqualTo: panierId)
            .get();
        
        for (var doc in reservationsSnapshot.docs) {
          final reservationData = doc.data();
          final clientId = reservationData['idClient'];
          
          // Récupérer les informations du client
          final clientDoc = await _firestore.collection('Utilisateur').doc(clientId).get();
          String clientName = 'Client inconnu';
          
          if (clientDoc.exists) {
            final clientData = clientDoc.data() as Map<String, dynamic>;
            clientName = '${clientData['prenom'] ?? ''} ${clientData['nom'] ?? ''}'.trim();
          }
          
          // Récupérer les informations du panier
          final panierDoc = await _firestore.collection('Panier').doc(panierId).get();
          String amount = '???';
          
          if (panierDoc.exists) {
            final panierData = panierDoc.data() as Map<String, dynamic>;
            amount = '${panierData['prixFinal'] ?? 0}DA';
          }
          
          transactions.add({
            'id': doc.id,
            'name': clientName,
            'date': reservationData['dateReservation'] != null 
                ? (reservationData['dateReservation'] as Timestamp).toDate() 
                : DateTime.now(),
            'amount': amount,
          });
        }
      }
      
      // Trier les transactions par date (du plus récent au plus ancien)
      transactions.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      
      // Formater les dates pour l'affichage
      transactions = transactions.map((transaction) {
        final date = transaction['date'] as DateTime;
        transaction['dateFormatted'] = '${date.day}/${date.month}/${date.year}';
        return transaction;
      }).toList();
      
      return transactions;
    } catch (e) {
      print('Erreur lors de la récupération des transactions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBusinessReviews(String idCommerce) async {
    try {
      // Récupérer les avis du commerce
      final reviewsSnapshot = await _firestore
          .collection('Avis')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      
      List<Map<String, dynamic>> reviews = [];
      
      for (var doc in reviewsSnapshot.docs) {
        final reviewData = doc.data();
        final clientId = reviewData['idClient'];
        
        // Récupérer les informations du client
        final clientDoc = await _firestore.collection('Utilisateur').doc(clientId).get();
        String clientName = 'Client inconnu';
        
        if (clientDoc.exists) {
          final clientData = clientDoc.data() as Map<String, dynamic>;
          clientName = '${clientData['prenom'] ?? ''} ${clientData['nom'] ?? ''}'.trim();
        }
        
        reviews.add({
          'id': doc.id,
          'name': clientName,
          'rating': (reviewData['note'] ?? 0).toInt(),
          'comment': reviewData['commentaire'] ?? '',
          'date': reviewData['date'] != null 
              ? (reviewData['date'] as Timestamp).toDate() 
              : DateTime.now(),
        });
      }
      
      // Trier les avis par date (du plus récent au plus ancien)
      reviews.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      
      // Formater les dates pour l'affichage
      reviews = reviews.map((review) {
        final date = review['date'] as DateTime;
        review['dateFormatted'] = '${date.day}/${date.month}/${date.year.toString().substring(2)}';
        return review;
      }).toList();
      
      return reviews;
    } catch (e) {
      print('Erreur lors de la récupération des avis: $e');
      return [];
    }
  }

  Future<bool> suspendBusinessAccount(String idCommerce) async {
    try {
      // Mettre à jour le statut du compte dans Firestore
      await _firestore.collection('Commerce').doc(idCommerce).update({
        'etatCompteCommercant': 'Suspended',
      });
      
      print('Compte commerce suspendu avec succès: $idCommerce');
      return true;
    } catch (e) {
      print('Erreur lors de la suspension du compte commerce: $e');
      return false;
    }
  }

  Future<int> getQoffasSoldCount(String idCommerce) async {
    try {
      // Récupérer d'abord tous les paniers du commerce
      final paniersSnapshot = await _firestore
          .collection('Panier')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      
      // Extraire les IDs des paniers
      List<String> panierIds = paniersSnapshot.docs.map((doc) => doc.id).toList();
      
      // Si aucun panier trouvé retourner 0
      if (panierIds.isEmpty) {
        return 0;
      }
      
      // Compter les réservations pour ces paniers
      int totalSold = 0;
      
      // Pour chaque lot de 10 paniers (limitation de Firestore pour whereIn)
      for (int i = 0; i < panierIds.length; i += 10) {
        final end = (i + 10 < panierIds.length) ? i + 10 : panierIds.length;
        final batch = panierIds.sublist(i, end);
        
        final reservationsSnapshot = await _firestore
            .collection('Reserver')
            .where('idPanier', whereIn: batch)
            .get();
        
        totalSold += reservationsSnapshot.docs.length;
      }
      
      return totalSold;
    } catch (e) {
      print('Erreur lors du comptage des Qoffas vendus: $e');
      return 0;
    }
  }

  Future<double> getTotalRevenues(String idCommerce) async {
    try {
      // Récupérer d'abord tous les paniers du commerce
      final paniersSnapshot = await _firestore
          .collection('Panier')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      
      // Extraire les IDs des paniers
      List<String> panierIds = paniersSnapshot.docs.map((doc) => doc.id).toList();
      
      // Si aucun panier trouvé, retourner 0
      if (panierIds.isEmpty) {
        return 0;
      }
      
      // Créer une map pour stocker les prix des paniers
      Map<String, double> panierPrices = {};
      
      // Stocker les prix des paniers
      for (var doc in paniersSnapshot.docs) {
        final data = doc.data();
        final prixFinal = (data['prixFinal'] ?? 0).toDouble();
        panierPrices[doc.id] = prixFinal;
      }
      
      // Récupérer les réservations pour ces paniers
      double totalRevenues = 0;
      
      // Pour chaque lot de 10 paniers (limitation de Firestore pour whereIn)
      for (int i = 0; i < panierIds.length; i += 10) {
        final end = (i + 10 < panierIds.length) ? i + 10 : panierIds.length;
        final batch = panierIds.sublist(i, end);
        
        final reservationsSnapshot = await _firestore
            .collection('Reserver')
            .where('idPanier', whereIn: batch)
            .get();
        
        // Additionner les prix des paniers réservés
        for (var doc in reservationsSnapshot.docs) {
          final data = doc.data();
          final panierId = data['idPanier'];
          totalRevenues += panierPrices[panierId] ?? 0;
        }
      }
      
      return totalRevenues;
    } catch (e) {
      print('Erreur lors du calcul des revenus: $e');
      return 0;
    }
  }

  Future<int> getFavouritesCount(String idCommerce) async {
    try {
      final favouritesSnapshot = await _firestore
          .collection('Favoris')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      
      return favouritesSnapshot.docs.length;
    } catch (e) {
      print('Erreur lors du comptage des favoris: $e');
      return 0;
    }
  }

  Future<int> getReviewsCount(String idCommerce) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('Avis')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      
      return reviewsSnapshot.docs.length;
    } catch (e) {
      print('Erreur lors du comptage des avis: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>> getBusinessStatistics(String idCommerce) async {
    try {
      // Exécuter toutes les requêtes en parallèle pour optimiser le temps de chargement
      final qoffasSoldFuture = getQoffasSoldCount(idCommerce);
      final revenuesFuture = getTotalRevenues(idCommerce);
      final favouritesFuture = getFavouritesCount(idCommerce);
      final reviewsFuture = getReviewsCount(idCommerce);
      
      // Attendre que toutes les requêtes soient terminées
      final qoffasSold = await qoffasSoldFuture;
      final revenues = await revenuesFuture;
      final favourites = await favouritesFuture;
      final reviews = await reviewsFuture;
      
      // Retourner les résultats dans une Map
      return {
        'qoffasSold': qoffasSold,
        'revenues': revenues,
        'favouriteOf': favourites,
        'reviews': reviews,
      };
    } catch (e) {
      print('Erreur lors de la récupération des statistiques: $e');
      return {
        'qoffasSold': 0,
        'revenues': 0,
        'favouriteOf': 0,
        'reviews': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getSaleTransactions(String idCommerce) async {
    try {
      // Récupérer d'abord tous les paniers du commerce
      final paniersSnapshot = await _firestore
          .collection('Panier')
          .where('idCommerce', isEqualTo: idCommerce)
          .get();
      
      // Extraire les IDs des paniers et leurs prix
      List<String> panierIds = [];
      Map<String, double> panierPrices = {};
      
      for (var doc in paniersSnapshot.docs) {
        panierIds.add(doc.id);
        final data = doc.data();
        panierPrices[doc.id] = (data['prixFinal'] ?? 0).toDouble();
      }
      
      // Si aucun panier trouvé, retourner une liste vide
      if (panierIds.isEmpty) {
        return [];
      }
      
      List<Map<String, dynamic>> transactions = [];
      
      // Pour chaque lot de 10 paniers (limitation de Firestore pour whereIn)
      for (int i = 0; i < panierIds.length; i += 10) {
        final end = (i + 10 < panierIds.length) ? i + 10 : panierIds.length;
        final batch = panierIds.sublist(i, end);
        
        final reservationsSnapshot = await _firestore
            .collection('Reserver')
            .where('idPanier', whereIn: batch)
            .get();
        
        // Pour chaque réservation, récupérer les détails du client
        for (var doc in reservationsSnapshot.docs) {
          final reservationData = doc.data();
          final clientId = reservationData['idClient'];
          final panierId = reservationData['idPanier'];
          
          // Récupérer les informations du client
          final clientDoc = await _firestore.collection('Utilisateur').doc(clientId).get();
          String clientName = 'Client inconnu';
          
          if (clientDoc.exists) {
            final clientData = clientDoc.data() as Map<String, dynamic>;
            clientName = '${clientData['prenom'] ?? ''} ${clientData['nom'] ?? ''}'.trim();
            if (clientName.isEmpty) {
              clientName = 'Client inconnu';
            }
          }
          
          transactions.add({
            'id': doc.id,
            'name': clientName,
            'date': reservationData['dateReservation'] != null 
                ? (reservationData['dateReservation'] as Timestamp).toDate() 
                : DateTime.now(),
            'amount': '${panierPrices[panierId] ?? 0}DA',
          });
        }
      }
      
      // Trier les transactions par date (du plus récent au plus ancien)
      transactions.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      
      // Formater les dates pour l'affichage
      transactions = transactions.map((transaction) {
        final date = transaction['date'] as DateTime;
        transaction['dateFormatted'] = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        return transaction;
      }).toList();
      
      return transactions;
    } catch (e) {
      print('Erreur lors de la récupération des transactions: $e');
      return [];
    }
  }


  static const String TYPE_ALL = "All Users";
  static const String TYPE_CUSTOMERS = "Customers";
  static const String TYPE_BUSINESSES = "Businesses";
  static const String TYPE_SUSPENDED = "Suspended Accounts"; 

  static List<String> getUserTypes() {
    return [TYPE_ALL, TYPE_CUSTOMERS, TYPE_BUSINESSES, TYPE_SUSPENDED];
  }


  Future<List<Map<String, dynamic>>> fetchAllBusinesses() async {
    try {
      // On récupère les documents de la collection "Commerce"
      final snapshot = await _firestore.collection('Commerce').get();
      print('Nombre de commercants trouvés : ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        // Si aucun utilisateur trouvé, retourner une liste vide
        return [];
      }

      // On transforme chaque document en une Map {name, type}
      return snapshot.docs.map((doc) {
        final nom = doc['nomCommerce'] ?? '';
        final type = doc['categorie'];
        

        return {
          'id': doc.id,
          'name': nom, // Combine prénom + nom
          'type': type, // Prend le typeUtilisateur
  
        };
      }).toList();
    } catch (e) {
      // En cas d'erreur, afficher l'erreur et retourner une liste vide
      print('Erreur lors du chargement des commerces: $e');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchAllUtilisateur() async {
    try {
      final utilisateurSnapshot =
          await _firestore.collection('Utilisateur').get();
      print('Nombre d\'utilisateurs trouvés : ${utilisateurSnapshot.docs.length}');

      if (utilisateurSnapshot.docs.isEmpty) return [];

      List<Map<String, dynamic>> utilisateurs = [];

      // Utilisation d'une boucle classique car on va utiliser `await` à l'intérieur
      for (var doc in utilisateurSnapshot.docs) {
        final data = doc.data();
        final typeUtilisateur = data['typeUtilisateur'] ?? '';
        String name = '';
        String type = '';

        if (typeUtilisateur == 'Client') {
          // Si c'est un client : concaténer prénom + nom
          name = '${data['prenom'] ?? ''} ${data['nom'] ?? ''}';
          type = 'Client';
        } else if (typeUtilisateur == 'Commerce' || typeUtilisateur == 'Commercant' || typeUtilisateur == 'Business') {
          // Aller chercher les données depuis la collection "Commerce"
          final commerceDoc = await _firestore
              .collection('Commerce')
              .doc(doc.id) // On suppose que le document a le même ID
              .get();

          if (commerceDoc.exists) {
            final commerceData = commerceDoc.data()!;
            name = commerceData['nomCommerce'] ?? 'Commerce';
            type = commerceData['categorie'] ?? 'Inconnu';
          } else {
            name = 'Commerce inconnu';
            type = 'Inconnu';
          }
        }

        utilisateurs.add({
          'id': doc.id,
          'name': name.trim(),
          'type': type,
        });
      }

      return utilisateurs;
    } catch (e) {
      print('Erreur lors du chargement des utilisateurs: $e');
      return [];
    }
  }

  // Récupérer les utilisateurs par type
  Future<List<Map<String, dynamic>>> fetchUsersByType(String filterType) async {
    if (filterType == TYPE_ALL) {
      return fetchAllUtilisateur();
    } else if (filterType == TYPE_SUSPENDED) {
      // Nouveau cas pour les comptes suspendus
      return fetchSuspendedBusinesses();
    } else if (filterType == TYPE_BUSINESSES) {
      return fetchAllBusinesses();
    }

    try {
      // Déterminer les types d'utilisateurs à rechercher
      List<String> typesToFetch = [];

      if (filterType == TYPE_CUSTOMERS) {
        typesToFetch = [
          'Client',
          'Custommer',
        ]; // Inclure les variations possibles
      }
      
      // Vérifier si la liste des types à rechercher est vide
      if (typesToFetch.isEmpty) {
        print('Aucun type d\'utilisateur à rechercher pour le filtre: $filterType');
        return [];
      }

      // Requête Firestore avec filtre sur le type d'utilisateur
      final snapshot = await _firestore
          .collection('Utilisateur')
          .where('typeUtilisateur', whereIn: typesToFetch)
          .get();

      print(
        'Nombre d\'utilisateurs de type $filterType trouvés : ${snapshot.docs.length}',
      );

      if (snapshot.docs.isEmpty) {
        return [];
      }

      // Transformer les documents en liste de Maps avec vérification des valeurs nulles
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final prenom = data['prenom'] ?? '';
        final nom = data['nom'] ?? '';
        final type = data['typeUtilisateur'] ?? '';

        return {'id': doc.id, 'name': '$prenom $nom'.trim(), 'type': type};
      }).toList();
    } catch (e) {
      print(
        'Erreur lors du filtrage des utilisateurs par type $filterType: $e',
      );
      return [];
    }
  }

  // Nouvelle méthode pour récupérer les commerces suspendus
  Future<List<Map<String, dynamic>>> fetchSuspendedBusinesses() async {
    try {
      // Récupérer les commerces avec l'état "suspendu"
      final snapshot = await _firestore
          .collection('Commerce')
          .where('etatCompteCommercant', isEqualTo: 'suspended')
          .get();

      print('Nombre de commerces suspendus trouvés : ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        return [];
      }

      // Transformer les documents en liste de Maps
      return snapshot.docs.map((doc) {
        final nom = doc['nomCommerce'] ?? '';
        final categorie = doc['categorie'] ?? '';

        return {
          'id': doc.id,
          'name': nom,
          'type': 'Commerce',
          'categorie': categorie,
        };
      }).toList();
    } catch (e) {
      print('Erreur lors du chargement des commerces suspendus: $e');
      return [];
    }
  }

  // Méthode pour rechercher des utilisateurs par nom
  Future<List<Map<String, dynamic>>> searchUsers(
    String query,
    String filterType,
  ) async {
    try {
      // D'abord, récupérer les utilisateurs selon le filtre de type
      List<Map<String, dynamic>> users = await fetchUsersByType(filterType);

      // Si la requête est vide, retourner tous les utilisateurs du type demandé
      if (query.isEmpty) {
        return users;
      }

      // Filtrer les utilisateurs dont le nom contient la requête (insensible à la casse)
      final lowercaseQuery = query.toLowerCase();
      return users.where((user) {
        final userName = user['name'].toString().toLowerCase();
        return userName.contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      print('Erreur lors de la recherche d\'utilisateurs: $e');
      return [];
    }
  }

  // Méthode pour récupérer les détails d'un utilisateur spécifique
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final doc = await _firestore
          .collection('Utilisateur')
          .doc(userId)
          .get();

      if (!doc.exists) {
        print('Utilisateur non trouvé: $userId');
        return null;
      }

      // Récupérer toutes les données du document
      final data = doc.data() as Map<String, dynamic>;

      // Ajouter l'ID du document
      data['id'] = doc.id;

      return data;
    } catch (e) {
      print('Erreur lors de la récupération des détails de l\'utilisateur: $e');
      return null;
    }
  }

  Future<void> deleteReviewById(String reviewId) async {
    try {
      await _firestore.collection('Avis').doc(reviewId).delete();
      print('Avis supprimé avec succès : $reviewId');
    } catch (e) {
      print('Erreur lors de la suppression de l\'avis : $e');
      rethrow; // utile si tu veux gérer l'erreur dans l'appelant
    }
  }


}
