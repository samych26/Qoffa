import 'package:flutter/material.dart';
import 'bakery_page.dart';
import 'restaurant_page.dart';
import 'pastry_page.dart';
import 'favourites_page.dart';
import 'aucunFav_page.dart';
import '../../Controllers/customer/controlFavorit.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  String _searchText = '';
  final FavoritControl _controller = FavoritControl();
  String _selectedType = FavoritControl.restaurant_Type;
  bool _isLoading = true;

  final Color primaryColor = const Color.fromARGB(255, 243, 233, 184);
  int currentIndex = 1;
  List<Map<String, dynamic>> markets = [];

  @override
  void initState() {
    super.initState();
    _loadMarketFavorites();
  }

Future<void> _loadMarketFavorites() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final marketFavorites = await _controller.fetchMarketFavorites();

    if (marketFavorites.isEmpty) {
      // Rediriger vers la page Aucun Favori
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AucunFavoritePage()),
        );
      });
    } else {
      setState(() {
        markets = marketFavorites;
        _isLoading = false;
      });
    }
  } catch (e) {
    print('Erreur lors du chargement des favoris market: $e');
    setState(() {
      markets = [];
      _isLoading = false;
    });
  }
}


  void onTabTapped(int index) {
    if (index == currentIndex) return;
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FavoriteShopsPage()),
      );
    } else if (index == 1) {
      // Déjà sur la page Favorite (PastryPage)
    } else if (index == 2) {
      //  Aller vers la page Cart 
    } else if (index == 3) {
      //  Aller vers la page Profile 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            _buildSearchBar(),
            _buildCategories(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "All Favourites",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : markets.isEmpty
                      ? const Center(
                        child: Text(
                          "Aucun favori de type market trouvé",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                      : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children:
                            markets
                                .where((item) {
                                  final name =
                                      (item['nomCommerce'] ?? '')
                                          .toString()
                                          .toLowerCase();
                                  return name.contains(_searchText);
                                })
                                .map((item) => _buildFavoriteCard(item))
                                .toList(),
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 22, 22, 22),
        backgroundColor: primaryColor,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

   Widget _buildFavoriteCard(Map<String, dynamic> item) {
    final String nomCommerce = item['nomCommerce'] ?? 'Nom inconnu';
    final double note =
        (item['note'] ?? 0).toDouble(); 

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: 351,
        height: 190,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 334.04,
              height: 117,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Icon(Icons.store, size: 50, color: Colors.black54),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nomCommerce,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    _buildRatingStars(note),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double note) {
    int fullStars = note.floor();
    bool hasHalfStar = (note - fullStars) >= 0.5;
    int totalStars = 5;

    return Row(
      children: List.generate(totalStars, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 18);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 18);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 18);
        }
      }),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            "Your Favorite Shops",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
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
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText =
                              value
                                  .toLowerCase(); 
                        });
                      },
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
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoriteShopsPage(),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryButton('assets/images/pastry.png', 'Pastry', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PastryPage()),
                );
              }),
              _buildCategoryButton('assets/images/bakery.png', 'Bakery', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BakeryPage()),
                );
              }),
              _buildCategoryButton(
                'assets/images/restaurant.png',
                'Restaurant',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RestaurantPage()),
                  );
                },
              ),
              _buildCategoryButton(
                'assets/images/marketAnim.png',
                'Market',
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    String imagePath,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
