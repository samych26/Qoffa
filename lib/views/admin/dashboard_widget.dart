
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Controllers/admin/dashboard.dart';
import 'business_verification_widget.dart';
//import 'user_management_widget.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  

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
                      const SizedBox(height: 20),
                      _buildStatCards(),
                      const SizedBox(height: 24),
                      _buildBusinessVerification(),
                      const SizedBox(height: 24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Text(
                  'Search',
                  style: TextStyle(
                    fontFamily: 'League Spartan',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 103, 103, 103),
                  ),
                ),
              ],
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
              future: DashboardController().getNombreUtilisateurs(),
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
              future: DashboardController().getTotalSales(),
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
              future: DashboardController().getNombreClient(),
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
              future: DashboardController().getNombreCommercant(),
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DashboardController().getListeCommerces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Erreur lors du chargement');
        }

        final commerces = snapshot.data ?? [];

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
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
              ...commerces.map((commerce) {
                final name = commerce['name'];
                final status = commerce['status'];
                final id = commerce['id']; // Récupérer l'ID du commerce
                final color = DashboardController().getStatusColor(status);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _VerificationItem(
                    name: name,
                    status: status,
                    statusColor: color,
                    commerceId: id, // Passer l'ID du commerce
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  

  

  Widget _buildBottomNavBar() {
    return Container(
      height: 70,
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
            icon: Icons.home,
            label: 'Home',
            isSelected: true,
            onTap: () {},
          ),
          _NavBarItem(
            icon: Icons.people,
            label: 'Users',
            isSelected: false,
            onTap: () {
              
            },
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
  final String commerceId; // Ajout de l'ID du commerce

  const _VerificationItem({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.commerceId, // Nouveau paramètre
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation vers la page de vérification du commerce
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessVerification(businessId: commerceId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 157, 157, 157),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.diamond_outlined,
              size: 16,
              color: Colors.black87,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
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

// Tab Button Widget

// Donut Chart Painter



// Bottom Navigation Bar Item
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
              color: isSelected ? const Color.fromARGB(255, 243, 233, 181) : Colors.black,
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
