import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Controllers/admin/userDetails.dart';
import '../../Models/commerce_modele.dart';
import 'dashboard_widget.dart';
import 'user_management_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessDetails extends StatefulWidget {
  final String businessId;

  const BusinessDetails({super.key, required this.businessId});

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails>
    with SingleTickerProviderStateMixin {
  final UserController _userController = UserController();
  late TabController _tabController;
  Commerce? _businessDetails;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Données pour les cartes d'activité
  Map<String, dynamic> _activityData = {
    'qoffasSold': 0,
    'revenues': 0,
    'favouriteOf': 0,
    'reviews': 0,
  };

  // Données pour les transactions et avis
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _reviewsList = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  List<Map<String, dynamic>> _filteredReviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBusinessDetails();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterData();
    });
  }

  void _filterData() {
    if (_searchQuery.isEmpty) {
      _filteredTransactions = List.from(_transactions);
      _filteredReviews = List.from(_reviewsList);
    } else {
      // Filtrer les transactions
      _filteredTransactions = _transactions.where((transaction) {
        final name = (transaction['name'] ?? '').toLowerCase();
        final amount = (transaction['amount'] ?? '').toLowerCase();
        final date = (transaction['dateFormatted'] ?? '').toLowerCase();
        return name.contains(_searchQuery) ||
            amount.contains(_searchQuery) ||
            date.contains(_searchQuery);
      }).toList();

      // Filtrer les avis
      _filteredReviews = _reviewsList.where((review) {
        final name = (review['name'] ?? '').toLowerCase();
        final comment = (review['comment'] ?? '').toLowerCase();
        final date = (review['dateFormatted'] ?? '').toLowerCase();
        return name.contains(_searchQuery) ||
            comment.contains(_searchQuery) ||
            date.contains(_searchQuery);
      }).toList();
    }
  }

  // Chargement des détails du commerce
  Future<void> _loadBusinessDetails() async {
    try {
      final business = await _userController.getBusinessDetails(
        widget.businessId,
      );
      setState(() {
        _businessDetails = business;
        _isLoading = false;
      });

      // Si le compte n'est pas suspendu, charger les données d'activité
      if (_businessDetails?.etatCompteCommercant.toLowerCase() != 'Suspended') {
        _loadActivityData();
        _loadTransactions();
        _loadReviews();
      }
    } catch (e) {
      print('Erreur lors du chargement des détails du commerce: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Chargement des données d'activité
  Future<void> _loadActivityData() async {
    try {
      final stats = await _userController.getBusinessStatistics(
        widget.businessId,
      );
      setState(() {
        _activityData = stats;
      });
    } catch (e) {
      print('Erreur lors du chargement des données d\'activité: $e');
    }
  }

  // Chargement des transactions
  Future<void> _loadTransactions() async {
    try {
      final transactions = await _userController.getSaleTransactions(
        widget.businessId,
      );
      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
      });
    } catch (e) {
      print('Erreur lors du chargement des transactions: $e');
    }
  }

  // Chargement des avis
  Future<void> _loadReviews() async {
    try {
      final reviews = await _userController.getBusinessReviews(
        widget.businessId,
      );
      setState(() {
        _reviewsList = reviews;
        _filteredReviews = reviews;
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


  // Fonction pour réactiver un compte suspendu
  Future<void> _unsuspendAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _userController.verifyBusinessAccount(
        widget.businessId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte réactivé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        // Recharger les détails pour mettre à jour l'interface
        await _loadBusinessDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la réactivation du compte'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors de la réactivation du compte: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour réactiver un compte suspendu
  Future<void> _suspendAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _userController.suspendBusinessAccount(
        widget.businessId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte suspendu avec succès'),
            backgroundColor: Color.fromARGB(255, 221, 65, 65),
          ),
        );
        // Recharger les détails pour mettre à jour l'interface
        await _loadBusinessDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la suspension du compte'),
            backgroundColor: Color.fromARGB(255, 168, 153, 152),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors de la suspension du compte: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour supprimer un compte
  Future<void> _deleteAccount() async {
    // Afficher une boîte de dialogue de confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer définitivement ce compte ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Supprimer le document de la collection Commerce
      await FirebaseFirestore.instance
          .collection('Commerce')
          .doc(widget.businessId)
          .delete();

      // Supprimer le document de la collection Utilisateur
      await FirebaseFirestore.instance
          .collection('Utilisateur')
          .doc(widget.businessId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compte supprimé avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      // Retourner à la page précédente
      Navigator.pop(context);
    } catch (e) {
      print('Erreur lors de la suppression du compte: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFF3E9B5)),
              )
            : Column(
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
                            const SizedBox(height: 20),
                            // Vérifier si le compte est suspendu
                            if (_businessDetails?.etatCompteCommercant
                                    .toLowerCase() ==
                                'suspended')
                              _buildSuspendedAccountView()
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBasicInformation(),
                                  const SizedBox(height: 24),
                                  _buildActivityEngagement(),
                                  const SizedBox(height: 16),
                                  _buildTabContent(),
                                ],
                              ),
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
    return Container(
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
            color: Color.fromARGB(255, 103, 103, 103),
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
    );
  }

  // Vue spécifique pour les comptes suspendus
  Widget _buildSuspendedAccountView() {
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(76, 217, 217, 217),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildInfoRow('Name:', _businessDetails?.nomCommerce ?? 'N/A'),
              _buildInfoRow('Email:', _businessDetails?.email ?? 'N/A'),
              _buildInfoRow(
                'Phone Number:',
                _businessDetails?.numTelCommerce ?? 'N/A',
              ),
              _buildInfoRow('Role:', 'Business'),
              _buildInfoRow(
                'Business category:',
                _businessDetails?.categorie ?? 'N/A',
              ),
              _buildInfoRow(
                'Address:',
                _businessDetails?.adresseCommerce ?? 'N/A',
              ),
              _buildInfoRow(
                'Account status',
                'Suspended',
                valueColor: Color.fromARGB(255, 185, 23, 23),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton pour réactiver le compte
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _unsuspendAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 29, 80, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      ),
                      child: const Text(
                        'Unsuspend',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Bouton pour supprimer le compte
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _deleteAccount();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 217, 42, 42),
                        side: const BorderSide(color: Color.fromARGB(255, 217, 42, 42), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 217, 42, 42)
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInformation() {
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(76, 217, 217, 217),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildInfoRow('Name:', _businessDetails?.nomCommerce ?? 'N/A'),
              _buildInfoRow('Email:', _businessDetails?.email ?? 'N/A'),
              _buildInfoRow(
                'Phone Number:',
                _businessDetails?.numTelCommerce ?? 'N/A',
              ),
              _buildInfoRow('Role:', 'Business'),
              _buildInfoRow(
                'Business category:',
                _businessDetails?.categorie ?? 'N/A',
              ),
              _buildInfoRow(
                'Address:',
                _businessDetails?.adresseCommerce ?? 'N/A',
              ),
              _buildInfoRow(
                'Account status',
                _businessDetails?.etatCompteCommercant ?? 'Pending',
                valueColor: _getStatusColor(
                  _businessDetails?.etatCompteCommercant ?? 'pending',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action pour le registre commercial
                      _showRegistryDocument();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 29, 80, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Commercial Registry',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _suspendAccount();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 217, 42, 42),
                      side: const BorderSide(color: Color.fromARGB(255, 217, 42, 42), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      'Suspend Account',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRegistryDocument() {
    // Afficher le document de registre commercial
    if (_businessDetails?.registreCommerce == null ||
        _businessDetails!.registreCommerce.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun document de registre commercial disponible'),
        ),
      );
      return;
    }

    // Ici, vous pourriez ouvrir une nouvelle page pour afficher le document
    // ou utiliser un package comme photo_view pour afficher l'image
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registre Commercial'),
        content: Image.network(
          _businessDetails!.registreCommerce,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Text('Impossible de charger l\'image');
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 157,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 157, 157, 157),
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: valueColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'Verified':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      case 'Suspended':
        return Colors.red.shade800;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActivityEngagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section avec icône (inchangé)
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

        // TabBar personnalisée - modifications ici
        Container(
          height: 39, // Hauteur fixe pour la TabBar
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 248, 249, 254),
            borderRadius: BorderRadius.circular(16),
          
          ),
          // Ajout d'un ClipRRect pour s'assurer que les coins arrondis sont respectés

          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TabBar(
              controller: _tabController,
              // Modification de l'indicateur pour qu'il remplisse tout l'onglet
              indicator: BoxDecoration(
                color: Color.fromARGB(255, 243, 233, 181), // beige
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.transparent, // Rend la bordure invisible
                  width: 0,
                ),
              ),

              indicatorSize: TabBarIndicatorSize.tab,

              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              labelPadding: EdgeInsets.zero,
              // Style du texte pour l'onglet sélectionné
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

              // Définition des onglets
              tabs: const [Tab(text: 'Sales'), Tab(text: 'Reviews')],
              onTap: (index) {
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return IndexedStack(
      index: _tabController.index,
      children: [_buildSalesTab(), _buildReviewsTab()],
    );
  }

  Widget _buildSalesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildActivityCards(),
        const SizedBox(height: 24),
        _buildSaleTransactions(),
      ],
    );
  }

  Widget _buildActivityCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                'Qoffas Sold',
                _activityData['qoffasSold'].toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                'Revenues',
                '${_activityData['revenues']}DA',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                'Favourite Of',
                _activityData['favouriteOf'].toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActivityCard(
                'Reviews',
                _activityData['reviews'].toString(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard(String title, String value) {
    return Container(

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF3A3A3A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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

  Widget _buildSaleTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sale Transactions',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 12),
        _filteredTransactions.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _searchQuery.isEmpty
                        ? 'Aucune transaction trouvée'
                        : 'Aucune transaction correspondant à "$_searchQuery"',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : Column(
                children: _filteredTransactions
                    .map(
                      (transaction) => _buildTransactionItem(
                        transaction['name'] ?? 'Client inconnu',
                        transaction['dateFormatted'] ?? '',
                        transaction['amount'] ?? '0 DA',
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildTransactionItem(String name, String date, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 243, 233, 181),
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 113, 114, 122),
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return _filteredReviews.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
              child: Text(
                _searchQuery.isEmpty
                    ? 'Aucun avis trouvé'
                    : 'Aucun avis correspondant à "$_searchQuery"',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey
                ),
              ),
            ),
          )
        : Column(
            children: _filteredReviews
                .map(
                  (review) => _buildReviewItem(
                    review['id'] ?? '',
                    review['name'] ?? 'Client inconnu',
                    review['dateFormatted'] ?? '',
                    review['rating'] ?? 0,
                    review['comment'] ?? '',
                  ),
                )
                .toList(),
          );
  }

  Widget _buildReviewItem(
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
