import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importez le package provider
import 'views/customer/HomePage.dart'; // Chemin d'importation corrigé

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Controllers/customer/PanierController.dart'; // Importez votre PanierController
import 'services/PanierService.dart'; // Importez votre PanierService (si nécessaire pour créer PanierController)
import 'Controllers/controlCommercant.dart'; // Importez votre CommercantController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Erreur lors de l'initialisation de Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qoffa App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<PanierController>(
            create: (context) => PanierController(PanierService()),
          ),
          Provider<CommercantController>( // Utilisez Provider au lieu de ChangeNotifierProvider
            create: (context) => CommercantController(),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}