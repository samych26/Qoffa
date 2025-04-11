import 'package:flutter/material.dart';
import 'customer/login_customer.dart';
import 'business/login_business.dart';
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
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildFirstPage(),
          _buildSecondPage(),
        ],
      ),
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
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
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


  Widget _buildSecondPage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image de fond
        Image.asset(
          'assets/images/bg_splash.png',
          fit: BoxFit.cover,
        ),
        // Overlay + contenu
        Container(
          color: Color(0xFFD3FF56).withOpacity(0),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start, // ALIGNER À GAUCHE
            children: [
              Text(
                "Tell us who you are!",
                style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFFD3FF56),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),
              Text(
                "Choose your profile to get started.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFD3FF56),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 40),
              // Bouton Customer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => CustomerLoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD3FF56),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Customer", style: TextStyle(fontSize: 16)),
                      SvgPicture.asset(
                        'assets/icons/iconCustomer.svg',
                        height: 28.71,
                        width: 19,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Bouton Business
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => BusinessLoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD3FF56),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Business", style: TextStyle(fontSize: 16)),
                      SvgPicture.asset(
                        'assets/icons/iconBusiness.svg',
                        height: 23.5,
                        width: 24,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
