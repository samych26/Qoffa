import 'Interaction.dart';
class MessagePrive extends Interaction {
  bool lu;

  MessagePrive(int idInteraction, String contenuInteraction, DateTime dateInteraction, int idRecepteur,
      TypeInteraction typeInteraction, this.lu)
      : super(idInteraction, contenuInteraction, dateInteraction, idRecepteur, typeInteraction);


  bool get getLu => lu;
  set setLu(bool value) => lu = value;
}
