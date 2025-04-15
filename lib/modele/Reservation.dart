class Reservation {
  int idReservation;
  DateTime dateReservation;
  String statut; // Valeurs possibles : "confirme", "annule", "termine"
  String codeRecuperation;

  Reservation(this.idReservation, this.dateReservation, this.statut, this.codeRecuperation);

  // Getters et Setters
  int get getIdReservation => idReservation;
  set setIdReservation(int value) => idReservation = value;

  DateTime get getDateReservation => dateReservation;
  set setDateReservation(DateTime value) => dateReservation = value;

  String get getStatut => statut; // Valeurs possibles : "confirme", "annule", "termine"
  set setStatut(String value) => statut = value;

  String get getCodeRecuperation => codeRecuperation;
  set setCodeRecuperation(String value) => codeRecuperation = value;

  @override
  String toString() {
    return 'Reservation(idReservation: $idReservation, dateReservation: $dateReservation, statut: $statut, codeRecuperation: $codeRecuperation)';
  }
}
