import 'package:flutter/material.dart';
import 'package:qoffa/Models/commerce_modele.dart';
import '../../Controllers/controlCommercant.dart';
import '../../Models/commerce_modele.dart';
import 'Bakery.dart';
import 'Restaurant.dart';
import 'Pastry.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();

}

class _MarketPageState extends State<MarketPage> {
  final Color primaryColor = const Color(0xFFF3E9B8);
  final Color background = Colors.black;

  final CommercantController _controller = CommercantController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Commerce> _allCommercants = [];
  List<Commerce> _filteredCommercants = [];
  bool _showSuggestions = false;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredCommercants = _allCommercants
          .where((c) => c.nomCommerce.toLowerCase().startsWith(value.toLowerCase())
)
          .toList();
      _showSuggestions = value.isNotEmpty;
    });
  }

  void _onSuggestionSelected(Commerce selectedCommercant) {
    int index = _allCommercants.indexWhere((c) => c.idUtilisateur == selectedCommercant.idUtilisateur);

    if (index != -1) {
      // Scroll vers l'élément
      _scrollController.animateTo(
        index * 260.0, // 240 de height + 20 de padding approximatif
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    // Nettoyer la recherche
    setState(() {
      _searchController.clear();
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection('Discover Markets'),
                const SizedBox(height: 12),
                _buildSearchSection(context),
                const SizedBox(height: 20),
                _buildCategoriesSection(context),
                const SizedBox(height: 20),
                _buildShopsSection(context, "market"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildTitleSection(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.grey[500]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.black),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.settings, color: primaryColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: primaryColor),
              onPressed: () {},
            ),
          ],
        ),
        if (_showSuggestions && _filteredCommercants.isNotEmpty)
          Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCommercants.length,
              itemBuilder: (context, index) {
                final commercant = _filteredCommercants[index];
                return ListTile(
                  title: Text(commercant.nomCommerce),
                  onTap: () => _onSuggestionSelected(commercant),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryIconWithImage(context, 'assets/images/pastry.png', 'Pastry'),
            _buildCategoryIconWithImage(context, 'assets/images/bakery.png', 'Bakery', isSelected: true),
            _buildCategoryIconWithImage(context, 'assets/images/restaurant.png', 'Restaurant'),
            _buildCategoryIconWithImage(context, 'assets/images/marketJaune.png', 'Market'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryIconWithImage(BuildContext context, String assetPath, String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (label == 'Bakery') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BakeryPage()));
        } else if (label == 'Restaurant') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantPage()));
        } else if (label == 'Pastry') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PastryPage()));
        }
      },
      child: Column(
        children: [
          Container(
            width: 82,
            height: 71,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6, offset: const Offset(2, 4)),
                BoxShadow(color: Colors.white.withOpacity(0.3), spreadRadius: -4, blurRadius: 10, offset: const Offset(-2, -2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildShopsSection(BuildContext context, String category) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'All Shops',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 12),
      StreamBuilder<List<Commerce>>(
        stream: _controller.chargerCommercantsParCategorie(category),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement", style: TextStyle(color: Colors.white)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          _allCommercants = snapshot.data ?? [];

          // Appliquer la recherche si nécessaire
          final commercantsToDisplay = _showSuggestions
              ? _filteredCommercants
              : _allCommercants;

          // Cas où aucun commerçant ne correspond à la recherche
          if (_showSuggestions && _filteredCommercants.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  "Aucun magasin avec ce nom",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          }

          if (commercantsToDisplay.isEmpty) {
            return const Center(child: Text("Aucun commerce trouvé", style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: commercantsToDisplay.length,
            itemBuilder: (context, index) {
              final commercant = commercantsToDisplay[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildShopCardFromCommercant(commercant),
              );
            },
          );
        },
      ),
    ],
  );
}


  Widget _buildShopCardFromCommercant(Commerce commercant) {
    return Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 233, 184),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.25), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/essentials.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 130,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commercant.nomCommerce,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star_half, color: Colors.amber, size: 16),
                    Icon(Icons.star_border, color: Colors.amber, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 243, 233, 184),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'favourite'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
      ],
      onTap: (index) => _onTabTapped(context, index),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/favourite');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}
