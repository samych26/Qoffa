import '../../services/admin_service.dart';



class UserManagementController {
  // Types d'utilisateurs pour le filtrage
  static const String TYPE_ALL = AdminService.TYPE_ALL;
  static const String TYPE_CUSTOMERS = AdminService.TYPE_CUSTOMERS;
  static const String TYPE_BUSINESSES = AdminService.TYPE_BUSINESSES;
  static const String TYPE_SUSPENDED = AdminService.TYPE_SUSPENDED; // Nouveau type

  final AdminService _service = AdminService();

  // Liste des types d'utilisateurs pour le dropdown
  static List<String> getUserTypes() {
    return AdminService.getUserTypes();
  }

  Future<List<Map<String, dynamic>>> fetchAllBusinesses() async {
    return await _service.fetchAllBusinesses();
  }

  Future<List<Map<String, dynamic>>> fetchAllUtilisateur() async {
    return await _service.fetchAllUtilisateur();
  }

  Future<List<Map<String, dynamic>>> fetchUsersByType(String filterType) async {
    return await _service.fetchUsersByType(filterType);
  }

  // Méthode pour rechercher des utilisateurs par nom
  Future<List<Map<String, dynamic>>> searchUsers(
    String query,
    String filterType,
  ) async {
    return await _service.searchUsers(query, filterType);
  }

  // Méthode pour récupérer les détails d'un utilisateur spécifique
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    return await _service.getUserDetails(userId);
  }
}
