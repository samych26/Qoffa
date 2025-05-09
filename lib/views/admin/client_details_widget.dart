import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Controllers/admin/userDetails.dart';
import '../../Models/client_model.dart';
import 'dashboard_widget.dart';
import 'business_details_widget.dart';
import 'user_management_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClientDetails extends StatefulWidget {
  final String clientId;

  const ClientDetails({super.key, required this.clientId});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails>
    with SingleTickerProviderStateMixin {
  final UserController _userController = UserController();
  late TabController _tabController;
  Client? _client;
  bool _isLoading = true;

  // Listes pour stocker les données récupérées
  List<Map<String, dynamic>> _favouriteShops = [];
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> _reservedQoffas = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Charger les données correspondantes à l'onglet sélectionné
        if (_tabController.index == 0) {
          _loadFavouriteShops();
        } else if (_tabController.index == 1) {
          _loadReviews();
        } else if (_tabController.index == 2) {
          _loadReservedQoffas();
        }
      }
    });
    _loadClientData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Charge les données du client depuis Firestore via le contrôleur
  Future<void> _loadClientData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final client = await _userController.getClientDetails(widget.clientId);

      setState(() {
        _client = client;
        _isLoading = false;
      });

      // Charger les données de l'onglet par défaut
      _loadFavouriteShops();
    } catch (e) {
      print('Erreur lors du chargement des données client: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Charge les magasins favoris du client via le contrôleur
  Future<void> _loadFavouriteShops() async {
    try {
      final shops = await _userController.getFavouriteShops(widget.clientId);

      setState(() {
        _favouriteShops = shops;
      });
    } catch (e) {
      print('Erreur lors du chargement des magasins favoris: $e');
    }
  }

  /// Charge les avis laissés par le client via le contrôleur
  Future<void> _loadReviews() async {
    try {
      final reviews = await _userController.getClientReviews(widget.clientId);

      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      print('Erreur lors du chargement des avis: $e');
    }
  }

  Future<void> _deleteReview(String reviewId) async {
    try {
      await _userController.deleteReview(reviewId); // Appelle la méthode du contrôleur

      // Recharge les avis après suppression
      await _loadReviews();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avis supprimé avec succès')),
      );
    } catch (e) {
      print('Erreur lors de la suppression de l\'avis: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }


  /// Charge les paniers réservés par le client via le contrôleur
  Future<void> _loadReservedQoffas() async {
    try {
      final reservedQoffas =
          await _userController.getReservedQoffas(widget.clientId);

      setState(() {
        _reservedQoffas = reservedQoffas;
      });
    } catch (e) {
      print('Erreur lors du chargement des paniers réservés: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Configuration de la barre d'état pour qu'elle soit transparente
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSearchBar(),
                            const SizedBox(height: 20),
                            _buildBasicInformation(),
                            const SizedBox(height: 24),
                            _buildActivityEngagement(),
                            const SizedBox(height: 16),
                            _buildContentBasedOnTab(),
                          ],
                        ),
                      ),
                    ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  /// Construction de l'en-tête avec le titre et le bouton de retour
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'User details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Espace pour équilibrer le bouton de retour
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                SizedBox(width: 16),
                Text(
                  'Search',
                  style: TextStyle(
                    fontFamily: 'League Spartan',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF676767),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Construction de la section d'informations de base de l'utilisateur
  Widget _buildBasicInformation() {
    // Si le client est null, afficher un message d'erreur
    if (_client == null) {
      return const Center(
        
        child: Text(
          'Aucune information client disponible',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(76, 217, 217, 217),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              // Informations utilisateur dynamiques
              _buildInfoRow(
                'Name:',
                _userController.getClientFullName(_client!),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Email:', _client!.email),
              const SizedBox(height: 8),
              _buildInfoRow('Phone:', _client!.numTelClient),
              const SizedBox(height: 8),
              _buildInfoRow('Role:', _client!.typeUtilisateur),
              const SizedBox(height: 8),
              _buildInfoRow('Adress:', _client!.adresseClient),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  /// Construction d'une ligne d'information avec label et valeur
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 157, 157, 157),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Construction de la section d'engagement d'activité avec les onglets
  Widget _buildActivityEngagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/insights.svg',
              width: 14,
              height: 16,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SizedBox(width: 8),
            Text(
              'Activity Engagement',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 248, 249, 254),
            borderRadius: BorderRadius.circular(16),
            
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color.fromARGB(255, 243, 233, 181), // beige
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              labelPadding: EdgeInsets.zero,
              labelColor: Color.fromARGB(255, 25, 25, 25),
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),

              unselectedLabelColor: Color.fromARGB(255, 113, 114, 122),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              tabs: const [
                Tab(text: 'Favourite shops'),
                Tab(text: 'Reviews'),
                Tab(text: 'Reserved Qoffas\''),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Affiche le contenu en fonction de l'onglet sélectionné
  Widget _buildContentBasedOnTab() {
    return IndexedStack(
      index: _tabController.index,
      children: [
        _buildFavouriteShopsGrid(),
        _buildReviewsList(),
        _buildReservedQoffasGrid(),
      ],
    );
  }

  /// Construction de la grille des magasins favoris
  Widget _buildFavouriteShopsGrid() {
    if (_favouriteShops.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Aucun magasin favori trouvé',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _favouriteShops.length,
      itemBuilder: (context, index) {
        if (index >= _favouriteShops.length) {
          return const SizedBox.shrink(); // Protection supplémentaire
        }
        final shop = _favouriteShops[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 252, 236),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              shop['name'] ?? 'Sans nom',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF232323),
              ),
            ),
            subtitle: Text(
              shop['category'] ?? 'Catégorie inconnue',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 233, 84, 34),
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                if (shop['id'] != null && shop['id'].toString().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BusinessDetails(businessId: shop['id']),
                    ),
                  );
                }
              },
              child: const Text(
                'View Details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 185, 23, 23),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Construction de la liste des avis
  Widget _buildReviewsList() {
    if (_reviews.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Aucun avis trouvé',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
        ),
      );
    }

    return Column(
      children: _reviews.map((review) {
        return _buildClientReviewItem(
          review['id'] ?? '',
          review['commerceName'] ?? 'Commerce',
          review['dateFormatted'] ?? '',
          review['note']?.toInt() ?? 0,
          review['commentaire'] ?? '',
        );
      }).toList(),
    );
  }

  Widget _buildClientReviewItem(
    String id,
    String name,
    String date,
    int rating,
    String comment,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Color.fromARGB(255, 224, 223, 223)),
                onPressed: () => _deleteReview(id),
              ),
            ],
          ),
          Text(
            date,
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 196, 189, 150),
            ),
          ),

          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: index < rating ? Color.fromARGB(255, 242, 232, 181) : Color.fromARGB(255, 135, 125, 74),
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  /// Construction de la grille des paniers réservés
  Widget _buildReservedQoffasGrid() {
    if (_reservedQoffas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Aucun panier réservé trouvé',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.white, fontSize: 16,fontWeight: FontWeight.w400
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reservedQoffas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final qoffa = _reservedQoffas[index];
        final date = qoffa['date'] as DateTime? ?? DateTime.now();
        final formattedDate = '${date.day}/${date.month}/${date.year}';

        return Container(
          height: 93,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 248, 248, 248),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Image à gauche
              Container(
                width: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: qoffa['photoPanier'] != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          qoffa['photoPanier'],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                      )
                    : const Center(child: Icon(Icons.image)),
              ),

              // Infos à droite
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        qoffa['nomCommerce'] ?? 'Commerce inconnu',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color.fromARGB(255, 31, 32, 36)
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 113, 114, 122),
                        ),
                      ),
                      Text(
                        qoffa['price'] ?? 'Prix inconnu',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 113, 114, 122),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Icône flèche
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construction de la barre de navigation du bas
  Widget _buildBottomNavBar() {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 243, 233, 181),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            icon: 'assets/icons/home.svg',
            label: 'Home',
            isSelected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboard()),
              );
            },
          ),
          _NavBarItem(
            icon: 'assets/icons/users_selected.svg',
            label: 'Users',
            isSelected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserManagement()),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher un élément de la barre de navigation
class _NavBarItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                color: isSelected
                    ? const Color.fromARGB(255, 243, 233, 181)
                    : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
