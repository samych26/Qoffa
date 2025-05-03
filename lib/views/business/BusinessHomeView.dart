import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessHomeView extends StatefulWidget {
  final String idUtilisateur;

  const BusinessHomeView({Key? key, required this.idUtilisateur}) : super(key: key);

  @override
  _BusinessHomeViewState createState() => _BusinessHomeViewState();
}

class _BusinessHomeViewState extends State<BusinessHomeView> {
  int _pageIndex = 0;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    DashboardPage(),
    Placeholder(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Permet aux éléments de s'étendre sous la barre de navigation
      backgroundColor: Colors.transparent, // Fond transparent
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Fond transparent de la barre de navigation
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: <Widget>[
          SvgPicture.asset('assets/icons/home-2.svg', width: 30, height: 30),
          SvgPicture.asset('assets/icons/cart.svg', width: 30, height: 30),
          SvgPicture.asset('assets/icons/user.svg', width: 30, height: 30),
        ],
        color: Color(0xFFF3E9B5),
        buttonBackgroundColor: Color(0xFFF3E9B5),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
      body: _pages[_pageIndex], // Affiche la page sélectionnée sans le fond transparent inutile
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedTab = "offers";

  final List<Map<String, dynamic>> paniers = [
    {
      'image': 'https://via.placeholder.com/300',
      'prixInitial': 20.0,
      'prixFinal': 12.0,
      'heureCreation': '14:30',
      'description': 'Panier fruits et légumes frais',
    },
    {
      'image': 'https://via.placeholder.com/300',
      'prixInitial': 15.0,
      'prixFinal': 9.0,
      'heureCreation': '13:00',
      'description': 'Assortiment de viennoiseries',
    },
    {
      'image': 'https://via.placeholder.com/300',
      'prixInitial': 15.0,
      'prixFinal': 9.0,
      'heureCreation': '13:00',
      'description': 'Assortiment de viennoiseries',
    },
    {
      'image': 'https://via.placeholder.com/300',
      'prixInitial': 15.0,
      'prixFinal': 9.0,
      'heureCreation': '13:00',
      'description': 'Assortiment de viennoiseries',
    },
    {
      'image': 'https://via.placeholder.com/300',
      'prixInitial': 15.0,
      'prixFinal': 9.0,
      'heureCreation': '13:00',
      'description': 'Assortiment de viennoiseries',
    },
  ];

  Widget buildStatCard(String title, String value) {
    return Container(
      height: 92,
      width: 180.5,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF090909), Color(0xFF656565)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF3E9B5))),
            SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget buildPanierCard(Map<String, dynamic> panier) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFEEEBD8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(panier['image'], height: 119.14, width: 359, fit: BoxFit.cover),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  Text("${panier['prixInitial']}€",
                      style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF89B191),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("${panier['prixFinal']}€",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(panier['description'],
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Created at:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(panier['heureCreation'],
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: Text("Delete Qoffa", style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Permet au body de s'étendre derrière la bottom bar si nécessaire
      backgroundColor: const Color(0xFF333333), // Assure un fond global
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top + 16, // Pour remplacer SafeArea en haut
          16,
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 35,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 180.5 / 92,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildStatCard("Total ventes", "120"),
                buildStatCard("Commandes", "80"),
                buildStatCard("Paniers actifs", "12"),
                buildStatCard("Évaluations", "4.5★"),
              ],
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () => setState(() => selectedTab = "offers"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          selectedTab == "offers" ? Color(0xFFF3E9B5) : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "Qoffas’ you offer",
                          style: TextStyle(
                            color: selectedTab == "offers" ? Colors.black : Color(0xFF71727A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () => setState(() => selectedTab = "reviews"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          selectedTab == "reviews" ? Color(0xFFF3E9B5) : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                            color: selectedTab == "reviews" ? Colors.black : Color(0xFF71727A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (selectedTab == "offers")
              Column(children: paniers.map((p) => buildPanierCard(p)).toList())
            else
              Center(
                child: Text(
                  "Reviews section coming soon",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
