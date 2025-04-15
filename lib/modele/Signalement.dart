import 'Interaction.dart';

class Signalement extends Interaction {
  String motif;

  Signalement(
    super.idInteraction, 
    super.contenuInteraction, 
    super.dateInteraction, 
    super.idRecepteur,
    super.typeInteraction, 
    this.motif
  );


  String get getMotif => motif;
  set setMotif(String value) => motif = value;


  int get getIdInteraction => super.idInteraction;
  set setIdInteraction(int value) => super.idInteraction = value;

  String get getContenuInteraction => super.contenuInteraction;
  set setContenuInteraction(String value) => super.contenuInteraction = value;

  DateTime get getDateInteraction => super.dateInteraction;
  set setDateInteraction(DateTime value) => super.dateInteraction = value;

  int get getIdRecepteur => super.idRecepteur;
  set setIdRecepteur(int value) => super.idRecepteur = value;

  String get getTypeInteraction => super.typeInteraction;
  set setTypeInteraction(String value) => super.typeInteraction = value;
}
