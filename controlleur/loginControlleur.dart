import '../modele/login.dart';

class ControleurConnexion {
  final String identifiant;
  final String motDePasse;
  final ModeleConnexion _modele = ModeleConnexion();

  ControleurConnexion({required this.identifiant, required this.motDePasse});

  // Méthode asynchrone pour vérifier la connexion
  Future<void> verifierConnexion() async {
    bool estValide = await _modele.authentifier(identifiant, motDePasse);
    if (estValide) {
      print('Connexion réussie');
    } else {
      print('Identifiant ou mot de passe incorrect');
    }
  }
}
