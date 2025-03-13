import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'exhibitors_screen.dart';
import 'conferences_screen.dart';
import 'favorite_screen.dart'; // Import the FavoriteScreen
import 'ambassadors_screen.dart';
import 'activities_screen.dart';
import 'contributors_screen.dart'; // Import the ContributorsScreen
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

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
    FavoriteScreen(), // Add FavoriteScreen here
    ContributorsScreen(), // Add ContributorsScreen here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showHeaderImage = _selectedIndex != 0; // Hide image on HomeScreen

    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(showHeaderImage ? 325 : kToolbarHeight), // Adjust height to include spacer
        child: Stack(
          children: [
            if (showHeaderImage) // Show only when not on HomeScreen
              Column(
                children: [
                  SizedBox(height: 50), // Add space above the header image
                  SizedBox(
                    width: double.infinity, // Full width
                    height: 300, // Adjust image height
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
                ],
              ),
            Positioned(
              top: 20, // Adjust as needed
              left: 10, // Keep hamburger at the top left
              child: SafeArea(
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.black, size: 30), // Adjust size as needed
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255), // Set the background color of the drawer to a custom color
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 50), // Spacer for header
              ListTile(
                leading: Icon(Icons.home, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Accueil", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(0),
              ),
              ListTile(
                leading: Icon(Icons.people, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Ambassadeurs", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(1),
              ),
              ListTile(
                leading: Icon(Icons.star, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Exposants", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(2),
              ),
              ListTile(
                leading: Icon(Icons.play_circle_sharp, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Activités", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(3),
              ),
              ListTile(
                leading: Icon(Icons.mic, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Conférences", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(4),
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Favoris", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(5),
              ),
              ListTile(
                leading: Icon(Icons.handshake, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Partenaires", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(6),
              ),
              ListTile(
                leading: Icon(Icons.map, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Plan de salle", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () async {
                  Navigator.pop(context); // Close the drawer
                  final url = Uri.parse("https://drive.google.com/file/d/112UnQGMfF4D2dj9Vd5cBNDy14ZYQs6Eg/view");
                     try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      print('Could not launch $url: $e');
                    }
                },
              ),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}