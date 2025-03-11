import 'package:flutter/material.dart';
import 'package:event_app/services/conference_service.dart';
import 'package:event_app/controllers/favorite_controller.dart'; // Import the FavoriteController
import 'conference_details.dart';

class ConferencesScreen extends StatefulWidget {
  @override
  _ConferencesScreenState createState() => _ConferencesScreenState();
}

class _ConferencesScreenState extends State<ConferencesScreen> {
  List<dynamic> conferences = [];
  bool isLoading = true;
  String errorMessage = '';
  final FavoriteController _favoriteController = FavoriteController();
  @override
  void initState() {
    super.initState();
    loadConferences();
    _favoriteController.loadFavorites(); // Load favorites
  }

  Future<void> loadConferences() async {
    try {
      final data = await ConferenceService().fetchConferences();
      print("Fetched conferences: $data");
      
      // Extract the day of the week from the 'jour' field and separate conferences into two lists
      final saturdayConferences = data.where((conference) {
        final jour = (conference['jour'] ?? '').toLowerCase();
        return jour.contains('samedi');
      }).toList();

      final sundayConferences = data.where((conference) {
        final jour = (conference['jour'] ?? '').toLowerCase();
        return jour.contains('dimanche');
      }).toList();

      print("Saturday conferences: $saturdayConferences");
      print("Sunday conferences: $sundayConferences");

      // Sort each list by hour
      saturdayConferences.sort((a, b) {
        final heureA = a['heure'] ?? '';
        final heureB = b['heure'] ?? '';
        final hourPartsA = heureA.split('h');
        final hourPartsB = heureB.split('h');
        final hourA = int.tryParse(hourPartsA[0]) ?? 0;
        final hourB = int.tryParse(hourPartsB[0]) ?? 0;
        final minuteA = hourPartsA.length > 1 ? int.tryParse(hourPartsA[1]) ?? 0 : 0;
        final minuteB = hourPartsB.length > 1 ? int.tryParse(hourPartsB[1]) ?? 0 : 0;

        if (hourA != hourB) {
          return hourA.compareTo(hourB);
        }
        return minuteA.compareTo(minuteB);
      });

      sundayConferences.sort((a, b) {
        final heureA = a['heure'] ?? '';
        final heureB = b['heure'] ?? '';
        final hourPartsA = heureA.split('h');
        final hourPartsB = heureB.split('h');
        final hourA = int.tryParse(hourPartsA[0]) ?? 0;
        final hourB = int.tryParse(hourPartsB[0]) ?? 0;
        final minuteA = hourPartsA.length > 1 ? int.tryParse(hourPartsA[1]) ?? 0 : 0;
        final minuteB = hourPartsB.length > 1 ? int.tryParse(hourPartsB[1]) ?? 0 : 0;

        if (hourA != hourB) {
          return hourA.compareTo(hourB);
        }
        return minuteA.compareTo(minuteB);
      });

      // Combine the two lists
      final sortedConferences = [...saturdayConferences, ...sundayConferences];
      print("Sorted conferences: $sortedConferences");

      setState(() {
        conferences = sortedConferences;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("Error loading conferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text("Erreur: $errorMessage"))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: conferences.length + 1, // Add one for the introductory text
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CONFÉRENCES EN SALLE RESERVÉES AUX DÉTENTEURS DE PASSEPORT VIP",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  "Le Salon de l’Apprentissage est fier de vous proposer des conférences inspirantes présentées par des professionnels de l’éducation et réservées aux détenteurs d’un Passeport VIP au coût de 35\$ / 1 jour ou 60\$ / 2 jours. D’une durée de 60 minutes, les conférences ont lieu dans des salles privées à proximité de la Salle d’exposition du Salon de l’Apprentissage. Découvrez des sujets d'actualités en lien avec l'éducation par des experts de divers domaines.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        );
                      }

                      final conference = conferences[index - 1];
                      final title = conference['title'] ?? 'Titre inconnu';
                      final jour = conference['jour'] ?? 'Jour inconnu';
                      final heure = conference['heure'] ?? 'Heure inconnue';
                      final url = conference['url'] ?? '';

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    jour,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    heure,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Image.network(
                                    url,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Center(child: 
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
                                      });
                                    },
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black, // Black background
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1), // Adjust button size
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0), // Rectangular shape
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConferenceDetailsScreen(conference: conference),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "En savoir plus",
                                      style: TextStyle(color: Colors.white, fontSize: 16), // White text with font size 16
                                    ),
                                  ),
                                ),
                              
                              ],
                            ),
                          ),
                          Divider(
                            color: const Color.fromARGB(255, 211, 211, 211), // Gray color
                            thickness: 1, // Thickness of the line
                          ),
                        ],
                      );
                    },
                  ),
                ),
    );
  }
}