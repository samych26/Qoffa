import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Bloque explicitement le support web
    if (kIsWeb) {
      throw UnsupportedError(
        'Cette application ne supporte pas la plateforme web.',
      );
    }

    // Seul Android est supporté
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }

    // Toutes autres plateformes sont bloquées
    throw UnsupportedError(
      'Cette application ne supporte que la plateforme Android.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDdJdF0euj8ZbrUxJnZzAuhW2-MjGgDHs', // Votre clé API réelle
    appId: '1:798057441057:android:a680c1393c772de6a40060', // Votre App ID
    messagingSenderId: '798057441057', // Votre Sender ID
    projectId: 'qoffa-e07be', // Votre Project ID
    storageBucket: '', // Important pour le stockage
    
  );
}