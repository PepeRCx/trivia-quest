import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:trivia_quest/pages/tabs/favorite.dart';
import 'package:trivia_quest/pages/tabs/primary.dart';
import 'package:trivia_quest/pages/tabs/settings.dart';
import 'package:trivia_quest/pages/tabs/shop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<Widget> screens = [
    PrimaryTab(),
    FavoriteTab(),
    ShopTab(),
    SettingsTab(),
  ];

  onNavbarTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screens[selectedIndex]
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF252525),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            haptic: true,
            backgroundColor: const Color(0xFF252525),
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            gap: 10,
            onTabChange: (index) {
              onNavbarTapped(index);
            },
            tabs: const [
              GButton(icon: Icons.home_outlined, text: 'Inicio'),
              GButton(icon: Icons.favorite_border, text: 'Minijuegos'),
              GButton(icon: Icons.shopping_cart_outlined, text: 'Tienda'),
              GButton(icon: Icons.settings_outlined, text: 'Ajustes'),
            ],
          ),
        ),
      ),
    );
  }
}