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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250), // Adjust height as needed
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
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
            Positioned(
              top: 30,
              left: 10,
              child: Builder(
                builder: (context) => IconButton(
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child:  Text(
              "AMBASSADEURS 2025",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, )
              ,textAlign: TextAlign.center,
            ),
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
                child:
                
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(detailsUrl);
                  print('Attempting to launch URL: $url');
                  if (await canLaunchUrl(url)) {
                    print('Launching URL: $url');
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    print('Could not launch URL: $url');
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  "En savoir plus",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            ],

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}