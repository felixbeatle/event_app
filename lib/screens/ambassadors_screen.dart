import 'package:flutter/material.dart';
import 'package:event_app/services/ambassador_service.dart';
import 'package:event_app/screens/ambassador_details.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the CachedNetworkImage package

class AmbassadorsScreen extends StatefulWidget {
  @override
  _AmbassadorsScreenState createState() => _AmbassadorsScreenState();
}

class _AmbassadorsScreenState extends State<AmbassadorsScreen> {
  List<dynamic> ambassadors = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadAmbassadors();
  }

  Future<void> loadAmbassadors() async {
    try {
      final data = await AmbassadorService().fetchAmbassadors();
      



      setState(() {
        ambassadors = data;
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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    final double fontSizeTitle = isTablet ? 32 : 22;
    final double fontSizeSubtitle = isTablet ? 20 : 16;
    final double paddingValue = isTablet ? 30 : 15;
    final double imageHeight = isTablet ? 500 : 300;
    final double buttonFontSize = isTablet ? 20 : 16;
    final double buttonPaddingHorizontal = isTablet ? 20 : 10;
    final double buttonPaddingVertical = isTablet ? 10 : 5;

    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
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
                            "AMBASSADEURS 2025",
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Nous sommes heureux de vous présenter les ambassadeurs du Salon de l'apprentissage, des personnalités publiques qui partagent nos objectifs, notre mission et qui s'impliquent activement dans leur milieu pour faire rayonner les valeurs entourant la réussite éducative et le bien-être des jeunes.",
                          style: TextStyle(
                            fontSize: fontSizeSubtitle,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true, // Ensure the ListView takes only the necessary space
                          physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                          itemCount: ambassadors.length,
                          itemBuilder: (context, index) {
                            final ambassador = ambassadors[index];
                            final name = ambassador['nom'] ?? 'Nom inconnu';
                            final photoUrl = ambassador['photoambassadeur'] ?? '';
                            final fonction = ambassador['fonction'] ?? '';
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: paddingValue),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: photoUrl,
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.width / 2,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            name,
                                            style: TextStyle(fontSize: fontSizeTitle),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            fonction,
                                            style: TextStyle(fontSize: fontSizeSubtitle),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black, // Black background
                                              padding: EdgeInsets.symmetric(horizontal: buttonPaddingHorizontal, vertical: buttonPaddingVertical), // Button size
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0), // Rectangular shape
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AmbassadorDetailsScreen(ambassador: ambassador),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "En savoir plus",
                                              style: TextStyle(
                                                color: Colors.white, // White text
                                                fontSize: buttonFontSize,
                                              ),
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