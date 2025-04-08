import 'Interaction.dart';
class Signalement extends Interaction {
  String motif;

  Signalement(int idInteraction, String contenuInteraction, DateTime dateInteraction, int idRecepteur,
       TypeInteraction typeInteraction, this.motif)
      : super(idInteraction, contenuInteraction, dateInteraction, idRecepteur, typeInteraction);


  String get getMotif => motif;
  set setMotif(String value) => motif = value;
}

