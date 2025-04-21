import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final UserModel user;
  
  const BottomNavScreen({Key? key, required this.user}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 3; // Start with profile selected (last tab)
  late List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    // Initialize screens with user model
    _screens = [
      // Placeholder screens - will be replaced later
      Center(child: Text('Home')),
      Center(child: Text('Search')),
      Center(child: Text('Add')),
      ProfileScreen(user: widget.user), // Profile screen with user data
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // This prevents shifting animation with 4+ items
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false, // Instagram-like - no labels
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person), // Solid icon when selected
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}