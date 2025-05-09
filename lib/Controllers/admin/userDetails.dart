import '../../Models/client_model.dart';
import '../../Models/commerce_modele.dart';
import '../../services/admin_service.dart';

class UserController {
  final AdminService _service = AdminService();

  String getClientFullName(Client client) {
    return _service.getClientFullName(client);
  }

  Future<Client?> getClientDetails(String idClient) async {
    return await _service.getClientDetails(idClient);
  }

  Future<Commerce?> getBusinessDetails(String idCommerce) async {
    return await _service.getBusinessDetails(idCommerce);
  }

  Future<bool> verifyBusinessAccount(String idCommerce) async {
    return await _service.verifyBusinessAccount(idCommerce);
  }

  Future<bool> rejectBusinessAccount(String idCommerce) async {
    return await _service.rejectBusinessAccount(idCommerce);
  }

  Future<List<Map<String, dynamic>>> getFavouriteShops(String idClient) async {
    return await _service.getFavouriteShops(idClient);
  }

  Future<List<Map<String, dynamic>>> getClientReviews(String idClient) async {
    return await _service.getClientReviews(idClient);
  }

  Future<List<Map<String, dynamic>>> getReservedQoffas(String idClient) async {
    return await _service.getReservedQoffas(idClient);
  }

  Future<Map<String, dynamic>> getBusinessActivityStats(
      String idCommerce) async {
    return await _service.getBusinessActivityStats(idCommerce);
  }

  Future<List<Map<String, dynamic>>> getBusinessTransactions(
      String idCommerce) async {
    return await _service.getBusinessTransactions(idCommerce);
  }

  Future<List<Map<String, dynamic>>> getBusinessReviews(
      String idCommerce) async {
    return await _service.getBusinessReviews(idCommerce);
  }

  Future<bool> suspendBusinessAccount(String idCommerce) async {
    return await _service.suspendBusinessAccount(idCommerce);
  }

  Future<int> getQoffasSoldCount(String idCommerce) async {
    return await _service.getQoffasSoldCount(idCommerce);
  }

  Future<double> getTotalRevenues(String idCommerce) async {
    return await _service.getTotalRevenues(idCommerce);
  }

  Future<int> getFavouritesCount(String idCommerce) async {
    return await _service.getFavouritesCount(idCommerce);
  }

  Future<int> getReviewsCount(String idCommerce) async {
    return await _service.getReviewsCount(idCommerce);
  }

  Future<Map<String, dynamic>> getBusinessStatistics(String idCommerce) async {
    return await _service.getBusinessStatistics(idCommerce);
  }

  Future<List<Map<String, dynamic>>> getSaleTransactions(
      String idCommerce) async {
    return await _service.getSaleTransactions(idCommerce);
  }

  Future<void> deleteReview(String reviewId) async {
    return await _service.deleteReviewById(reviewId);
  }
}
