import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  final String userType; // Customer ou Business

  LoginView({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login - $userType")),
      body: Center(
        child: Text("Page de connexion pour $userType"),
      ),
    );
  }
}

