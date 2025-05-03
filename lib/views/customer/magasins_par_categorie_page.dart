import 'package:flutter/material.dart';
import '../../Controllers/controlCommercant.dart';
import '../../Models/commerce_modele.dart';

class MagasinsParCategoriePage extends StatelessWidget {
  final String categorie;
  final CommercantController _controller = CommercantController();

  MagasinsParCategoriePage({required this.categorie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Commercants: $categorie')),
      body: StreamBuilder<List<Commerce>>(
        stream: _controller.chargerCommercantsParCategorie(categorie),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final commercants = snapshot.data ?? [];

          if (commercants.isEmpty) {
            return Center(child: Text('Aucun commerçant trouvé'));
          }

          return ListView.builder(
            itemCount: commercants.length,
            itemBuilder: (context, index) {
              final commercant = commercants[index];
              return ExpansionTile(
                title: Text(commercant.nomCommerce),
                subtitle: Text(commercant.adresseCommerce),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Téléphone: ${commercant.numTelCommerce}'),
                        SizedBox(height: 4),
                        Text('Horaires: ${commercant.horaires}'),
                        SizedBox(height: 4),
                        Text('Description: ${commercant.description}'),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}