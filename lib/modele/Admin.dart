import 'Utilisateur.dart';

class Administrateur extends Utilisateur {
  static int dernierId = 0;

  int idAdmin;


  Administrateur(
      super.nom,
      super.prenom,
      super.email,
      super.motDePasse,
      super.typeUtilisateur,
      this.idAdmin)
      ; 
 

}
