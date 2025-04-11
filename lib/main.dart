import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/onboarding_view.dart';
import 'views/customer/login_customer.dart';
import 'views/business/login_business.dart';

void main() {
  runApp(QoffaApp());
}

class QoffaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qoffa',
      theme: ThemeData(
        primaryColor: Color(0xFFD6EE8F),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(Duration(seconds: 5));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch') ?? true;
    String? userType = prefs.getString('userType');

    if (firstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      if (userType == "Business") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BusinessLoginPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerLoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Image.asset(
            'assets/images/bg_splash.png',
            fit: BoxFit.cover,
          ),

          // Logo centré
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 204.3,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }

}
