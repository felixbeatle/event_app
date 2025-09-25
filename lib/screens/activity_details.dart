import 'package:flutter/material.dart';
import 'package:event_app/controllers/favorite_controller.dart';
import 'package:event_app/services/exhibitor_service.dart'; // Import the ExhibitorService
import 'package:event_app/services/classe_de_reve_service.dart'; // Import the ClasseDeReveService
import 'package:cached_network_image/cached_network_image.dart'; // Import the CachedNetworkImage package
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'exhibitor_details_screen.dart'; // Import the ExhibitorDetailsScreen
import 'formulaire_screen.dart'; // Import the FormulaireScreen

class ActivityDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> activity;

  ActivityDetailsScreen({required this.activity});

  @override
  _ActivityDetailsScreenState createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  final FavoriteController _favoriteController = FavoriteController();
  final ClasseDeReveService _classeDeReveService = ClasseDeReveService();
  bool isFavoritesLoaded = false;
  List<String> classeDeReveImages = [];
  bool isLoadingImages = false;
  bool classedereve = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    if (widget.activity['title'] == "Le Grand Tirage – La Classe de Rêve") {
      classedereve = true;
      _loadClasseDeReveImages();
    } else {
      classedereve = false;
    }
  }

  Future<void> _loadFavorites() async {
    await _favoriteController.loadFavorites();
    setState(() {
      isFavoritesLoaded = true;
    });
  }

  Future<void> _loadClasseDeReveImages() async {
    setState(() {
      isLoadingImages = true;
    });
    try {
      final images = await _classeDeReveService.fetchClasseDeReveImages();
      images.sort((a, b) => a['number'].compareTo(b['number']));
      setState(() {
        classeDeReveImages = images.map<String>((image) => image['urlvisible']).toList();
        isLoadingImages = false;
      });
    } catch (e) {

      setState(() {
        isLoadingImages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double fontSizeTitle = isTablet ? 32 : 22;
    final double fontSizeSubtitle = isTablet ? 26 : 16;
    final double subsubtitle = isTablet ? 20 : 16;
    final double paddingValue = isTablet ? 30 : 15;
    final double imageHeight = isTablet ? 500 : 300;
    final double buttonFontSize = isTablet ? 20 : 16;
    final double buttonPaddingHorizontal = isTablet ? 20 : 10;
    final double buttonPaddingVertical = isTablet ? 10 : 5;
    final double iconSize = isTablet ? 48 : 32;

    final emplacement = widget.activity['emplacement'] ?? 'Emplacement inconnu';
    final url = widget.activity['imageUrlVisible'] ?? '';
    final title = widget.activity['title'] ?? 'Titre inconnu';
    final description = widget.activity['description'] ?? 'Aucune description disponible';
    final entreprise = widget.activity['entreprise'] ?? '';
    final entreprise2 = widget.activity['entreprise2'] ?? '';
    bool isentreprise2 = entreprise2.isNotEmpty;
    bool isentreprise = entreprise.isNotEmpty;

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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(50.0), // Add padding around the image
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                ),
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: fontSizeTitle, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            if (emplacement.isNotEmpty)
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 237, 24), // Color #fcd307
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Kiosque: $emplacement",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: subsubtitle,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  IconButton(
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
                  if (!isFavorite)
                    Text(
                      "Ajouter au favoris",
                      style: TextStyle(fontSize: subsubtitle, color: Colors.grey),
                    ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                description,
                style: TextStyle(fontSize: fontSizeSubtitle, color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 40),
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
                    isentreprise2 ? "VOIR TOYBOX" : "VOIR L'EXPOSANT",
                    style: TextStyle(color: Colors.white, fontSize: buttonFontSize), // White text with font size 16
                  ),
                ),
              ),
            SizedBox(height: 10),
            if (isentreprise2)
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
                      final exhibitor = await ExhibitorService().fetchExhibitorByEntreprise(entreprise2);
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
                    isentreprise2 ? "VOIR MINIMO" : "VOIR L'EXPOSANT",
                    style: TextStyle(color: Colors.white, fontSize: buttonFontSize), // White text with font size 16
                  ),
                ),
              ),
            if (classedereve) ...[
              SizedBox(height: 20),
              if (isLoadingImages)
                Center(child: CircularProgressIndicator())
              else
                for (var imageUrl in classeDeReveImages)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormulaireScreen(
                              activityTitle: widget.activity['title'] ?? 'Classe de Rêve',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
              // Message informatif
              SizedBox(height: 20),
              Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 237, 24).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color.fromARGB(255, 252, 237, 24), width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.touch_app, color: Colors.black, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Cliquez sur une image pour ouvrir le formulaire dans l'application",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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