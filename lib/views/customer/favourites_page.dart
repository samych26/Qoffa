import 'package:flutter/material.dart';
import 'bakery_page.dart';
import 'pastry_page.dart';
import 'restaurant_page.dart';
import 'market_page.dart';
import '../../Controllers/customer/controlFavorit.dart';
import 'aucunFav_page.dart';

class FavoriteShopsPage extends StatefulWidget {
  const FavoriteShopsPage({Key? key}) : super(key: key);

  @override
  State<FavoriteShopsPage> createState() => _FavoriteShopsPageState();
}

class _FavoriteShopsPageState extends State<FavoriteShopsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final FavoritControl _controller = FavoritControl();
  String _selectedType = FavoritControl.restaurant_Type;
  bool _isLoading = true;

  final Color primaryColor = const Color.fromARGB(255, 243, 233, 184);
  int currentIndex = 1;
  List<Map<String, dynamic>> favourites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final FavoritesShops = await _controller.fetchAllFavorites();
      if (FavoritesShops.isEmpty && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AucunFavoritePage()),
        );
        return;
      }

      setState(() {
        favourites = FavoritesShops;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des favoris : $e');
      setState(() {
        favourites = [];
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: _buildFilteredFavoriteCards(),
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

  List<Widget> _buildFilteredFavoriteCards() {
    final List<Map<String, dynamic>> filtered =
        favourites.where((item) {
          final nomCommerce =
              (item['nomCommerce'] ?? '').toString().toLowerCase();
          return nomCommerce.startsWith(_searchQuery);
        }).toList();

    return filtered.map((item) => _buildFavoriteCard(item)).toList();
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item) {
    final String nomCommerce = item['nomCommerce'] as String? ?? 'Nom inconnu';
    final dynamic note = item['note'] ?? 0;

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
                    _buildRatingStars(
                      (note is int) ? note.toDouble() : (note ?? 0).toDouble(),
                    ),
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
          return const Icon(
            Icons.star,
            color: Colors.amber,
            size: 18,
          ); // étoile pleine
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 18,
          ); // demi-étoile
        } else {
          return const Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 18,
          ); // étoile vide
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
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
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
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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
              _buildCategoryButton(
                'assets/images/pastry.png',
                'Pastry',
                PastryPage(),
              ),
              _buildCategoryButton(
                'assets/images/bakery.png',
                'Bakery',
                const BakeryPage(),
              ),
              _buildCategoryButton(
                'assets/images/restaurant.png',
                'Restaurant',
                const RestaurantPage(),
              ),
              _buildCategoryButton(
                'assets/images/market.png',
                'Market',
                const MarketPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String imagePath, String label, Widget page) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(_createRoute(page));
          },
          child: Container(
            width: 82,
            height: 71,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  spreadRadius: -4,
                  blurRadius: 10,
                  offset: Offset(-2, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color.fromARGB(255, 22, 22, 22),
      backgroundColor: primaryColor,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
