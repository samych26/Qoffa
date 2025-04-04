enum TypeInteraction {
  signalement,  
  avis,         
  messagePrive 
}

class Interaction {
  int idInteraction;
  String contenuInteraction;
  DateTime dateInteraction;
  int idRecepteur;
  TypeInteraction typeInteraction;

  Interaction(this.idInteraction, this.contenuInteraction, this.dateInteraction, this.idRecepteur, this.typeInteraction);

  int get getIdInteraction => idInteraction;
  set setIdInteraction(int value) => idInteraction = value;

  String get getContenuInteraction => contenuInteraction;
  set setContenuInteraction(String value) => contenuInteraction = value;

  DateTime get getDateInteraction => dateInteraction;
  set setDateInteraction(DateTime value) => dateInteraction = value;

  int get getIdRecepteur => idRecepteur;
  set setIdRecepteur(int value) => idRecepteur = value;

  TypeInteraction get getTypeInteraction => typeInteraction;
  set setTypeInteraction(TypeInteraction value) => typeInteraction = value;
}
