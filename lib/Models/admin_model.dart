
import 'user_modele.dart';

class Admin extends UtilisateurModele {
  Admin({
    required String idUtilisateur,
    required String nom,
    required String prenom,
    required String email,
    required String motDePasse,
    required String photoDeProfile,
  }) : super(
          idUtilisateur: idUtilisateur,
          nom: nom,
          prenom: prenom,
          email: email,
          motDePasse: motDePasse,
          photoDeProfile: photoDeProfile,
          typeUtilisateur: 'admin',
        );
}
