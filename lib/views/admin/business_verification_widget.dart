import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_widget.dart';
import '../../Controllers/admin/userDetails.dart';
import '../../Models/commerce_modele.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessVerification extends StatefulWidget {
  final String businessId;

  const BusinessVerification({super.key, required this.businessId});

  @override
  State<BusinessVerification> createState() => _BusinessVerificationState();
}

class _BusinessVerificationState extends State<BusinessVerification> {
  final UserController _userController = UserController();
  Commerce? _commerce;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
  }


  Future<void> _loadBusinessData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final commerce = await _userController.getBusinessDetails(
        widget.businessId,
      );

      setState(() {
        _commerce = commerce;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données commerce: $e');
      setState(() {
        _isLoading = false;
      });
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
              child:
                  _isLoading
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
                              _buildBusinessInformation(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboard(),
                ),
             );
            },
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Business verification',
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

  /// Construction de la barre de recherche
  Widget _buildSearchBar() {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Search',
            style: TextStyle(
              fontFamily: 'League Spartan',
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 103, 103, 103),
            ),
          ),
        ),
      ),
    );
  }

  /// Construction des informations du commerce
  Widget _buildBusinessInformation() {
    if (_commerce == null) {
      return const Center(
        child: Text(
          'Aucune information commerce disponible',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    // Déterminer la couleur du statut
    Color statusColor;
    switch (_commerce!.etatCompteCommercant.toLowerCase()) {
      case 'verified':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 48, 48, 48),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations commerce
          _buildInfoRow('Name:', _commerce!.nomCommerce),
          const SizedBox(height: 8),
          _buildInfoRow('Email:', _commerce!.email),
          const SizedBox(height: 8),
          _buildInfoRow('Phone Number:', _commerce!.numTelCommerce),
          const SizedBox(height: 8),
          _buildInfoRow('Role:', _commerce!.typeUtilisateur),
          const SizedBox(height: 8),
          _buildInfoRow('Business category:', _commerce!.categorie),
          const SizedBox(height: 8),
          _buildInfoRow('Address:', _commerce!.adresseCommerce),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(
                width: 157,
                child: Text(
                  'Account status:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(137, 157, 157, 157),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _commerce!.etatCompteCommercant,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Section registre de commerce
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Commercial Registration',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Ouvrir le fichier du registre de commerce
                  _openRegistrationFile(_commerce!.registreCommerce);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 243, 233, 181),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text(
                  'see file',
                  style: TextStyle(
                    fontFamily: 'League Spartan',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 25, 25, 25),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Boutons d'action
          Row(
            children: [
              // Bouton Verify Account
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_commerce!.etatCompteCommercant!="verified"){
                      _verifyAccount();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminDashboard(),
                        ),
                      );
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Compte déja verifié'),
                          backgroundColor: Color.fromARGB(255, 169, 216, 171),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 29, 80, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Verify Account',
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
              // Bouton Reject Account

              Expanded(
                child: ElevatedButton(
                  onPressed: () => _rejectAccount(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Fond transparent
                    shadowColor: Colors.transparent, // Supprimer l'ombre
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color.fromARGB(255, 217, 42, 42)), // Bordure rouge
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Reject Account',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 217, 42, 42), 

                    ),
                  ),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 157,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(137, 157, 157, 157),
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




  void _openRegistrationFile(String fileUrl) async {
    if (fileUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun fichier de registre de commerce disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final Uri url = Uri.parse(fileUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'ouvrir le fichier'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }



  void _verifyAccount() async {
    if (_commerce == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _userController.verifyBusinessAccount(
        _commerce!.idUtilisateur,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte vérifié avec succès'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger les données pour mettre à jour l'interface
        _loadBusinessData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la vérification du compte'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _rejectAccount() async {
    if (_commerce == null) return;


    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _userController.rejectBusinessAccount(
        _commerce!.idUtilisateur,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte rejeté avec succès'),
            backgroundColor: Colors.orange,
          ),
        );

        // Recharger les données pour mettre à jour l'interface
        _loadBusinessData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du rejet du compte'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Construction de la barre de navigation du bas
  Widget _buildBottomNavBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF59D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            icon: Icons.home,
            label: 'Home',
            isSelected: true,
            onTap: () {},
          ),
          _NavBarItem(
            icon: Icons.people,
            label: 'users',
            isSelected: false,
            onTap: () {},
          ),
          _NavBarItem(
            icon: Icons.person,
            label: 'Profile',
            isSelected: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher un élément de la barre de navigation
class _NavBarItem extends StatelessWidget {
  final IconData icon;
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
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFFFFF59D) : Colors.black,
              size: 20,
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
