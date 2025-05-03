import 'package:flutter/material.dart';
import '../../Controllers/controlCommercant.dart';
import '../../Models/commerce_modele.dart';
import 'Bakery.dart';
import 'Restaurant.dart';
import 'Market.dart';

class PastryPage extends StatefulWidget {
  PastryPage({Key? key}) : super(key: key);

  @override
  State<PastryPage> createState() => _PastryPageState();
}

class _PastryPageState extends State<PastryPage> {
  final Color primaryColor = const Color(0xFFF3E9B8);
  final Color background = Colors.black;

  final CommercantController _controller = CommercantController();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(),
                const SizedBox(height: 12),
                _buildSearchSection(),
                const SizedBox(height: 20),
                _buildCategoriesSection(context),
                const SizedBox(height: 20),
                _buildShopsSection(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildTitleSection() {
    return const Text(
      'Discover Pastry Shops',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
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
                    icon: const Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      _searchController.clear();
                    },
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
            _buildCategoryIconWithImage(context, 'assets/images/pastryJaune.png', 'Pastry'),
            _buildCategoryIconWithImage(context, 'assets/images/bakery.png', 'Bakery', isSelected: true),
            _buildCategoryIconWithImage(context, 'assets/images/restaurant.png', 'Restaurant'),
            _buildCategoryIconWithImage(context, 'assets/images/market.png', 'Market'),
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
        } else if (label == 'Market') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MarketPage()));
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
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  spreadRadius: -4,
                  blurRadius: 10,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildShopsSection(BuildContext context) {
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
          stream: _controller.chargerCommercantsParCategorie("pastry"),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Erreur de chargement", style: TextStyle(color: Colors.white)),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final commercants = snapshot.data ?? [];

            // 🔥 Filtrer les commerçants en fonction de la recherche
            final filteredCommercants = commercants.where((commercant) {
              return commercant.nomCommerce.toLowerCase().contains(_searchText);
            }).toList();

            if (filteredCommercants.isEmpty) {
              return const Center(
                child: Text(
                  "Aucun commerçant avec ce nom",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredCommercants.length,
              itemBuilder: (context, index) {
                final commercant = filteredCommercants[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
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
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/BiteFood.png',
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
      backgroundColor: const Color.fromARGB(255, 243, 233, 181),
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
