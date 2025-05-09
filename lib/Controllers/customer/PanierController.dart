// lib/Controllers/customer/PanierController.dart

import 'package:flutter/material.dart';
import '../../services/PanierService.dart';
import '../../Models/panier_modele.dart'; // Assure-toi que le nom du fichier est correct
import '../../services/serviceCommercant.dart';
import '../../Models/commerce_modele.dart'; // Importe le nouveau modèle Commerce
import 'package:collection/collection.dart';



// lib/Controllers/customer/PanierController.dart
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
      final List<Panier> paniers = await _panierService.getPaniersDisponiblesAujourdhui();
      _paniersDisponiblesAvecNom = [];

      for (final panier in paniers) {
        final String commercantId = panier.idCommercantRef.id;
        print('ID du commerçant associé au panier ${panier.id}: $commercantId'); // Utilise panier.id

        final Commerce? commercant = await _getCommercant(commercantId);

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

  Future<Commerce?> _getCommercant(String commercantId) async {
    try {
      final commercantsStream = _commercantService.getAllCommercants();
      final List<Commerce> commercants = await commercantsStream.first;

      print('Liste des commerçants récupérée dans _getCommercant: $commercants');

      final Commerce? commercantTrouve = commercants.firstWhereOrNull((c) => c.idUtilisateur == commercantId);
      return commercantTrouve;
    } catch (e) {
      print('Erreur lors de la récupération du commerçant: $e');
      return null;
    }
  }
}