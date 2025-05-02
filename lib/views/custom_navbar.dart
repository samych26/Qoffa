import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final Function(String) onTabSelected;

  CustomNavBar({required this.onTabSelected});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 20.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      _controller.forward(from: 0.0); // Réinitialiser l'animation
    });
    widget.onTabSelected(index == 0 ? "offers" : "reviews");  // Passe le nom de l'onglet sélectionné
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFF3E9B5), // Couleur de fond personnalisée
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      currentIndex: selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0.0, -_animation.value), // Animation de la boule
                child: Icon(Icons.local_offer, size: 30),
              );
            },
          ),
          label: "Offers",
        ),
        BottomNavigationBarItem(
          icon: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0.0, -_animation.value),
                child: Icon(Icons.reviews, size: 30),
              );
            },
          ),
          label: "Reviews",
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
