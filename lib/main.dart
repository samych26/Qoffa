import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core
import 'views/business/BusinessHomeView.dart';
import 'views/customer/HomePage.dart';
import 'views/onboarding_view.dart';
import 'views/login_page.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/customer/signup_controller.dart';
import 'controllers/business/business_signup_controller.dart';
import 'firebase_options.dart';
import 'services/PanierService.dart';
import 'Controllers/controlCommercant.dart';
import 'Controllers/customer/PanierController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => SignUpController()),
        ChangeNotifierProvider(create: (_) => BusinessSignUpController()),
        ChangeNotifierProvider<PanierController>(
          create: (context) => PanierController(PanierService()),
        ),
        Provider<CommercantController>(
          create: (context) => CommercantController(),
        ),
      ],
      child: QoffaApp(),
    ),
  );
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
      initialRoute: '/',  // Point de départ, la route initiale
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginPage(),
        // Ajoutez toutes les autres pages de l'application
        '/HomePage': (context) => HomePage(idUtilisateur: '', ),
        '/business_home': (context) => BusinessHomeView(idUtilisateur: '',),
        // '/admin_home': (context) => AdminHomePage(),
      },
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

    if (firstLaunch) {
      prefs.setBool('firstLaunch', false);
      Navigator.pushReplacementNamed(
        context,
        '/onboarding',  // Utilisez la route définie pour l'onboarding
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/login',  // Utilisez la route définie pour la page de login
      );
    }
  }

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
