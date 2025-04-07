import '../modele/login.dart';

class loginControleur {
  final String identifiant;
  final String motDePasse;
  final login _modele = login();

  // Variables de sortie
  bool estValide = false;
  String typeUtilisateur = '';

  loginControleur({required this.identifiant, required this.motDePasse});

  Future<void> verifierConnexion() async {
    Map<String, dynamic> resultat = await _modele.authentifier(identifiant, motDePasse);

    estValide = resultat['estValide'];
    typeUtilisateur = resultat['typeUtilisateur'];

    if (estValide) {
      print('Connexion réussie');
      print('Type d\'utilisateur : $typeUtilisateur');
    } else {
      print('Identifiant ou mot de passe incorrect');
    }
  }
}
