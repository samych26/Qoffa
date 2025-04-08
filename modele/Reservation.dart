enum Statut {
  confirme,    
  annule,    
  termine    
}


class Reservation {
  int idReservation;
  DateTime dateReservation;
  Statut statut;
  String codeRecuperation;

  Reservation(this.idReservation, this.dateReservation, this.statut, this.codeRecuperation);

  int get getIdReservation => idReservation;
  set setIdReservation(int value) => idReservation = value;

  DateTime get getDateReservation => dateReservation;
  set setDateReservation(DateTime value) => dateReservation = value;

  Statut get getStatut => statut;
  set setStatut(Statut value) => statut = value;

  String get getCodeRecuperation => codeRecuperation;
  set setCodeRecuperation(String value) => codeRecuperation = value;
}
