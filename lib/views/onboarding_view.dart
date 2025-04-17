import 'package:flutter/material.dart';
import 'package:qoffa/views/login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildFirstPage(),
    );
  }

  Widget _buildFirstPage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image de fond
        Image.asset(
          'assets/images/onboarding1.png',
          fit: BoxFit.cover,
        ),
        // Couche semi-transparente + contenu
        Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texte avec une taille réduite pour éviter un débordement
              Text(
                "Savor\nGood Food.\nSkip the \nWaste!",
                style: TextStyle(
                  fontSize: 48,  // Taille du texte réduite pour éviter un débordement
                  color: Color(0xFF191919),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
                overflow: TextOverflow.ellipsis,  // Gérer le débordement si nécessaire
              ),

              // Un peu d'espace entre le texte et le bouton
              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF191919),
                    padding: EdgeInsets.symmetric(horizontal: 34, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "get started",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SvgPicture.asset(
                        'assets/icons/icon.svg',
                        height: 16.69,
                        width: 20.77,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              )




            ],
          ),
        )
      ],
    );
  }




}
