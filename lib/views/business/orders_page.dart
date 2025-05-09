import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'BusinessHomeView.dart';
import 'OrderDetails.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final reservations = await FirebaseFirestore.instance.collection('Reserver').get();
    List<Map<String, dynamic>> orders = [];

    for (var res in reservations.docs) {
      final data = res.data();
      if (data['dateReservation'] == null) continue;

      final clientId = data['idClient'];
      final panierId = data['idPanier'];

      final userDoc = await FirebaseFirestore.instance.collection('Utilisateur').doc(clientId).get();
      final panierDoc = await FirebaseFirestore.instance.collection('Panier').doc(panierId).get();

      String nom = '';
      String prenom = '';

      if (userDoc.exists) {
        final userData = userDoc.data();
        nom = userData?['nom'] ?? '';
        prenom = userData?['prenom'] ?? '';
        print('Client trouvé: $prenom $nom'); // Debug
      } else {
        print('Utilisateur non trouvé pour ID: $clientId');
      }

      orders.add({
        'nom': nom,
        'prenom': prenom,
        'dateReservation': data['dateReservation'],
        'prixFinal': panierDoc.data()?['prixFinal'],
      });
    }

    return orders;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(

        title: const Text(
          'Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF333333),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aucune réservation trouvée.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 96),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final date = (order['dateReservation'] as Timestamp).toDate();

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom et prénom du client avec la flèche de navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${order['prenom'] ?? 'Prénom inconnu'} ${order['nom'] ?? 'Nom inconnu'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                          onPressed: () {
                            // Vérification si 'idClient' existe dans 'order'
                            if (order.containsKey('idClient') && order['idClient'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Orderdetails(clientId: order['idClient']),
                                ),
                              );
                            } else {
                              // Gérer le cas où 'idClient' est null ou inexistant
                              print('ID du client non disponible.');
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Réservé le : ${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Prix : ${order['prixFinal']} €',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );


            },
          );

        },
      ),
    );
  }
}
