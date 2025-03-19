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
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    final double fontSizeTitle = isTablet ? 32 : 22;
    final double fontSizeSubtitle = isTablet ? 25 : 16;
    final double subsubtitle = isTablet ? 20 : 16;
    final double paddingValue = isTablet ? 30 : 15;
    final double imageHeight = isTablet ? 500 : 300;
    final double buttonFontSize = isTablet ? 20 : 16;
    final double buttonPaddingHorizontal = isTablet ? 20 : 10;
    final double buttonPaddingVertical = isTablet ? 10 : 5;
    final double iconSize = isTablet ? 48 : 32;

    final entreprise = widget.exhibitor['entreprise'] ?? 'Nom inconnu';
    final kiosque = widget.exhibitor['kiosque'] ?? 'N/A';
    final logoUrl = widget.exhibitor['urlImagePublique'] ?? '';
    final partenaire = widget.exhibitor['partenariat'] ?? '';
    final description = widget.exhibitor['partenaireSeulementDescription'] ?? '';
    final siteInternetDeLEntreprise = widget.exhibitor['siteInternetDeLEntreprise'] ?? '';
    final urlPub = widget.exhibitor['urlPub'] ?? '';
    final urlImagePub = widget.exhibitor['imagePubVisible'] ?? '';

    if (!isFavoritesLoaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    bool isFavorite = _favoriteController.isFavorite(entreprise);

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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                "EXPOSANTS ET PARTENAIRES",
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                  ),
                  child: Image.network(
                    logoUrl,
                    width: MediaQuery.of(context).size.width / (isTablet ? 2 : 1.5),
                    height: MediaQuery.of(context).size.width / (isTablet ? 2 : 1.5),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            if (siteInternetDeLEntreprise.isNotEmpty) ...[
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 177, 177, 177), // Black background
                    padding: EdgeInsets.symmetric(horizontal: buttonPaddingHorizontal, vertical: buttonPaddingVertical), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Rectangular shape
                    ),
                  ),
                  onPressed: () async {
                    final url = Uri.parse(siteInternetDeLEntreprise);
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      print('Could not launch $url: $e');
                    }
                  },
                  child: Text(
                    "VOIR LE SITE INTERNET",
                    style: TextStyle(color: Colors.white, fontSize: buttonFontSize), // White text with font size 16
                  ),
                ),
              ),
            ],
            if (partenaire.isNotEmpty) ...[
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    partenaire,
                    style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  entreprise,
                  style: TextStyle(fontSize: fontSizeTitle, color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10),
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
                      fontSize: subsubtitle,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _favoriteController.toggleFavorite(entreprise);
                });
              },
            ),
            if (!isFavorite)
              Text(
                "Ajouter au favoris",
                style: TextStyle(fontSize: subsubtitle, color: Colors.grey),
              ),
            SizedBox(height: 20),
            if (description.isNotEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.black, fontSize: fontSizeSubtitle),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
            if (partenaire.isNotEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(urlPub);
                      try {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } catch (e) {
                        print('Could not launch $url: $e');
                      }
                    },
                    child: urlImagePub.isNotEmpty
                        ? Image.network(
                            urlImagePub,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(), // Return an empty container if there's an error
                          )
                        : Container(), // Return an empty container if urlImagePub is empty
                  ),
                ),
              ),
            ],
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}