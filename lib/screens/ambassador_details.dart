import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AmbassadorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> ambassador;

  AmbassadorDetailsScreen({required this.ambassador});

  @override
  Widget build(BuildContext context) {
    final name = ambassador['nom'] ?? 'Nom inconnu';
    final photoUrl = ambassador['photoambassadeur'] ?? '';
    final description = ambassador['texteAmbassadeur']?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ') ?? 'Aucune description disponible';
    final note = ambassador['note']?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ') ?? '';
    final detailsUrl = ambassador['dtailsConfrences'] ?? '';
    final fonction = ambassador['fonction'] ?? '';
    final logo = ambassador['logo'] ?? '';
    final logolink = ambassador['url'] ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(325), // Adjust height as needed
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                height: 50, // Add space above the header image
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 50, // Adjust the position of the image
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Header.jpg"),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: SafeArea(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(child:
              Text(
                "AMBASSADEURS 2025",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),),
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
            if (detailsUrl.isNotEmpty) ...[
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
                    final url = Uri.parse(detailsUrl);
                     try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    print('Could not launch $url: $e');
                  }
                  },
                  child: Text(
                    "Voir la Conférence",
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
    );
  }
}