class Panier {
  int _idPanier;
  String _photoPanier;
  double _prixInitial;
  double _prixFinal;
  DateTime _heureCreation;
  String _description;

  Panier(this._idPanier, this._photoPanier, this._prixInitial, this._prixFinal, this._heureCreation, this._description);

  
  int get idPanier => _idPanier;
  String get photoPanier => _photoPanier;
  double get prixInitial => _prixInitial;
  double get prixFinal => _prixFinal;
  DateTime get heureCreation => _heureCreation;
  String get description => _description;


  set idPanier(int value) => _idPanier = value;
  set photoPanier(String value) => _photoPanier = value;
  set prixInitial(double value) => _prixInitial = value;
  set prixFinal(double value) => _prixFinal = value;
  set heureCreation(DateTime value) => _heureCreation = value;
  set description(String value) => _description = value;
}
