import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'exhibitors_screen.dart';
import 'conferences_screen.dart';
import 'favorite_screen.dart'; // Import the FavoriteScreen
import 'ambassadors_screen.dart';
import 'activities_screen.dart';
import 'contributors_screen.dart'; // Import the ContributorsScreen
import 'activity_details.dart'; // Import for Classe de Rêve navigation
import 'package:event_app/services/activity_service.dart'; // Import ActivityService
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
    ContributorsScreen(), // Add ContributorsScreen here
    FavoriteScreen(), // Add FavoriteScreen here
  ];

  @override
  void initState() {
    super.initState();
    // Check for app updates after the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  /// Check for app updates
  Future<void> _checkForUpdates() async {
    try {
      // Version checking removed to fix iOS binary rejection
      // Apple doesn't allow external version checking that bypasses App Store
    } catch (e) {
      print('Error checking for updates: $e');
      // Silently fail - don't bother user with update check errors
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _navigateToClasseDeReve() async {
    Navigator.pop(context); // Close the drawer
    try {
      final ActivityService activityService = ActivityService();
      final activities = await activityService.fetchActivities();
      
      // Find the "Le Grand Tirage – La Classe de Rêve" activity
      final classeDeReveActivity = activities.firstWhere(
        (activity) => activity['title'] == "Le Grand Tirage – La Classe de Rêve",
        orElse: () => null,
      );
      
      if (classeDeReveActivity != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailsScreen(activity: classeDeReveActivity),
          ),
        );
      } else {
        // Show error message if activity not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Classe de Rêve non trouvée"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error loading Classe de Rêve: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors du chargement de la Classe de Rêve"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 50), // Adjust the size of the hamburger icon
      ),
      body: _screens[_selectedIndex],
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
                title: Text("Activités familiales", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(3),
              ),
                 ListTile(
                leading: Icon(Icons.map, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Horaire samedi", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () async {
                  Navigator.pop(context); // Close the drawer
                  final url = Uri.parse("https://drive.google.com/file/d/1zLaRkMsMfnysEoNZqQSLeChFlvub3HT8/view");
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    print('Could not launch $url: $e');
                  }
                },
              ),
                 ListTile(
                leading: Icon(Icons.map, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Horaire dimanche", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () async {
                  Navigator.pop(context); // Close the drawer
                  final url = Uri.parse("https://drive.google.com/file/d/11bQbU7ytftqz0EKeQL8IHkQoyoq7rzlx/view");
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    print('Could not launch $url: $e');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.mic, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Conférences VIP", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(4),
              ),
              ListTile(
                leading: Icon(Icons.handshake, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Partenaires", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(5),
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
              ListTile(
                leading: Icon(Icons.my_library_books, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Cahier des visiteurs", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () async {
                  Navigator.pop(context); // Close the drawer
                  final url = Uri.parse("https://drive.google.com/file/d/1uryOPuDiavV_r0hVvZ-YRk9HBFG-EhGP/view");
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    print('Could not launch $url: $e');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Favoris", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _onItemTapped(6),
              ),
                ListTile(
                leading: Icon(Icons.book, color: const Color.fromARGB(255, 0, 0, 0)),
                title: Text("Classe de rêve", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                onTap: () => _navigateToClasseDeReve(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}