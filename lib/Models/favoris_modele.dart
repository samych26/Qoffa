class Favoris {
  final String idClient;
  final String idCommerce;

  Favoris({
    required this.idClient,
    required this.idCommerce,
  });

  factory Favoris.fromMap(Map<String, dynamic> data) {
    return Favoris(
      idClient: data['idClient'] ?? '',
      idCommerce: data['idCommerce'] ?? '',
    );
  }
}
