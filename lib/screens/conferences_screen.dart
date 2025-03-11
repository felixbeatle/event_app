import 'package:flutter/material.dart';
import 'package:event_app/services/conference_service.dart';
import 'conference_details.dart';

class ConferencesScreen extends StatefulWidget {
  @override
  _ConferencesScreenState createState() => _ConferencesScreenState();
}

class _ConferencesScreenState extends State<ConferencesScreen> {
  List<dynamic> conferences = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadConferences();
  }

  Future<void> loadConferences() async {
    try {
      final data = await ConferenceService().fetchConferences();
      setState(() {
        conferences = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "CONFÉRENCES EN SALLE RESERVÉES AUX DÉTENTEURS DE PASSEPORT VIP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Center(
                          child: Text(
                            "Le Salon de l’Apprentissage est fier de vous proposer des conférences inspirantes présentées par des professionnels de l’éducation et réservées aux détenteurs d’un Passeport VIP au coût de 35\$ / 1 jour ou 60\$ / 2 jours. D’une durée de 60 minutes, les conférences ont lieu dans des salles privées à proximité de la Salle d’exposition du Salon de l’Apprentissage. Découvrez des sujets d'actualités en lien avec l'éducation par des experts de divers domaines.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: conferences.length,
                          itemBuilder: (context, index) {
                            final conference = conferences[index];
                            final jour = conference['jour'] ?? 'Jour inconnu';
                            final heure = conference['heure'] ?? 'Heure inconnue';
                            final url = conference['url'] ?? '';

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      jour,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      heure,
                                      style: TextStyle(fontSize: 16),
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
                                  SizedBox(height: 10),
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}