import 'Interaction.dart';
class Avis extends Interaction {
  int note;

  Avis(int idInteraction, String contenuInteraction, DateTime dateInteraction, int idRecepteur,
       TypeInteraction typeInteraction, this.note)
      : super(idInteraction, contenuInteraction, dateInteraction, idRecepteur, typeInteraction);


  int get getNote => note;
  set setNote(int value) => note = value;
}

