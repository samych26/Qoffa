// lib/Controllers/customer/PanierController.dart

import 'package:flutter/material.dart';
import '../../services/PanierService.dart';
import '../../Models/PanierModel.dart';
import '../../services/serviceCommercant.dart';
import '../../Models/modelCommercant.dart';
import 'package:collection/collection.dart';

class PanierController extends ChangeNotifier {
  final PanierService _panierService;
  final FirestoreService _commercantService = FirestoreService();

  List<Map<String, dynamic>> _paniersDisponiblesAvecNom = [];
  List<Map<String, dynamic>> get paniersDisponiblesAvecNom => _paniersDisponiblesAvecNom;

  String? _error;
  String? get error => _error;

  bool _loading = false;
  bool get loading => _loading;

  PanierController(this._panierService);

  Future<void> loadPaniersDisponibles() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final paniers = await _panierService.getPaniersDisponiblesAujourdhui();
      _paniersDisponiblesAvecNom = [];
      for (final panier in paniers) {
        // Accéder à l'ID du document à partir de la DocumentReference
        final commercantId = panier.idCommercantRef.id;
        print('ID du commerçant associé au panier ${panier.id}: $commercantId');
        final commercant = await _getCommercant(commercantId);
        _paniersDisponiblesAvecNom.add({
          'panier': panier,
          'nomCommercant': commercant?.nomCommerce ?? 'Nom inconnu',
        });
      }
      notifyListeners();
    } catch (e) {
      _error = 'Erreur lors du chargement des paniers d\'aujourd\'hui: $e';
      _paniersDisponiblesAvecNom = [];
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Commercant?> _getCommercant(String? commercantId) async {
    if (commercantId == null) return null;
    try {
      final commercantsStream = _commercantService.getAllCommercants();
      final commercants = await commercantsStream.first;
      print('Liste des commerçants récupérée dans _getCommercant: $commercants');
      final commercantTrouve = commercants.firstWhereOrNull((c) => c.id == commercantId);
      return commercantTrouve;
    } catch (e) {
      print('Erreur lors de la récupération du commerçant: $e');
      return null;
    }
  }
}