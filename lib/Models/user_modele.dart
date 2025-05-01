class UtilisateurModele {
  final String idUtilisateur;
  final String nom;
  final String prenom;
  final String email;
  final String motDePasse;
  final String photoDeProfile;
  final String typeUtilisateur;

  UtilisateurModele({
    required this.idUtilisateur,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
    required this.photoDeProfile,
    required this.typeUtilisateur,
  });

  factory UtilisateurModele.fromMap(String id, Map<String, dynamic> data) {
    return UtilisateurModele(
      idUtilisateur: id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      motDePasse: data['motDePasse'] ?? '',
      photoDeProfile: data['photoDeProfil'] ?? '',
      typeUtilisateur: data['typeUtilisateur'] ?? '',
    );
  }
}
