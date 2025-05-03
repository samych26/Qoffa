import 'package:flutter/material.dart';

class AccountPendingView extends StatelessWidget {
  const AccountPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(
            'assets/images/bg_splash.png',
            fit: BoxFit.cover,
          ),

          // Contenu centré avec fond transparent
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 100, color: Color(0xFFF3E9B5)),
                  const SizedBox(height: 24),
                  const Text(
                    "Votre compte est en attente de validation.",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFFF3E9B5),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Vous recevrez une notification dès qu'un administrateur aura validé votre compte.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF3E9B5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
