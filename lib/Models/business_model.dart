class Business {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String category;
  final String businessName;
  final String phoneNumber;
  final String address;
  final String registrationNumber;
  final String? registrationFilePath;
  final String etatCompte;

  Business({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.category,
    required this.businessName,
    required this.phoneNumber,
    required this.address,
    required this.registrationNumber,
    this.registrationFilePath,
    this.etatCompte = "en attente",
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'category': category,
      'businessName': businessName,
      'phoneNumber': phoneNumber,
      'address': address,
      'registrationNumber': registrationNumber,
      'registrationFilePath': registrationFilePath,
      'etatCompteCommercant': etatCompte,
    };
  }
}
