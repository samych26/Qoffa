import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/onboarding_view.dart';
import 'views/login_view.dart';

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
    await Future.delayed(Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch') ?? true;
    String? userType = prefs.getString('userType');

    if (firstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView(userType: userType ?? "Customer")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6EE8F),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 204.3,
          height: 250,
        ),
      ),
    );
  }
}
