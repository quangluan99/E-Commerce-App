import 'package:ecommerce_app/view/role_based_login/user/screens/user_app_home_screen.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20activity/Add%20to%20cart/screen/favorite_screen.dart';
import 'package:ecommerce_app/view/role_based_login/user/user%20profile%20/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UserAppMainScreen extends StatefulWidget {
  const UserAppMainScreen({super.key});

  @override
  State<UserAppMainScreen> createState() => _UserAppMainScreenState();
}

class _UserAppMainScreenState extends State<UserAppMainScreen> {
  int currentIndex = 0;

  void onTap(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  final List<Widget> pages = [
    const UserAppHomeScreen(),
    const FavoriteScreen(),
    const UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(currentIndex),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedFontSize: 16.0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black38,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.home,
                size: 28,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.heart,
                size: 28,
              ),
              label: 'Favorite'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 28,
              ),
              label: 'Nofication'),
        ],
      ),
    );
  }
}
