import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'exhibitors_screen.dart';
import 'conferences_screen.dart';
import 'favorites_screen.dart';
import 'ambassadors_screen.dart';
import 'activities_screen.dart';
import 'contributors_screen.dart'; // Import the ContributorsScreen

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AmbassadorsScreen(),
    ExhibitorsScreen(),
    ActivitiesScreen(),
    ConferencesScreen(),
    FavoritesScreen(),
    ContributorsScreen(), // Add ContributorsScreen here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  @override
  Widget build(BuildContext context) {
    bool showHeaderImage = _selectedIndex != 0; // Hide image on HomeScreen

    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(showHeaderImage ? 200 : kToolbarHeight), // Reduce height
        child: Stack(
          children: [
            if (showHeaderImage) // Show only when not on HomeScreen
              SizedBox(
                width: double.infinity, // Full width
                height: 300, // Reduce image size to half
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Header.jpg"),
                      fit: BoxFit.contain, // Keep full image without cropping
                      alignment: Alignment.center, // Center the image
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 20, // Adjust as needed
              left: 10, // Keep hamburger at the top left
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black, size: 60),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 50), // Spacer for header
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Accueil"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Ambassadeurs"),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text("Exposants"),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.local_activity),
              title: Text("Activités"),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text("Conférences"),
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favoris"),
              onTap: () => _onItemTapped(5),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Partenaires"),
              onTap: () => _onItemTapped(6),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}