import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class AccountInfoController with ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String nom = '';
  String prenom = '';

  Future<void> loadUserData() async {
    final userData = await UserService.fetchUserData();
    if (userData != null) {
      nom = userData['nom'] ?? '';
      prenom = userData['prenom'] ?? '';
      phoneController.text = userData['numTelClient'] ?? '';
      emailController.text = userData['email'] ?? '';
      addressController.text = userData['adresseClient'] ?? '';
      notifyListeners();
    }
  }

  Future<void> updateProfile() async {
    await UserService.updateUserData(
      phone: phoneController.text,
      email: emailController.text,
      address: addressController.text,
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
