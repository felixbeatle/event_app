import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:event_app/controllers/favorite_controller.dart';

class ExhibitorDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> exhibitor;

  ExhibitorDetailsScreen({required this.exhibitor});

  @override
  _ExhibitorDetailsScreenState createState() => _ExhibitorDetailsScreenState();
}

class _ExhibitorDetailsScreenState extends State<ExhibitorDetailsScreen> {
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
    final entreprise = widget.exhibitor['entreprise'] ?? 'Nom inconnu';
    final kiosque = widget.exhibitor['kiosque'] ?? 'N/A';
    final logoUrl = widget.exhibitor['urlImagePublique'] ?? '';
    final partenaire = widget.exhibitor['partenariat'] ?? '';
    final description = widget.exhibitor['partenaireSeulementDescription']?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ') ?? '';
    final partenaireText = partenaire.replaceAll('[', '').replaceAll(']', '');
    final siteInternetDeLEntreprise = widget.exhibitor['siteInternetDeLEntreprise'] ?? '';
    final urlPub = widget.exhibitor['urlPub'] ?? '';
    final urlImagePub = widget.exhibitor['imagePublicitaire'] ?? '';

    if (!isFavoritesLoaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "EXPOSANTS ET PARTENAIRES",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                  ),
                  child: Image.network(
                    logoUrl,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Partenaire
            if (partenaireText.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    partenaireText,
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            SizedBox(height: 10),

            // Entreprise
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  entreprise,
                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Kiosque
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 237, 24), // Color #fcd307 with 0.5 opacity
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Kiosque: $kiosque",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Favorite Icon
            IconButton(
              icon: Icon(
                _favoriteController.isFavorite(entreprise)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favoriteController.isFavorite(entreprise)
                    ? Colors.red
                    : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _favoriteController.toggleFavorite(entreprise);
                });
              },
            ),

            // Description
            if (description.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            SizedBox(height: 25),

            // Image Pub
            if (partenaire.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(urlPub);
                      print('Attempting to launch URL: $url');
                      if (await canLaunchUrl(url)) {
                        print('Launching URL: $url');
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        print('Could not launch URL: $url');
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.network(
                      urlImagePub,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

            if (siteInternetDeLEntreprise.isNotEmpty)
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
                    final url = Uri.parse(siteInternetDeLEntreprise);
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
                    "VOIR LE SITE INTERNET",
                    style: TextStyle(color: Colors.white, fontSize: 12), // White text with font size 16
                  ),
                ),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}