import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_page.dart';
import 'HomePage.dart';
import 'account_info_view.dart';
import 'confidentiality_view.dart';
import 'order_history_view.dart';
import 'HomePage.dart'; // Assure-toi que cette importation est correcte

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance.collection('Utilisateur').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.brown.withOpacity(0.6),
      backgroundColor: HomePage.primaryColor,
      currentIndex: 3, // active "Profile"
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) => _onTabTapped(context, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191919),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                  child: Text("Erreur lors du chargement", style: TextStyle(color: Colors.white)));
            }

            final userData = snapshot.data!;
            final nom = userData['nom'] ?? 'Nom';
            final prenom = userData['prenom'] ?? 'Prénom';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "$prenom $nom",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildOption(context, "Account information", const AccountInfoView()),
                  const Divider(color: Colors.white24),
                  _buildOption(context, "Confidentiality", const ConfidentialityView()),
                  const Divider(color: Colors.white24),
                  _buildOption(context, "Order History", const OrderHistoryView()),
                  const Divider(color: Colors.white24),
                  _buildOptionlogout(context, "Logout", const LoginPage()),
                  const Divider(color: Colors.white24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }
  Widget _buildOptionlogout(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.red)),
      trailing: const Icon(Icons.logout, color: Colors.red),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }
}
