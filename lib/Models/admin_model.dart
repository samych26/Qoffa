<<<<<<< HEAD

=======
>>>>>>> 85e60e86762bcf4d654f7f22ac1aa28f43900f60
import 'user_modele.dart';

class Admin extends UtilisateurModele {
  Admin({
    required String idUtilisateur,
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String photoDeProfile,
<<<<<<< HEAD
=======
    required typeUtilisateur,
>>>>>>> 85e60e86762bcf4d654f7f22ac1aa28f43900f60
  }) : super(
          idUtilisateur: idUtilisateur,
          nom: nom,
          prenom: prenom,
          email: email,
          motDePasse: motDePasse,
          photoDeProfile: photoDeProfile,
          typeUtilisateur: 'admin',
        );
<<<<<<< HEAD
=======




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
  
>>>>>>> 85e60e86762bcf4d654f7f22ac1aa28f43900f60
}
