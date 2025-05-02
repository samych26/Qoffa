import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qoffa/controllers/commerce_controller.dart';
import 'package:qoffa/Models/commerçant_model.dart';
import 'package:qoffa/Models/panier_model.dart';
import 'package:qoffa/Models/avis_model.dart';

class CommerceView extends StatefulWidget {
  final String commerceId;
  final String userId;

  const CommerceView({Key? key, required this.commerceId, required this.userId}) : super(key: key);

  @override
  _CommerceViewState createState() => _CommerceViewState();
}

class _CommerceViewState extends State<CommerceView> {
  late CommerceController _controller;
  Commerce? _commerce;
  List<Panier> _paniers = [];
  List<Avis> _avis = [];
  bool _isFavorite = false;
  double _reviewRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = true;
   int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = CommerceController(commerceId: widget.commerceId, userId: widget.userId);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final commerce = await _controller.getCommerceDetails();
    final paniers = await _controller.getPaniers();
    final avis = await _controller.getAvis();
    final isFavorite = await _controller.isFavorite();
    setState(() {
      _commerce = commerce;
      _paniers = paniers;
      _avis = avis;
      _isFavorite = isFavorite;
      _isLoading = false;
    });
  }
   // Méthode pour gérer la navigation
  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    
    setState(() => _currentIndex = index);
    
    switch(index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '', (route) => false);
        break;
      case 1:
        Navigator.pushNamed(context, '');
        break;
      case 2:
        Navigator.pushNamed(context, '');
        break;
      case 3:
        Navigator.pushNamed(context, '');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color beige = const Color(0xFFF7EBAF);
    final Color orange = const Color(0xFFFFA500);
    final Color black = const Color(0xFF000000);
    final Color white = const Color(0xFFFFFFFF);
    final Color lightGrey = const Color.fromARGB(255, 163, 163, 163);

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title: Text(
          _commerce?.nomCommerce ?? 'Loading...',
          style: TextStyle(color: white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : beige,
            ),
            onPressed: () async {
              await _controller.toggleFavorite(_isFavorite);
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: white))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 60,
                         
                          backgroundImage: _commerce?.photoDeProfile != null 
                              ? NetworkImage(_commerce!.photoDeProfile) 
                              : null,
                          child: _commerce?.photoDeProfile == null 
                              ? Icon(Icons.person, size: 50,)
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _commerce?.nomCommerce ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              _commerce?.categorie ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.star, color: white, size: 16),
                            Text(
                              ' ${_commerce?.note.toStringAsFixed(1) ?? '0.0'}',
                              style: TextStyle(color: white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _commerce != null 
                              ? _controller.getOpeningStatus(_commerce!, context)
                              : 'Hours not available',
                          style: TextStyle(color: white),
                        ),
                        const SizedBox(height: 20),

                        // Adresse
                        Row(
                          children: [
                            Icon(Icons.location_on, color: white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _commerce?.adresseCommerce ?? '',
                              style: TextStyle(color: white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(Icons.access_time, color: white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _commerce?.horaires ?? '',
                              style: TextStyle(color: white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey),

                  // Section paniers
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      'panier disponibles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _paniers.length,
                      itemBuilder: (context, index) {
                        final panier = _paniers[index];
                        return Container(
                          width: 180,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: beige,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    child: Image.network(
                                      panier.photoPanier,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: 120,
                                        color: Colors.grey,
                                        child: Icon(Icons.shopping_basket,
                                            color: black),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${panier.prixFinal} DA',
                                        style: TextStyle(
                                          color: beige,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      panier.description.length > 30
                                          ? '${panier.description.substring(0, 30)}...'
                                          : panier.description,
                                      style: TextStyle(color: black),
                                    ),
                                    if (panier.description.length > 30)
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Read more',
                                          style: TextStyle(
                                            color: orange,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Initial price: ${panier.prixInitial} DA',
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: orange,
                                          foregroundColor: black,
                                        ),
                                        onPressed: () {},
                                        child: const Text('Reserve now'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(color: Color.fromARGB(255, 186, 185, 185)),

                  // Section "Write a Review"
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write a Review',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < _reviewRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: orange,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _reviewRating = index + 1.0;
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _reviewController,
                            decoration: InputDecoration(
                              hintText: 'Share your experience...',
                              hintStyle: TextStyle(color: white.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: beige),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: beige),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: TextStyle(color: white),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.edit), 
                              label: Text('Submit review'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: beige,
                                foregroundColor: black,
                              ),
                              onPressed: () async {
                                if (_reviewRating > 0 && _reviewController.text.isNotEmpty) {
                                  await _controller.submitReview(
                                    _reviewRating,
                                    _reviewController.text,
                                  );
                                  _reviewController.clear();
                                  setState(() => _reviewRating = 0);
                                  await _loadData();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Section avis
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Reviews',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_avis.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No reviews yet',
                              style: TextStyle(color: white),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _avis.length,
                            itemBuilder: (context, index) {
                              final avis = _avis[index];
                              return FutureBuilder<DocumentSnapshot>(
                                future: _controller.firestore
                                    .collection('Utilisateur')
                                    .doc(avis.idClient)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const SizedBox();
                                  }
                                  
                                  final clientData = snapshot.data?.data() as Map<String, dynamic>?;
                                  final clientName = clientData != null 
                                      ? '${clientData['prenom']} ${clientData['nom']}'
                                      : 'Anonymous';
                                  final clientPhoto = clientData?['photoDeProfile'];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: clientPhoto != null
                                                  ? NetworkImage(clientPhoto)
                                                  : null,
                                              child: clientPhoto == null
                                                  ? Icon(Icons.person, color: beige)
                                                  : null,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              clientName,
                                              style: TextStyle(
                                                color: beige,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: List.generate(5, (starIndex) {
                                            return Icon(
                                              starIndex < avis.note
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: orange,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          avis.commentaire,
                                          style: TextStyle(color: beige),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: beige,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: black,
          unselectedItemColor: black.withOpacity(0.6),
          selectedIconTheme: IconThemeData(
            color: black,
            opacity: 1.0,
            size: 24,
          ),
          unselectedIconTheme: IconThemeData(
            color: black.withOpacity(0.6),
            opacity: 0.6,
            size: 24,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border),
              activeIcon: Icon(Icons.star),
              label: 'Favoris',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Panier',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}