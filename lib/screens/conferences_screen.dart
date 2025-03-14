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

      // Log the conferences to see what is in the 'number' field
      data.forEach((conference) {
        print('Conference: ${conference['title']}, Number: ${conference['ordre']}');
      });

      // Sort the list by column number
      data.sort((a, b) {
        final columnA = double.tryParse((a['ordre'] ?? '0').toString()) ?? 0.0;
        final columnB = double.tryParse((b['ordre'] ?? '0').toString()) ?? 0.0;
        return columnA.compareTo(columnB);
      });

      setState(() {
        conferences = data;
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
                  padding: const EdgeInsets.only(top: 0.0), // Add 50px padding from the top
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
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
                        Center(
                          child: Text(
                            "CONFÉRENCES EN SALLE",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Text(
                            "RESERVÉES AUX DÉTENTEURS DE PASSEPORT VIP",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
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
                        ListView.builder(
                          shrinkWrap: true, // Ensure the ListView takes only the necessary space
                          physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                          itemCount: conferences.length,
                          itemBuilder: (context, index) {
                            final conference = conferences[index];
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
                                        child: 
                                        Center(child:
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: 
                                        Center(child:
                                          Text(
                                            jour,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: 
                                        Center(child: 
                                        Text(
                                          heure,
                                          style: TextStyle(fontSize: 20),
                                        ),
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
                                      SizedBox(height: 20),
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
                      ],
                    ),
                  ),
                ),
    );
  }
}