import 'Interaction.dart';
class Avis extends Interaction {
  int note;

  Avis(super.idInteraction, super.contenuInteraction, super.dateInteraction, super.idRecepteur,
       super.typeInteraction, this.note);


  int get getNote => note;
  set setNote(int value) => note = value;
}

