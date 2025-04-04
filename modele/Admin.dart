import 'Utilisateur.dart';

class Administrateur extends Utilisateur {
  int idAdmin;

  Administrateur(String nom, String prenom, String email, String motDePasse, TypeUtilisateur typeUtilisateur, this.idAdmin)
      : super(nom, prenom, email, motDePasse, typeUtilisateur);

  int get getIdAdmin => idAdmin;
  set setIdAdmin(int value) => idAdmin = value;
}
