import '../modele/login.dart';

class Controleurlogin {
  final String identifiant;
  final String motDePasse;
  final login _modele = login();

  Controleurlogin({required this.identifiant, required this.motDePasse});

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
