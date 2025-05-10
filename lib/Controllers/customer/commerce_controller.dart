import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qoffa/Models/commerce_modele.dart';
import 'package:qoffa/Models/avis_modele.dart';
import 'package:qoffa/Models/panier_modele.dart';

class CommerceController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   FirebaseFirestore get firestore => _firestore;
  final String commerceId;
  final String userId;

  CommerceController({required this.commerceId, required this.userId});

  // Récupérer les données du commerce
  Future<Commerce?> getCommerceDetails() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Commerce').doc(commerceId).get();
      if (doc.exists) {
        return Commerce.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint("Erreur récupération commerce: $e");
      return null;
    }
  }

  // Récupérer les paniers du commerce
  Future<List<Panier>> getPaniers() async {
    try {
      QuerySnapshot query = await _firestore.collection('Panier')
          .where('idUtilisateur', isEqualTo: commerceId)
          .where('estDisponible', isEqualTo: true)
          .get();
      
      return query.docs.map((doc) => Panier.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint("Erreur récupération paniers: $e");
      return [];
    }
  }

  // Récupérer les avis du commerce
  Future<List<Avis>> getAvis() async {
    try {
      QuerySnapshot query = await _firestore.collection('Avis')
          .where('idCommerce', isEqualTo: commerceId)
          .get();
      
      return query.docs.map((doc) => Avis.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint("Erreur récupération avis: $e");
      return [];
    }
  }

  // Vérifier si le commerce est dans les favoris
  Future<bool> isFavorite() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Favoris')
          .doc('${userId}_$commerceId')
          .get();
      return doc.exists;
    } catch (e) {
      debugPrint("Erreur vérification favori: $e");
      return false;
    }
  }

  // Ajouter/retirer des favoris
  Future<void> toggleFavorite(bool isCurrentlyFavorite) async {
    try {
      if (isCurrentlyFavorite) {
        await _firestore.collection('Favoris').doc('${userId}_$commerceId').delete();
      } else {
        await _firestore.collection('Favoris').doc('${userId}_$commerceId').set({
          'idUtilisateur': userId,  
          'idCommerce': commerceId,  
        });
      }
    } catch (e) {
      debugPrint("Erreur modification favori: $e");
    }
  }

  // Soumettre un avis
  Future<void> submitReview(double rating, String comment) async {
    try {
      await _firestore.collection('Avis').add({
        'note': rating,
        'commentaire': comment,
        'idUtilisateur': userId, 
        'idCommerce': commerceId,
      });
      // Mettre à jour la note moyenne du commerce
      await _updateCommerceRating(rating);
    } catch (e) {
      debugPrint("Erreur soumission avis: $e");
    }
  }

  // Mettre à jour la note moyenne du commerce
  Future<void> _updateCommerceRating(double newRating) async {
    try {
      DocumentReference commerceRef = _firestore.collection('Utilisateur').doc(commerceId);
      
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(commerceRef);
        
        if (snapshot.exists) {
          double currentNote = (snapshot.data() as Map<String, dynamic>)['note'] ?? 0.0;
          int nbNotes = (snapshot.data() as Map<String, dynamic>)['nbNotes'] ?? 0;
          
          double newNote = ((currentNote * nbNotes) + newRating) / (nbNotes + 1);
          
          transaction.update(commerceRef, {
            'note': newNote,
            'nbNotes': nbNotes + 1,
          });
        }
      });
    } catch (e) {
      debugPrint("Erreur mise à jour note commerce: $e");
    }
  }

  // Vérifier l'état d'ouverture du commerce
  String getOpeningStatus(Commerce commerce, BuildContext context) {
  try {
    final now = TimeOfDay.now();
    final hours = commerce.horaires.split(' - ');
    
    if (hours.length == 2) {
      final openTime = _parseTime(hours[0]);
      final closeTime = _parseTime(hours[1]);
      
      if (openTime != null && closeTime != null) {
        if (now.hour > openTime.hour || (now.hour == openTime.hour && now.minute >= openTime.minute)) {
          if (now.hour < closeTime.hour || (now.hour == closeTime.hour && now.minute < closeTime.minute)) {
            return 'Open now - Closes at ${closeTime.format(context)}'; // Utilisez context directement
          }
        }
        return 'Closed now - Opens at ${openTime.format(context)}';
      }
    }
    return 'Hours not available';
  } catch (e) {
    debugPrint("Erreur vérification horaires: $e");
    return 'Hours not available';
  }
}

  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.replaceAll('#', '').split(RegExp(r'[a|p]m'));
      if (parts.length >= 1) {
        final timeParts = parts[0].trim().split(':');
        if (timeParts.length == 2) {
          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);
          
          if (timeString.toLowerCase().contains('pm') && hour < 12) {
            hour += 12;
          } else if (timeString.toLowerCase().contains('am') && hour == 12) {
            hour = 0;
          }
          
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
      return null;
    } catch (e) {
      debugPrint("Erreur parsing time: $e");
      return null;
    }
  }
}