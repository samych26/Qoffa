import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Orderdetails extends StatelessWidget {
  final String clientId;

  Orderdetails({required this.clientId});

  Future<Map<String, dynamic>> fetchClientDetails() async {
    final clientDoc = await FirebaseFirestore.instance
        .collection('Utilisateur')
        .doc(clientId)
        .get();
    return clientDoc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du client'),
        backgroundColor: const Color(0xFF333333),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchClientDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Client introuvable.'));
          }

          final client = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nom : ${client['nom']} ${client['prenom']}'),
                SizedBox(height: 10),
                Text('Email : ${client['email']}'),
                SizedBox(height: 10),
                Text('Numéro de téléphone : ${client['numTelClient']}'),
                // Ajoute d'autres détails ici si nécessaire
              ],
            ),
          );
        },
      ),
    );
  }
}
