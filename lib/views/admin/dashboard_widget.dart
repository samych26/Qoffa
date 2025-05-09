import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Controllers/admin/dashboard.dart';
import 'business_verification_widget.dart';
import 'user_management_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'client_details_widget.dart';
import 'business_details_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final DashboardController _controller = DashboardController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _commerces = [];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;


  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      _performSearch(_searchController.text);
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {

      final results = await _controller.searchUsers(query, 'All Users');
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  

  
  Future<void> _loadData() async {
    try {
      final commerces = await _controller.getListeCommerces();
      setState(() {
        _commerces = commerces;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      setState(() {
        _commerces = [];
        _isLoading = false;
      });
    }
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
              child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFF3E9B5),
                    ),
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
                          _searchController.text.isNotEmpty ? _buildSearchResults() : const SizedBox.shrink(),
                          _searchController.text.isEmpty ? _buildStatCards() : const SizedBox.shrink(),
                          const SizedBox(height: 24),
                          _searchController.text.isEmpty ? _buildBusinessVerification() : const SizedBox.shrink(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
            ),
            _buildBottomNavBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [],
          ),
          const SizedBox(height: 16),
          const Text(
            'Dashboard',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
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



  Widget _buildStatCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FutureBuilder<int>(
                future: _controller.getNombreUtilisateurs(),
                builder: (context, snapshot) {
                  final value = snapshot.hasData ? snapshot.data.toString() : '...';
                  return _StatCard(
                    title: 'Users',
                    value: value,
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 21, 21, 21), Color.fromARGB(255, 97, 97, 97)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FutureBuilder<int>(
                future: _controller.getTotalSales(),
                builder: (context, snapshot) {
                  final value = snapshot.hasData ? snapshot.data.toString() : '...';
                  return _StatCard(
                    title: 'Total Sales',
                    value: value,
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 21, 21, 21), Color.fromARGB(255, 97, 97, 97)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FutureBuilder<int>(
                future: _controller.getNombreClient(),
                builder: (context, snapshot) {
                  final value = snapshot.hasData ? snapshot.data.toString() : '...';
                  return _StatCard(
                    title: 'Customers',
                    value: value,
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 21, 21, 21), Color.fromARGB(255, 97, 97, 97)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FutureBuilder<int>(
                future: _controller.getNombreCommercant(),
                builder: (context, snapshot) {
                  final value = snapshot.hasData ? snapshot.data.toString() : '...';
                  return _StatCard(
                    title: 'Business',
                    value: value,
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 21, 21, 21), Color.fromARGB(255, 97, 97, 97)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusinessVerification() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF3E9B5)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 48, 48, 48),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business verification',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 150, 226, 214),
            ),
          ),
          const SizedBox(height: 16),
          ...(_commerces.isNotEmpty 
    ? _commerces.map((commerce) {
        final name = commerce['name'] ?? 'Commerce inconnu';
        final status = commerce['status'] ?? 'Pending';
        final id = commerce['id'] ?? '';
        final color = _controller.getStatusColor(status);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _VerificationItem(
            name: name,
            status: status,
            statusColor: color,
            commerceId: id,
          ),
        );
      }).toList()
    : [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Aucun commerce à vérifier',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 14,
              ),
            ),
          ),
        )
      ]
  ),
          ],
        ),
      );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return const SizedBox.shrink();
    }
    
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF3E9B5)),
      );
    }
    
    if (_searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Aucun utilisateur trouvé',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Résultats de recherche',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        ...(_searchResults.map((user) => _buildUserItem(user)).toList()),
      ],
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user) {
    final String name = user['name'] ?? 'Utilisateur inconnu';
    final String type = user['type'] ?? 'Inconnu';
    final String id = user['id'] ?? '';
    
    String formattedType = type.isNotEmpty
        ? type[0].toUpperCase() + type.substring(1).toLowerCase()
        : 'Inconnu';
    
    if (formattedType == 'Commerce') {
      formattedType = user['categorie'] ?? 'Commerce';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 252, 236),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedType,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                if (id.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ID utilisateur manquant'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Assuming ClientDetails and BusinessDetails are defined elsewhere
                // and are valid widgets. Replace with your actual implementation.
                if (type.toLowerCase() == 'client') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientDetails(clientId: id),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessDetails(businessId: id),
                    ),
                  );
                }
              },
              child: const Text(
                'View Details',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
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
            icon: 'assets/icons/home_selected.svg',
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
            icon: 'assets/icons/users.svg',
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

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Gradient? gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 243, 233, 181),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationItem extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  final String commerceId;
  

  const _VerificationItem({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.commerceId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (commerceId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusinessVerification(businessId: commerceId),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 157, 157, 157),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SvgPicture.asset(  // Icône SVG
              'assets/icons/Rectangle.svg',
              width: 16,
              height: 16,
              color: Colors.black87,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom Navigation Bar Item
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
