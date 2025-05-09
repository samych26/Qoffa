import 'package:flutter/material.dart';
import '../../services/admin_service.dart';

class DashboardController {
  final AdminService _service = AdminService();

  Future<int> getNombreUtilisateurs() async {
    return await _service.getNombreUtilisateurs();
  }

  Future<int> getNombreCommercant() async {
    return await _service.getNombreCommercant();
  }

  Future<int> getNombreClient() async {
    return await _service.getNombreClient();
  }

  Future<int> getTotalSales() async {
    return await _service.getTotalSales();
  }

  Future<List<Map<String, dynamic>>> getListeCommerces() async {
    return await _service.getListeCommerces();
  }

  Color getStatusColor(String status) {
    return _service.getStatusColor(status);
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query, String filterType) async {
    return await _service.searchUsers(query, filterType);
  }


}
