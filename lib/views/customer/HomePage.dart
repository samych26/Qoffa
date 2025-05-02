import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'fullMap.dart';
import 'Pastry.dart';
import 'Bakery.dart';
import 'Restaurant.dart';
import 'Market.dart';
import '../../Controllers/customer/PanierController.dart';
import '../../services/PanierService.dart';
import '../../Models/panier_modele.dart';
import '../../Models/commerce_modele.dart';
import '../../services/serviceCommercant.dart';
import '../../Controllers/controlCommercant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:collection/collection.dart';

// Extension pour obtenir le premier élément d'une Iterable qui satisfait une condition, ou null si aucun ne correspond.
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

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Position initiale de la carte (Béjaïa par défaut).
  LatLng _mapPosition = LatLng(36.751000, 5.038556);
  LatLng? _userLocation; // Nouvelle variable pour stocker la localisation de l'utilisateur
  late final MapController _mapController;
  // Niveau de zoom initial de la carte.
  double _mapZoom = 13.0;
  // Instance du contrôleur de panier pour gérer les données des paniers.
  late PanierController _panierController;

  // Fonction asynchrone pour obtenir la position géographique actuelle de l'utilisateur.
  Future<void> _getCurrentLocation() async {
    // Vérifie si le service de localisation est activé sur l'appareil.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    // Vérifie et demande la permission d'accès à la localisation si nécessaire.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // Si la permission est refusée de manière permanente, on ne fait rien.
    if (permission == LocationPermission.deniedForever) return;

    // Obtient la position actuelle avec une précision élevée.
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // Met à jour l'état du widget avec les nouvelles coordonnées.
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _mapPosition = _userLocation!; // Centre la carte sur la position de l'utilisateur
    });
  }

  @override
  void initState() {
    super.initState();
    // Obtient la localisation au chargement du widget.
    _getCurrentLocation();
    // Initialise le contrôleur de panier avec le service de panier.
    _panierController = PanierController(PanierService());
    // Charge les paniers disponibles au chargement du widget.
    _panierController.loadPaniersDisponibles();
    // Initialise le contrôleur de la carte.
    _mapController = MapController();
  }

  @override
  void dispose() {
    // Libère les ressources du contrôleur de la carte lorsque le widget est détruit.
    _mapController.dispose();
    super.dispose();
  }

  // Fonction asynchrone pour obtenir les marqueurs des commerçants pour la carte.
  Future<List<Marker>> _getCommercantMarkers(List<Commerce> commercants) async {
    print('_getCommercantMarkers appelé avec ${commercants.length} commerçants');
    List<Marker> markers = [];

    // Vérifie si l'instance de GeocodingPlatform est disponible.
    if (GeocodingPlatform.instance == null) {
      print('GeocodingPlatform non disponible');
      return markers;
    }

    // Itère sur chaque commerçant pour obtenir ses coordonnées et créer un marqueur.
    for (var commercant in commercants) {
      print('Traitement du commerçant: ${commercant.nomCommerce}, adresse: ${commercant.adresseCommerce}');
      // Vérifie si l'adresse du commerçant n'est pas nulle ou vide.
      if (commercant.adresseCommerce != null && commercant.adresseCommerce.isNotEmpty) {
        try {
          print('Géocodage de l\'adresse: ${commercant.adresseCommerce}');
          // Obtient une liste de lieux à partir de l'adresse du commerçant.
          List<Location> locations = await GeocodingPlatform.instance!.locationFromAddress(commercant.adresseCommerce);
          print('Résultat du géocodage pour ${commercant.nomCommerce}: ${locations.length} résultats');
          // Si des lieux sont trouvés, on prend le premier pour obtenir les coordonnées.
          if (locations.isNotEmpty) {
            final location = locations.first;
            print('Coordonnées trouvées pour <span class="math-inline">\{commercant\.nomCommerce\}\: Lat\=</span>{location.latitude}, Lng=${location.longitude}');
            // Crée un marqueur pour la position du commerçant.
            markers.add(
              Marker(
                width: 120.0, // Ajustez la largeur pour contenir le texte
                height: 80.0,
                point: LatLng(location.latitude, location.longitude),
                child: GestureDetector(
                  onTap: () {
                    print('Marqueur du commerçant ${commercant.nomCommerce} cliqué');
                  },
                  child: Stack(
                    alignment: Alignment.topCenter, // Alignement des enfants du Stack
                    children: [
                      Positioned(
                        top: 0, // Positionnez le texte en haut
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
                        top: 20, // Positionnez l'icône en dessous du texte
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

  @override
  Widget build(BuildContext context) {
    // Fournit une instance du PanierController à tous les descendants.
    return ChangeNotifierProvider.value(
      value: _panierController,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchSection(),
                _buildCategoriesSection(context),
                _buildCloseToYouSection(context),
                _buildAvailableNowSection(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // Widget pour construire l'en-tête de la page d'accueil.
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            "Let's rescue some delicious Qoffas today",
            style: TextStyle(fontSize: 12, color: HomePage.primaryColor),
          ),
        ],
      ),
    );
  }

  // Widget pour construire la section de recherche.
  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      color: HomePage.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.black, size: 16),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildIconCircle(Icons.settings),
          const SizedBox(width: 8),
          _buildIconCircle(Icons.notifications),
        ],
      ),
    );
  }

  // Widget pour construire un cercle avec une icône.
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

  // Widget pour construire la section des catégories.
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
            _buildCategoryIconWithImage(context, 'assets/images/market.png', 'Market'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryIconWithImage(BuildContext context, String assetPath, String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (label == 'Pastry') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PastryPage()));
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


  // Widget pour construire la section "Close To You" affichant la carte des commerçants à proximité.
  Widget _buildCloseToYouSection(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Titre de la section avec un bouton "See All" pour afficher la carte en plein écran.
    StreamBuilder<List<Commerce>>(
    stream: Provider.of<CommercantController>(context, listen: false).chargerTousLesCommercants(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    final List<Commerce> commercants = snapshot.data!;
    return FutureBuilder<List<Marker>>(
    future: _getCommercantMarkers(commercants),
    builder: (context, markerSnapshot) {
    if (markerSnapshot.hasData) {
    final List<Marker> commercantMarkers = markerSnapshot.data!;
    List<Marker> allMarkers = [...commercantMarkers];

    // Ajout du marqueur de l'utilisateur SI la localisation a été obtenue
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

    return _buildSectionTitle('Close To You', showAction: true, onActionPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => FullMapPage(
    initialPosition: _mapController.center,
    initialZoom: _mapController.zoom,
    markers: allMarkers,
    ),
    ),
    );
    });
    } else {
    return _buildSectionTitle('Close To You', showAction:true, onActionPressed: () {});
    }
    },
    );
    } else {
      return _buildSectionTitle('Close To You', showAction: true, onActionPressed: () {});
    }
    },
    ),
      const SizedBox(height: 12),
      // Container pour afficher la carte des commerçants à proximité.
      SizedBox(
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: StreamBuilder<List<Commerce>>(
            stream: Provider.of<CommercantController>(context, listen: false).chargerTousLesCommercants(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Commerce> commercants = snapshot.data!;
                return FutureBuilder<List<Marker>>(
                  future: _getCommercantMarkers(commercants),
                  builder: (context, markerSnapshot) {
                    if (markerSnapshot.hasData) {
                      final List<Marker> commercantMarkers = markerSnapshot.data!;
                      List<Marker> allMarkers = [...commercantMarkers];

                      // Ajout du marqueur de l'utilisateur SI la localisation a été obtenue
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

                      return FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: _userLocation ?? _mapPosition, // Centre sur la position de l'utilisateur si disponible
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
                      );
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
        ),
      ),
    ],
    ),
    );
  }

  // Widget pour construire la section "Available Now" affichant les paniers disponibles.
  Widget _buildAvailableNowSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section avec un bouton "See All" pour recharger les paniers.
          _buildSectionTitle('Available Now', showAction: true, onActionPressed: () {
            Provider.of<PanierController>(context, listen: false).loadPaniersDisponibles();
          }),
          const SizedBox(height: 12),
          // Consommateur du PanierController pour afficher la liste des paniers disponibles.
          Consumer<PanierController>(
            builder: (context, panierController, _) {
              // Affiche un message d'erreur si le chargement des données a échoué.
              if (panierController.error != null) {
                return Text('Error loading data: ${panierController.error}', style: const TextStyle(color: Colors.red));
              }

              final paniersAvecNom = panierController.paniersDisponiblesAvecNom;
              // Affiche un message si aucun panier n'est disponible et que le chargement est terminé.
              if (paniersAvecNom.isEmpty && !panierController.loading) {
                return const Center(
                  child: Text(
                    'Aucun panier n\'est disponible pour le moment.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              // Affiche un indicateur de chargement pendant le chargement des données.
              if (panierController.loading && paniersAvecNom.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: HomePage.primaryColor));
              }

              // Affiche une liste horizontale des paniers disponibles.
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

  // Widget pour construire un item de panier affiché dans la liste horizontale.
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
          // Container pour l'image du panier avec une bordure.
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
                  // Widget affiché en cas d'erreur de chargement de l'image.
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
                  },
                  // Widget affiché pendant le chargement de l'image.
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
          // Position pour afficher le prix final du panier.
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
          // Position pour afficher les informations du panier (nom du commerçant et ancien prix).
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

  // Widget pour construire le titre d'une section avec un éventuel bouton "See All".
  Widget _buildSectionTitle(String title, {bool showAction = false, VoidCallback? onActionPressed}) {
    return Row(
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
    );
  }

  // Widget pour construire la barre de navigation inférieure.
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
      onTap: (index) {
        // TODO: Implémenter la navigation en fonction de l'index.
        print('Bottom navigation item $index tapped');
      },
    );
  }
}