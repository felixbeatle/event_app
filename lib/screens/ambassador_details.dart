import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:event_app/services/conference_service.dart';
import 'conference_details.dart';

class AmbassadorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> ambassador;

  AmbassadorDetailsScreen({required this.ambassador});

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 32),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    "AMBASSADEURS 2025",
                    style: TextStyle(
                      fontSize: 22,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  fonction,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
              if (note.isNotEmpty) ...[
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    note,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
              if (titleConference1.isNotEmpty) ...[
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black background
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1), // Button size
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
                      style: TextStyle(fontSize: 12, color: Colors.white),
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
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1), // Button size
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
                      style: TextStyle(fontSize: 12, color: Colors.white),
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
      ),
    );
  }
}