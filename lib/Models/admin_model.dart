import 'user_modele.dart';

class Admin extends UtilisateurModele {
  Admin({
    required String idUtilisateur,
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String photoDeProfile,
    required typeUtilisateur,
  }) : super(
          idUtilisateur: idUtilisateur,
          nom: nom,
          prenom: prenom,
          email: email,
          motDePasse: motDePasse,
          photoDeProfile: photoDeProfile,
          typeUtilisateur: 'admin',
        );




  factory Admin.fromMap(String id, Map<String, dynamic> data) {
    return Admin(
      idUtilisateur: id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      motDePasse: data['motDePasse'] ?? '',
      photoDeProfile: data['photoDeProfile'] ?? '',
      typeUtilisateur: data['typeUtilisateur'] ?? '',
    );
  }
  
}
