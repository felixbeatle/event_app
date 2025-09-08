import 'package:flutter/material.dart';
import 'package:event_app/services/conference_service.dart';
import 'package:event_app/controllers/favorite_controller.dart'; // Import the FavoriteController
import 'package:cached_network_image/cached_network_image.dart'; // Import the CachedNetworkImage package
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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    final double fontSizeTitle = isTablet ? 32 : 22;
    final double fontSizeSubtitle = isTablet ? 20 : 16;
    final double paddingValue = isTablet ? 30 : 15;
    final double imageHeight = isTablet ? 500 : 300;
    final double buttonFontSize = isTablet ? 20 : 16;
    final double buttonPaddingHorizontal = isTablet ? 20 : 10;
    final double buttonPaddingVertical = isTablet ? 10 : 5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text("Erreur: $errorMessage"))
              : Padding(
                  padding: const EdgeInsets.only(top: 0.0), // Add 50px padding from the top
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity, // Full width
                              height: imageHeight, // Adjust image height
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
                              fontSize: fontSizeTitle,
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
                              fontSize: fontSizeSubtitle,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
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

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color.fromARGB(255, 180, 180, 180), width: 1.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: paddingValue),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: paddingValue),
                                        child: Center(
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: paddingValue),
                                        child: Center(
                                          child: Text(
                                            jour,
                                            style: TextStyle(fontSize: fontSizeSubtitle),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: paddingValue),
                                        child: Center(
                                          child: Text(
                                            heure,
                                            style: TextStyle(fontSize: fontSizeSubtitle),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: paddingValue),
                                        child: CachedNetworkImage(
                                          imageUrl: url,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black, // Black background
                                            padding: EdgeInsets.symmetric(horizontal: buttonPaddingHorizontal, vertical: buttonPaddingVertical), // Adjust button size
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
                                            style: TextStyle(color: Colors.white, fontSize: buttonFontSize), // White text with font size 16
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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