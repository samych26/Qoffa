import 'Interaction.dart';
class MessagePrive extends Interaction {
  bool lu;

  MessagePrive(super.idInteraction, super.contenuInteraction, super.dateInteraction, super.idRecepteur,
      super.typeInteraction, this.lu);


  bool get getLu => lu;
  set setLu(bool value) => lu = value;
}
