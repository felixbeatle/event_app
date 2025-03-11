import 'package:flutter/material.dart';

class ConferenceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> conference;

  ConferenceDetailsScreen({required this.conference});

  @override
  Widget build(BuildContext context) {
    final jour = conference['jour'] ?? 'Jour inconnu';
    final heure = conference['heure'] ?? 'Heure inconnue';
    final url = conference['url'] ?? '';
    final salle = conference['salle'] ?? 'Salle inconnue';
    final description = conference['description'] ?? 'Aucune description disponible';
    final nomDuConferencier = conference['nomDuConferencier'] ?? 'Nom inconnu';
    final fonction = conference['fonction'] ?? 'Fonction inconnue';
    final bio = conference['bio'] ?? 'Aucune biographie disponible';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200), // Adjust height as needed
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
              Image.network(
                url,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jour + ' ',
                  style: TextStyle(fontSize: 16, color: Colors.pink),
                ),
                Text(
                  heure,
                  style: TextStyle(fontSize: 16, color: Colors.pink),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                salle,
                style: TextStyle(fontSize: 16, color: Colors.pink),
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Center(child:
              Text(
                nomDuConferencier,
                style: TextStyle(fontSize: 16, color: Colors.pink),
                textAlign: TextAlign.center,
              ),
            ),
            Center(child: 
              Text(
              fonction,
              style: TextStyle(fontSize: 14, color: Colors.pink),
              textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Text(
              bio,
              style: TextStyle(fontSize: 12, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}