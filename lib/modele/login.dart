import 'package:cloud_firestore/cloud_firestore.dart';

class LoginModel {
  static Future<Map<String, dynamic>> authentifier(String email, String motDePasse) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final snapshot = await firestore
          .collection('Utilisateur')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return {
          'estValide': false,
          'typeUtilisateur': '',
          'message': 'Aucun utilisateur trouvé.'
        };
      }

      final userData = snapshot.docs.first.data() as Map<String, dynamic>;
      final mdpStocke = userData['motDePasse'];

      if (motDePasse == mdpStocke) {
        return {
          'estValide': true,
          'typeUtilisateur': userData['typeUtilisateur'],
        };
      } else {
        return {
          'estValide': false,
          'typeUtilisateur': '',
          'message': 'Mot de passe incorrect.'
        };
      }
    } catch (e) {
      return {
        'estValide': false,
        'typeUtilisateur': '',
        'message': 'Erreur lors de la connexion : $e',
      };
    }
  }
}
