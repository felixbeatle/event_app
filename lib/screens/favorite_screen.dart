import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:event_app/services/exhibitor_service.dart';
import 'package:event_app/services/activity_service.dart';
import 'package:event_app/services/conference_service.dart'; // Import ConferenceService
import 'package:event_app/screens/exhibitor_details_screen.dart';
import 'package:event_app/screens/activity_details.dart';
import 'package:event_app/screens/conference_details.dart'; // Import ConferenceDetailsScreen
import 'package:event_app/controllers/favorite_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<dynamic> exhibitors = [];
  List<dynamic> activities = [];
  List<dynamic> conferences = []; // Add conferences list
  bool isLoading = true;
  String errorMessage = '';
  final FavoriteController _favoriteController = FavoriteController();

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    await _favoriteController.loadFavorites();
    await loadExhibitors();
    await loadActivities();
    await loadConferences(); // Load conferences
  }

  Future<void> loadExhibitors() async {
    try {
      final data = await ExhibitorService().fetchExhibitors();
      
      // Filter exhibitors to only include favorites
      final favoriteExhibitors = data.where((exhibitor) {
        final entreprise = exhibitor['entreprise'] ?? '';
        return _favoriteController.isFavorite(entreprise);
      }).toList();

      setState(() {
        exhibitors = favoriteExhibitors;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("❌ Error loading exhibitors: $e");
    }
  }

  Future<void> loadActivities() async {
    try {
      final data = await ActivityService().fetchActivities();
      
      // Filter activities to only include favorites
      final favoriteActivities = data.where((activity) {
        final title = activity['title'] ?? '';
        return _favoriteController.isFavorite(title);
      }).toList();

      setState(() {
        activities = favoriteActivities;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("❌ Error loading activities: $e");
    }
  }

  Future<void> loadConferences() async {
    try {
      final data = await ConferenceService().fetchConferences();
      
      // Filter conferences to only include favorites
      final favoriteConferences = data.where((conference) {
        final title = conference['title'] ?? '';
        return _favoriteController.isFavorite(title);
      }).toList();

      setState(() {
        conferences = favoriteConferences;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("❌ Error loading conferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text("Erreur: $errorMessage"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(height: 25),
                      Center(
                        child: Center(child:
                        Text(
                          "Bienvenue dans votre liste de favoris!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          "Personnalisez votre expérience au Salon de l’apprentissage en un clin d'œil! Ajoutez vos exposants, conférences et activités préférés en un simple clic sur le cœur à côté de leur nom. C’est rapide, facile et vous garantit de ne rien manquer et de profiter au maximum de votre visite!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListView(
                        shrinkWrap: true, // Ensure the ListView takes only the necessary space
                        physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                        children: [
                          ...exhibitors.map((exhibitor) {
                            final entreprise = exhibitor['entreprise'] ?? 'Nom inconnu';
                            final logoUrl = exhibitor['urlImagePublique'] ?? '';

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ExhibitorDetailsScreen(exhibitor: exhibitor),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                                              ),
                                              child: Image.network(
                                                logoUrl,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                              child: Text(
                                                entreprise,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                _favoriteController.isFavorite(entreprise)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: _favoriteController.isFavorite(entreprise)
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _favoriteController.toggleFavorite(entreprise);
                                                  loadExhibitors(); // Refresh the list
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(), // Add a divider between each item
                              ],
                            );
                          }).toList(),
                          ...activities.map((activity) {
                            final title = activity['title'] ?? 'Titre inconnu';
                            final url = activity['imageUrlVisible'] ?? '';

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ActivityDetailsScreen(activity: activity),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                                              ),
                                              child: Image.network(
                                                url,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                              child: Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                _favoriteController.isFavorite(title)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: _favoriteController.isFavorite(title)
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _favoriteController.toggleFavorite(title);
                                                  loadActivities(); // Refresh the list
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(), // Add a divider between each item
                              ],
                            );
                          }).toList(),
                          ...conferences.map((conference) {
                            final title = conference['title'] ?? 'Titre inconnu';
                            final url = conference['url'] ?? '';

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ConferenceDetailsScreen(conference: conference),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                                              ),
                                              child: Image.network(
                                                url,
                                                width: double.infinity,

                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                              child: Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                _favoriteController.isFavorite(title)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: _favoriteController.isFavorite(title)
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _favoriteController.toggleFavorite(title);
                                                  loadConferences(); // Refresh the list
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(), // Add a divider between each item
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}