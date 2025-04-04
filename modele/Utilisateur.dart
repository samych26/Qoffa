enum TypeUtilisateur {
  Admin,
  Client,
  Commercant
}


class Utilisateur {
  String nom;
  String prenom;
  String email;
  String motDePasse;
  TypeUtilisateur typeUtilisateur;

  Utilisateur(this.nom, this.prenom, this.email, this.motDePasse, this.typeUtilisateur);


  String get getNom => nom;
  set setNom(String value) => nom = value;

  String get getPrenom => prenom;
  set setPrenom(String value) => prenom = value;

  String get getEmail => email;
  set setEmail(String value) => email = value;

  String get getMotDePasse => motDePasse;
  set setMotDePasse(String value) => motDePasse = value;

  TypeUtilisateur get getTypeUtilisateur => typeUtilisateur;
  set setTypeUtilisateur(TypeUtilisateur value) => typeUtilisateur = value;
}
