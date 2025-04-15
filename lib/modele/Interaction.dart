class Interaction {
  int idInteraction;
  String contenuInteraction;
  DateTime dateInteraction;
  int idRecepteur;
  String typeInteraction; 

  Interaction(this.idInteraction, this.contenuInteraction, this.dateInteraction, this.idRecepteur, this.typeInteraction);

  // Getters et Setters
  int get getIdInteraction => idInteraction;
  set setIdInteraction(int value) => idInteraction = value;

  String get getContenuInteraction => contenuInteraction;
  set setContenuInteraction(String value) => contenuInteraction = value;

  DateTime get getDateInteraction => dateInteraction;
  set setDateInteraction(DateTime value) => dateInteraction = value;

  int get getIdRecepteur => idRecepteur;
  set setIdRecepteur(int value) => idRecepteur = value;

  String get getTypeInteraction => typeInteraction;
  set setTypeInteraction(String value) => typeInteraction = value;

  @override
  String toString() {
    return 'Interaction(idInteraction: $idInteraction, contenuInteraction: $contenuInteraction, dateInteraction: $dateInteraction, idRecepteur: $idRecepteur, typeInteraction: $typeInteraction)';
  }
}
