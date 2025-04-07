import 'package:cloud_firestore/cloud_firestore.dart';

class login {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//methode pour que l'utilisateur se connecte à l'application et retourner le type de son compte
  Future<Map<String, dynamic>> authentifier(String email, String motDePasse) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Utilisateur')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        print("Aucun utilisateur trouvé avec cet email.");
        return {'estValide': false, 'typeUtilisateur': ''};
      }

      var userData = snapshot.docs.first.data() as Map<String, dynamic>;
      String mdpStocke = userData['motDePasse'];

      if (motDePasse == mdpStocke) {
        String typeUtilisateur = userData['typeUtilisateur'];
        print("Connexion réussie !");
        return {'estValide': true, 'typeUtilisateur': typeUtilisateur};
      } else {
        print("Mot de passe incorrect.");
        return {'estValide': false, 'typeUtilisateur': ''};
      }
    } catch (e) {
      print("Erreur lors de la connexion : $e");
      return {'estValide': false, 'typeUtilisateur': ''};
    }
  }
// methode pour se deconnecter
  Future<void> deconnecter() async {
    await _auth.signOut();
  }
  
}
