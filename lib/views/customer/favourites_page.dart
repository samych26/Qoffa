import 'package:flutter/material.dart';

import '../../Controllers/customer/controlFavorit.dart';

class FavoriteShopsPage extends StatefulWidget {
  const FavoriteShopsPage({Key? key}) : super(key: key);

  @override
  State<FavoriteShopsPage> createState() => _FavoriteShopsPageState();
}

class _FavoriteShopsPageState extends State<FavoriteShopsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final FavoritControl _controller = FavoritControl();
  String? _selectedCategory; // Null means "All Favorites"
  bool _isLoading = true;

  final Color primaryColor = const Color.fromARGB(255, 243, 233, 184);
  int currentIndex = 1;
  List<Map<String, dynamic>> favourites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load all favorites initially
  }

  Future<void> _loadFavorites({String? category}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final FavoritesShops = await _controller.fetchAllFavorites(
          category: category); // Pass the category
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

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadFavorites(category: category);
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
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _selectedCategory == null
                    ? "All Favourites"
                    : "${_selectedCategory!} Favourites",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                  child:
                  CircularProgressIndicator()) // Afficher un loader pendant le chargement
                  : favourites.isEmpty
                  ? _buildNoFavoritesMessage() // Afficher le message si la liste est vide
                  : ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0),
                children: _buildFilteredFavoriteCards(), // Afficher les cartes si la liste n'est pas vide
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNoFavoritesMessage() {
    return const Center(
      child: Text(
        "You don't have any favorite shops yet.",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildFilteredFavoriteCards() {
    List<Map<String, dynamic>> filtered = favourites.where((item) {
      final nomCommerce = (item['nomCommerce'] ?? '').toString().toLowerCase();
      final category = (item['categorie'] ?? '').toString().toLowerCase();
      return nomCommerce.startsWith(_searchQuery) &&
          (_selectedCategory == null ||
              category == _selectedCategory!.toLowerCase());
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
  // ... other methods in _FavoriteShopsPageState

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 18));
    }

    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 18));
    }

    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 18));
    }

    return Row(children: stars);
  }



  // ... other methods in _FavoriteShopsPageState

  Widget _buildTopBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Favourite Shops",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 13),
                  _buildCategoryButton(
                    'assets/images/pastry.png',
                    'pastry',
                        () => _onCategorySelected(FavoritControl.pastry_Type),
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryButton(
                    'assets/images/bakery.png',
                    'bakery',
                        () => _onCategorySelected(FavoritControl.bakery_Type),
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryButton(
                    'assets/images/restaurant.png',
                    'restaurant',
                        () => _onCategorySelected(FavoritControl.restaurant_Type),
                  ),
                  const SizedBox(width: 8),
                  _buildCategoryButton(
                    'assets/images/market.png',
                    'market',
                        () => _onCategorySelected(FavoritControl.market_Type),
                  ),
                ],
              ),
            ),
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
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: 'Favourite'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'Cart'),
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

        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}