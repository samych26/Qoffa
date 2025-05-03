import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardController {
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
      case 'actif':
      case 'verified':
        return Colors.green.shade400;
      case 'in progress':
        return Colors.purple.shade400;
      case 'pending':
        return Colors.blue.shade500;
      case 'suspendu':
        return Colors.amber.shade500;
      case 'bloque':
      case 'rejected' :
        return Colors.red.shade600;
      default:
        return Colors.grey.shade400;
    }
  }

 
}
