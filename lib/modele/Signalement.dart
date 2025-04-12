import 'Interaction.dart';
class Signalement extends Interaction {
  String motif;

  Signalement(super.idInteraction, super.contenuInteraction, super.dateInteraction, super.idRecepteur,
       super.typeInteraction, this.motif);


  String get getMotif => motif;
  set setMotif(String value) => motif = value;
}

