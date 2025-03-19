import 'package:flutter/material.dart';
import 'package:event_app/controllers/favorite_controller.dart'; // Import the FavoriteController
import 'package:event_app/services/exhibitor_service.dart'; // Import the ExhibitorService
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'exhibitor_details_screen.dart'; // Import the ExhibitorDetailsScreen

class ConferenceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> conference;

  ConferenceDetailsScreen({required this.conference});

  @override
  _ConferenceDetailsScreenState createState() => _ConferenceDetailsScreenState();
}

class _ConferenceDetailsScreenState extends State<ConferenceDetailsScreen> {
  final FavoriteController _favoriteController = FavoriteController();
  bool isFavoritesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await _favoriteController.loadFavorites();
    setState(() {
      isFavoritesLoaded = true;
    });
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
    final double iconSize = isTablet ? 48 : 32;

    final title = widget.conference['title'] ?? 'Titre inconnu';
    final jour = widget.conference['jour'] ?? 'Jour inconnu';
    final heure = widget.conference['heure'] ?? 'Heure inconnue';
    final url = widget.conference['url'] ?? '';
    final salle = widget.conference['salle'] ?? 'Salle inconnue';
    final description = widget.conference['description'] ?? 'Aucune description disponible';
    final nomDuConferencier = widget.conference['nomDuConferencier'] ?? 'Nom inconnu';
    final fonction = widget.conference['fonction'] ?? 'Fonction inconnue';
    final bio = widget.conference['bio'] ?? 'Aucune biographie disponible';
    final entreprise = widget.conference['entreprise'] ?? '';
    bool isentreprise = entreprise.isNotEmpty;

    if (!isFavoritesLoaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    bool isFavorite = _favoriteController.isFavorite(title);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: iconSize),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jour + ' ',
                  style: TextStyle(fontSize: fontSizeSubtitle, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  heure,
                  style: TextStyle(fontSize: fontSizeSubtitle, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 252, 237, 24), // Color #fcd307
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  salle,
                  style: TextStyle(fontSize: fontSizeSubtitle, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _favoriteController.toggleFavorite(title);
                      });
                    },
                  ),
                  if (!isFavorite)
                    Text(
                      "Ajouter au favoris",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                nomDuConferencier,
                style: TextStyle(fontSize: fontSizeSubtitle, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                fonction,
                style: TextStyle(fontSize: fontSizeSubtitle, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Text(
              bio,
              style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                "PROCUREZ VOUS UN PASSEPORT VIP",
                style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Black background
                  padding: EdgeInsets.symmetric(horizontal: buttonPaddingHorizontal, vertical: buttonPaddingVertical), // Button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Rectangular shape
                  ),
                ),
                onPressed: () async {
                  final url = Uri.parse("https://www.salondelapprentissage.ca/event-details/salon-de-lapprentissage-de-montreal2025");
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    print('Could not launch $url: $e');
                  }
                },
                child: Text(
                  "ICI",
                  style: TextStyle(fontSize: buttonFontSize, color: Colors.white), // Text color
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isentreprise)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Black background
                    padding: EdgeInsets.symmetric(horizontal: buttonPaddingHorizontal, vertical: buttonPaddingVertical), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Rectangular shape
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final exhibitor = await ExhibitorService().fetchExhibitorByEntreprise(entreprise);
                      if (exhibitor != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExhibitorDetailsScreen(exhibitor: exhibitor),
                          ),
                        );
                      } else {
                        print('Exhibitor not found');
                      }
                    } catch (e) {
                      print('Error fetching exhibitor: $e');
                    }
                  },
                  child: Text(
                    "VOIR L'EXPOSANT",
                    style: TextStyle(fontSize: buttonFontSize, color: Colors.white), // Text color
                  ),
                ),
              ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}