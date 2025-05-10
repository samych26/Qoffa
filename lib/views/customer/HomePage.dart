import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'commerce_page.dart';
import 'fullMap.dart';
import '../../Models/commerce_modele.dart';
import '../../Controllers/customer/PanierController.dart';
import '../../services/PanierService.dart';
import '../../Models/panier_modele.dart';
import '../../Controllers/controlCommercant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:collection/collection.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class HomePage extends StatefulWidget {
  static const primaryColor = Color(0xFFF3E9B8);
  final String idUtilisateur;
  const HomePage({Key? key, required this.idUtilisateur}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng _mapPosition = LatLng(36.751000, 5.038556);
  LatLng? _userLocation;
  late final MapController _mapController;
  double _mapZoom = 13.0;
  late PanierController _panierController;
  String? _selectedCategory;
  final CommercantController _commercantController = CommercantController();
  TextEditingController _searchController = TextEditingController();
  List<Commerce> _allCommercants = [];
  List<Commerce> _filteredCommercants = [];
  String _searchQuery = '';

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _mapPosition = _userLocation!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _panierController = PanierController(PanierService());
    _panierController.loadPaniersDisponibles();
    _mapController = MapController();
    _searchController = TextEditingController();

    // Charger tous les commerçants
    Provider.of<CommercantController>(context, listen: false)
        .chargerTousLesCommercants()
        .listen((Commerce) {
      setState(() {
        _allCommercants = Commerce;
        _filteredCommercants = Commerce;
      });
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterCommercants(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCommercants = _allCommercants;
      } else {
        _filteredCommercants = _allCommercants.where((Commerce) =>
        Commerce.nomCommerce.toLowerCase().contains(query.toLowerCase()) ||
            (Commerce.adresseCommerce?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }
    });
  }

  Future<List<Marker>> _getCommercantMarkers(List<Commerce> Commerce) async {
    print('_getCommercantMarkers appelé avec ${Commerce.length} commercants');
    List<Marker> markers = [];
    for (var commercant in Commerce) {
      print('Traitement du commerçant: ${commercant.nomCommerce}, adresse: ${commercant.adresseCommerce}');
      if (commercant.adresseCommerce != null && commercant.adresseCommerce.isNotEmpty) {
        try {
          print('Géocodage de l\'adresse: ${commercant.adresseCommerce}');

          // Correction ici - Utilisation de ?. et vérification de null
          final geocoding = GeocodingPlatform.instance;
          if (geocoding == null) {
            print('GeocodingPlatform.instance est null');
            continue;
          }

          List<Location> locations = await geocoding.locationFromAddress(commercant.adresseCommerce);

          print('Résultat du géocodage pour ${commercant.nomCommerce}: ${locations.length} résultats');
          if (locations.isNotEmpty) {
            final location = locations.first;
            print('Coordonnées trouvées pour ${commercant.nomCommerce}: Lat=${location.latitude}, Lng=${location.longitude}');
            markers.add(
              Marker(
                width: 120.0,
                height: 80.0,
                point: LatLng(location.latitude, location.longitude),
                child: GestureDetector(
                  onTap: () {
                    print('Marqueur du commerçant ${commercant.nomCommerce} cliqué');
                  },
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            commercant.nomCommerce,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 20,
                        child: Icon(Icons.location_on, color: Colors.red, size: 30),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            print('Aucune coordonnée trouvée pour ${commercant.nomCommerce}');
          }
        } catch (e) {
          print('Erreur de géocodage pour ${commercant.nomCommerce}: $e');
        }
      } else {
        print('L\'adresse du commerçant ${commercant.nomCommerce} est nulle ou vide.');
      }
    }
    print('_getCommercantMarkers terminé, ${markers.length} marqueurs créés.');
    return markers;
  }

  Widget _buildMapSection(List<Marker> markers) {
    List<Marker> allMarkers = [...markers];
    if (_userLocation != null) {
      allMarkers.add(
        Marker(
          width: 120.0,
          height: 50.0,
          point: _userLocation!,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Text(
                  "Vous êtes ici",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(Icons.location_on, color: Colors.blue, size: 30),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _userLocation ?? _mapPosition,
            zoom: _mapZoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: allMarkers,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _panierController,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _selectedCategory != null
            ? AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: HomePage.primaryColor),
            onPressed: () {
              setState(() {
                _selectedCategory = null;
              });
            },
          ),
          title: Text(
            _selectedCategory!,
            style: TextStyle(color: Colors.white),
          ),
        )
            : null,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message Welcome Back remis à sa place d'origine
                if (_selectedCategory == null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Let's rescue some delicious Qoffas today",
                          style: TextStyle(fontSize: 12, color: HomePage.primaryColor),
                        ),
                      ],
                    ),
                  ),

                // Barre de recherche toujours visible
                _buildSearchSection(),

                // Section Catégories
                _buildCategoriesSection(context),

                // Contenu principal
                if (_selectedCategory == null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      StreamBuilder<List<Commerce>>(
    stream: Provider.of<CommercantController>(context, listen: false).chargerTousLesCommercants(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    final List<Commerce> commercants = _searchQuery.isEmpty
    ? snapshot.data!
        : _filteredCommercants;

    return FutureBuilder<List<Marker>>(
    future: _getCommercantMarkers(commercants),
    builder: (context, markerSnapshot) {
    if (markerSnapshot.hasData) {
    final List<Marker> commercantMarkers = markerSnapshot.data!;
    return _buildSectionTitle('Close To You', showAction: true, onActionPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => FullMapPage(
    initialPosition: _mapController.center,
    initialZoom: _mapController.zoom,
    markers: [...commercantMarkers]..addAll(_userLocation != null ? [Marker(point: _userLocation!, child: const Icon(Icons.location_on, color: Colors.blue))] : []),
    ),
    ),
    );
    });
    } else {
    return _buildSectionTitle('Close To You', showAction: true, onActionPressed: () {});
    }
    },
    );
    } else {
    return _buildSectionTitle('Close To You', showAction: true, onActionPressed: () {});
    }
    },
    ),
                        const SizedBox(height: 12),
                        StreamBuilder<List<Commerce>>(
                          stream: Provider.of<CommercantController>(context, listen: false).chargerTousLesCommercants(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return FutureBuilder<List<Marker>>(
                                future: _getCommercantMarkers(snapshot.data!),
                                builder: (context, markerSnapshot) {
                                  if (markerSnapshot.hasData) {
                                    return _buildMapSection(markerSnapshot.data!);
                                  } else {
                                    return const Center(child: CircularProgressIndicator(color: HomePage.primaryColor));
                                  }
                                },
                              );
                            } else {
                              return const Center(child: Text('Aucun commerçant trouvé'));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildAvailableNowSection(),
                ] else
                  _buildCategoryContent(_selectedCategory!),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }



  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey[500], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      style: TextStyle(fontSize: 12),
                      onChanged: _filterCommercants,
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildIconCircle(IconData icon) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        color: HomePage.primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 16),
        onPressed: () {},
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
              _buildCategoryIconWithImage(context, 'assets/images/pastry.png', 'Pastry', isSelected: _selectedCategory == 'Pastry'),
              _buildCategoryIconWithImage(context, 'assets/images/bakery.png', 'Bakery', isSelected: _selectedCategory == 'Bakery'),
              _buildCategoryIconWithImage(context, 'assets/images/restaurant.png', 'Restaurant', isSelected: _selectedCategory == 'Restaurant'),
              _buildCategoryIconWithImage(context, 'assets/images/market.png', 'Market', isSelected: _selectedCategory == 'Market'),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIconWithImage(BuildContext context, String assetPath, String label, {bool isSelected = false}) {
    String basePath = assetPath.replaceAll('.png', '');
    String imagePath = isSelected ? '${basePath}Jaune.png' : assetPath;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = _selectedCategory == label ? null : label;
        });
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
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? HomePage.primaryColor : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableNowSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Available Now', showAction: true, onActionPressed: () {
            Provider.of<PanierController>(context, listen: false).loadPaniersDisponibles();
          }),
          const SizedBox(height: 12),
          Consumer<PanierController>(
            builder: (context, panierController, _) {
              if (panierController.error != null) {
                return Text('Error loading data: ${panierController.error}', style: const TextStyle(color: Colors.red));
              }
              final paniersAvecNom = panierController.paniersDisponiblesAvecNom;
              if (paniersAvecNom.isEmpty && !panierController.loading) {
                return const Center(
                  child: Text(
                    'Aucun panier n\'est disponible pour le moment.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              if (panierController.loading && paniersAvecNom.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: HomePage.primaryColor));
              }
              return SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: paniersAvecNom.length,
                  itemBuilder: (context, index) {
                    final data = paniersAvecNom[index];
                    final Panier panier = data['panier'];
                    final String nomCommercant = data['nomCommercant'];
                    return _buildPanierItem(panier, nomCommercant);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPanierItem(Panier panier, String nomCommerce) {
    return Container(
      width: 209,
      height: 190,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: HomePage.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            left: 5,
            child: Container(
              width: 198.9,
              height: 117,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  panier.photoPanier,
                  fit: BoxFit.cover,
                  width: 198.9,
                  height: 117,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
                  },
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 80.07,
            left: 144.65,
            child: Container(
              width: 59.35,
              height: 20.2,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: HomePage.primaryColor.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Center(
                child: Text(
                  '${panier.prixFinal} DA',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomCommerce,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Old Price:',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    Text(
                      '${panier.prixInitial} DA',
                      style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool showAction = false, VoidCallback? onActionPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          if (showAction)
            TextButton(
              onPressed: onActionPressed,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('See All', style: TextStyle(color: HomePage.primaryColor, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.brown.withOpacity(0.6),
      backgroundColor: HomePage.primaryColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
        Navigator.pushNamed(context, '/favorites');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Widget _buildCategoryContent(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Afficher les commerçants filtrés par catégorie et recherche
          if (_searchQuery.isEmpty)
            _buildCommercantsByCategory(category)
          else
            _buildFilteredCommercants(category),
        ],
      ),
    );
  }

  Widget _buildCommercantsByCategory(String category) {
    return StreamBuilder<List<Commerce>>(
      stream: _commercantController.chargerCommercantsParCategorie(category.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Erreur: ${snapshot.error}", style: TextStyle(color: Colors.white));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: HomePage.primaryColor));
        }
        final Commerce = snapshot.data ?? [];
        if (Commerce.isEmpty) {
          return Center(
            child: Text(
              "Aucun résultat trouvé",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: Commerce.length,
          itemBuilder: (context, index) {
            final commercant = Commerce[index];
            return _buildShopCardFromCommercantGeneric(commercant, _getCategoryImage(category));
          },
        );
      },
    );
  }

  Widget _buildFilteredCommercants(String category) {
    final filtered = _filteredCommercants.where((c) =>
    c.categorie?.toLowerCase() == category.toLowerCase()).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          "Aucun résultat trouvé",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final Commerce = filtered[index];
        return _buildShopCardFromCommercantGeneric(Commerce, _getCategoryImage(category));
      },
    );
  }

  String _getCategoryImage(String category) {
    switch (category) {
      case 'Bakery': return 'assets/images/Brioche.png';
      case 'Pastry': return 'assets/images/BiteFood.png';
      case 'Restaurant': return 'assets/images/Burgers.png';
      case 'Market': return 'assets/images/essentials.png';
      default: return 'assets/images/Brioche.png';
    }
  }




  Widget _buildShopCardFromCommercantGeneric(Commerce commerce, String imageAsset) {
    final hasProfileImage = commerce.photoDeProfile.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommerceView(
              commerceId: commerce.idUtilisateur, // Assurez-vous que votre modèle Commerce a un champ 'id'
              userId: FirebaseAuth.instance.currentUser?.uid ?? '', // Gestion de l'userId
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 22.0),
        child: Center(
          child: Container(
            width: 351,
            height: 190,
            margin: const EdgeInsets.symmetric(horizontal: 8),
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
                    child: Image(
                      image: hasProfileImage
                          ? NetworkImage(commerce.photoDeProfile)
                          : const AssetImage('assets/images/img.png') as ImageProvider,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 110,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Text(
                            commerce.nomCommerce,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
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
          ),
        ),
      ),
    );
  }

  }