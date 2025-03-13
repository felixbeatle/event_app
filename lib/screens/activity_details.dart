import 'package:flutter/material.dart';
import 'package:event_app/controllers/favorite_controller.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> activity;

  ActivityDetailsScreen({required this.activity});

  @override
  _ActivityDetailsScreenState createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
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

    final emplacement = widget.activity['emplacement'] ?? 'Emplacement inconnu';
    final url = widget.activity['imageUrlVisible'] ?? '';
    final title = widget.activity['title'] ?? 'Titre inconnu';
    final description = widget.activity['description'] ?? 'Aucune description disponible';

    bool isFavorite = _favoriteController.isFavorite(title);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(300), // Adjust height as needed
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 227, 85), // Color #fcd307 with 0.5 opacity
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Kiosque: $emplacement",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
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
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                       
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                    ),
                    child: Image.network(
                      url,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 22, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}