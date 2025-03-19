import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:event_app/services/conference_service.dart';
import 'conference_details.dart';

class AmbassadorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> ambassador;

  AmbassadorDetailsScreen({required this.ambassador});

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
    final double spaceheight = isTablet ? 40 : 20;

    final name = ambassador['nom'] ?? 'Nom inconnu';
    final photoUrl = ambassador['photoambassadeur'] ?? '';
    final description = ambassador['texteAmbassadeur'] ?? 'Aucune description disponible';
    final note = ambassador['note'] ?? '';
    final titleConference1 = ambassador['CONFERENCETITLE'] ?? '';
    final titleConference2 = ambassador['conferencetitle2'] ?? '';
    final fonction = ambassador['fonction'] ?? '';
    final logo = ambassador['logo'] ?? '';
    final logolink = ambassador['url'] ?? '';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  "AMBASSADEURS 2025",
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.network(
                photoUrl,
                width: double.infinity,
                height: MediaQuery.of(context).size.width - 20, // Make the image square
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: spaceheight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  fonction,
                  style: TextStyle(fontSize: fontSizeSubtitle),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                description,
                style: TextStyle(fontSize: fontSizeSubtitle),
                textAlign: TextAlign.justify,
              ),
            ),
            if (note.isNotEmpty) ...[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  note,
                  style: TextStyle(fontSize: fontSizeSubtitle),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
            SizedBox(height: spaceheight),
            if (titleConference1.isNotEmpty) ...[
              SizedBox(height: 20),
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
                      final conference = await ConferenceService().fetchConferenceByTitle(titleConference1);
                      if (conference != null) {
                        print('Fetched Conference 1: $conference');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConferenceDetailsScreen(conference: conference),
                          ),
                        );
                      } else {
                        print('Conference not found');
                      }
                    } catch (e) {
                      print('Error fetching conference: $e');
                    }
                  },
                  child: Text(
                    titleConference2.isNotEmpty ? "VOIR LA CONFÉRENCE DU SAMEDI" : "VOIR LA CONFÉRENCE",
                    style: TextStyle(fontSize: buttonFontSize, color: Colors.white),
                  ),
                ),
              ),
            ],
            if (titleConference2.isNotEmpty) ...[
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
                    try {
                      print('titleConference2: $titleConference2');
                      final conference = await ConferenceService().fetchConferenceByTitle(titleConference2);
                      if (conference != null) {
                        print('Fetched Conference 2: $conference');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConferenceDetailsScreen(conference: conference),
                          ),
                        );
                      } else {
                        print('Conference not found');
                      }
                    } catch (e) {
                      print('Error fetching conference: $e');
                    }
                  },
                  child: Text(
                    "VOIR LA CONFÉRENCE DU DIMANCHE",
                    style: TextStyle(fontSize: buttonFontSize, color: Colors.white),
                  ),
                ),
              ),
            ],
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(logolink);
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      print('Could not launch $url: $e');
                    }
                  },
                  child: logo.isNotEmpty
                      ? Image.network(
                          logo,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(), // Return an empty container if there's an error
                        )
                      : Container(), // Return an empty container if urlImagePub is empty
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}