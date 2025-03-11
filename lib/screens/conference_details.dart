import 'package:flutter/material.dart';
import 'package:event_app/controllers/favorite_controller.dart'; // Import the FavoriteController

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
    final title = widget.conference['title'] ?? 'Titre inconnu';
    final jour = widget.conference['jour'] ?? 'Jour inconnu';
    final heure = widget.conference['heure'] ?? 'Heure inconnue';
    final url = widget.conference['url'] ?? '';
    final salle = widget.conference['salle'] ?? 'Salle inconnue';
    final description = widget.conference['description'] ?? 'Aucune description disponible';
    final nomDuConferencier = widget.conference['nomDuConferencier'] ?? 'Nom inconnu';
    final fonction = widget.conference['fonction'] ?? 'Fonction inconnue';
    final bio = widget.conference['bio'] ?? 'Aucune biographie disponible';

    if (!isFavoritesLoaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
              ),
              child: Image.network(
                url,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jour + ' ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  heure,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: IconButton(
                icon: Icon(
                  _favoriteController.isFavorite(title)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _favoriteController.isFavorite(title)
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _favoriteController.toggleFavorite(title);
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                nomDuConferencier,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                fonction,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Text(
              bio,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}