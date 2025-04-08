import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir les données d'un utilisateur
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = 
          await _firestore.collection('users').doc(uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      rethrow;
    }
  }

  // Mettre à jour les données utilisateur
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Erreur lors de la mise à jour des données: $e');
      rethrow;
    }
  }

  // Ajouter un nouveau document
  Future<DocumentReference> addDocument(
    String collection, 
    Map<String, dynamic> data
  ) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      print('Erreur lors de l\'ajout du document: $e');
      rethrow;
    }
  }

  // Supprimer un document
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      print('Erreur lors de la suppression du document: $e');
      rethrow;
    }
  }

  // Stream de données en temps réel
  Stream<QuerySnapshot> streamCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  // Stream d'un document spécifique
  Stream<DocumentSnapshot> streamDocument(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }
}