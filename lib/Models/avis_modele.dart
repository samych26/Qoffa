class Avis {
  final String idAvis;
  final double note;
  final String commentaire;
  final String idClient;
  final String idCommerce;

  Avis({
    required this.idAvis,
    required this.note,
    required this.commentaire,
    required this.idClient,
    required this.idCommerce,
  });

  factory Avis.fromMap(String id, Map<String, dynamic> data) {
    return Avis(
      idAvis: id,
      note: (data['note'] ?? 0).toDouble(),
      commentaire: data['commentaire'] ?? '',
      idClient: data['idClient'] ?? '',
      idCommerce: data['idCommerce'] ?? '',
    );
  }
}
