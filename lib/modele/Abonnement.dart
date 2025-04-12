enum TypeAbonnement {
  journalier,   
  hebdomadaire, 
  mensuel,      
  trimestriel,  
  annuel      
}

class Abonnement {
  int idAbonnement;
  String commercant;
  double prix;
  TypeAbonnement duree;
  String details;
  DateTime dateDebut;
  DateTime dateFin;

  Abonnement(this.idAbonnement, this.commercant, this.prix, this.duree, this.details, this.dateDebut, this.dateFin);

  int get getIdAbonnement => idAbonnement;
  set setIdAbonnement(int value) => idAbonnement = value;

  String get getCommercant => commercant;
  set setCommercant(String value) => commercant = value;

  double get getPrix => prix;
  set setPrix(double value) => prix = value;

  TypeAbonnement get getDuree => duree;
  set setDuree(TypeAbonnement value) => duree = value;

  String get getDetails => details;
  set setDetails(String value) => details = value;

  DateTime get getDateDebut => dateDebut;
  set setDateDebut(DateTime value) => dateDebut = value;

  DateTime get getDateFin => dateFin;
  set setDateFin(DateTime value) => dateFin = value;
}
