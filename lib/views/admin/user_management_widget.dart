import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_widget.dart';
import 'client_details_widget.dart';
import 'business_details_widget.dart';
import '../../Controllers/admin/userManagement.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final UserManagementController _controller = UserManagementController();
  String _selectedFilterType = UserManagementController.TYPE_ALL;
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  final TextEditingController _searchController =
      TextEditingController(); // Nouveau contrôleur pour la recherche

  @override
  void initState() {
    super.initState();
    _loadUsers();

    // Ajouter un listener pour la recherche
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Méthode appelée lorsque le texte de recherche change
  void _onSearchChanged() {
    _performSearch(_searchController.text);
  }

  // Méthode pour effectuer la recherche
  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _controller.searchUsers(query, _selectedFilterType);
      setState(() {
        _users = results;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      setState(() {
        _users = [];
        _isLoading = false;
      });
    }
  }

  // Charger les utilisateurs selon le filtre sélectionné
  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _controller.fetchUsersByType(_selectedFilterType);
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des utilisateurs: $e');
      setState(() {
        _users = [];
        _isLoading = false;
      });
    }
  }

  // Changer le type de filtre
  void _changeFilterType(String filterType) {
    setState(() {
      _selectedFilterType = filterType;
      _searchController
          .clear(); // Effacer la recherche lors du changement de filtre
    });
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      _buildUserFilter(),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFFFFF59D)))
                          : _buildUsersList(),
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
                'User management',
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
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 13),
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontFamily: 'League Spartan',
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF676767),
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontFamily: 'League Spartan',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserFilter() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: _changeFilterType,
      itemBuilder: (context) {
        return UserManagementController.getUserTypes().map((type) {
          return PopupMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromARGB(255, 197, 198, 204), // Bordure violette
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedFilterType,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    if (_users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Aucun utilisateur trouvé',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      );
    }

    return Column(
      children: _users.map((user) {
        // Vérification supplémentaire pour s'assurer que les champs requis existent
        if (user['id'] == null ||
            user['name'] == null ||
            user['type'] == null) {
          return const SizedBox
              .shrink(); // Ignorer les utilisateurs avec des données manquantes
        }
        return _buildUserItem(user);
      }).toList(),
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user) {
    final String name = user['name'] ?? 'Utilisateur inconnu';
    final String type = user['type'] ?? 'Inconnu';
    final String id = user['id'] ?? '';

    final String formattedType = type.isNotEmpty
        ? type[0].toUpperCase() + type.substring(1).toLowerCase()
        : 'Inconnu';


    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      constraints: const BoxConstraints(
        minWidth: double.infinity, // Prend toute la largeur
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 252, 236),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Alignement central vertical
          children: [
            Expanded( // Partie gauche (nom et type)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Prend le minimum d'espace vertical
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 35, 35, 35),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedType,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 233, 84, 34),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Bouton "View Details"
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero, // Réduit la taille minimum
                padding: EdgeInsets.zero, // Supprime le padding interne
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Réduit la zone cliquable
              ),
              onPressed: () {
                if (id.isEmpty) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => type.toLowerCase() == 'client'
                        ? ClientDetails(clientId: id)
                        : BusinessDetails(businessId: id),
                  ),
                );
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
          ],
        ),
      ),
    );
  }

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

// Élément de la barre de navigation
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
