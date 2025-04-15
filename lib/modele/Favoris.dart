class Favoris {
  int idFavoris;
  int idClient;
  int idCommercant;

  Favoris(this.idFavoris, this.idClient, this.idCommercant);

  // Getters
  int get getIdFavoris => idFavoris;
  int get getIdClient => idClient;
  int get getIdCommercant => idCommercant;

  // Setters
  set setIdFavoris(int value) => idFavoris = value;
  set setIdClient(int value) => idClient = value;
  set setIdCommercant(int value) => idCommercant = value;

  @override
  String toString() {
    return 'Favoris(idFavoris: $idFavoris, idClient: $idClient, idCommercant: $idCommercant)';
  }
}
