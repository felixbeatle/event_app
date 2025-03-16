import 'package:flutter/material.dart';
import 'package:event_app/services/activity_service.dart';
import 'activity_details.dart';
import 'package:event_app/controllers/favorite_controller.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<dynamic> activities = [];
  bool isLoading = true;
  String errorMessage = '';
  final FavoriteController _favoriteController = FavoriteController();

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    try {
      await _favoriteController.loadFavorites();
      final data = await ActivityService().fetchActivities();

      // Log the activities to see what is in the 'number' field
      data.forEach((activity) {
        print('Activity: ${activity['title']}, Number: ${activity['number']}');
      });

      // Sort the list by column number
      data.sort((a, b) {
        final columnA = double.tryParse((a['number'] ?? '0').toString()) ?? 0.0;
        final columnB = double.tryParse((b['number'] ?? '0').toString()) ?? 0.0;
        return columnA.compareTo(columnB);
      });

      setState(() {
        activities = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text("Erreur: $errorMessage"))
              : Padding(
                  padding: const EdgeInsets.only(top: 0), // Add 50px padding from the top
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
                        Center(
                          child: Text(
                            "ACTIVITÉS",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Nous sommes heureux de vous présenter les activités du Salon de l'apprentissage, des événements qui partagent nos objectifs, notre mission et qui s'impliquent activement dans leur milieu pour faire rayonner les valeurs entourant la réussite éducative et le bien-être des jeunes.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true, // Ensure the ListView takes only the necessary space
                          physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];
                            final url = activity['imageUrlVisible'] ?? '';
                            final title = activity['title'] ?? 'Titre inconnu';

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 2 / 3, // Adjust the aspect ratio as needed
                                            child: Image.network(
                                              url,
                                              width: double.infinity,
                                              fit: BoxFit.contain, // Ensure the image is fully visible
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black, // Black background
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Button size
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0), // Rectangular shape
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ActivityDetailsScreen(activity: activity),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "En savoir plus",
                                            style: TextStyle(color: Colors.white, fontSize: 16), // White text with font size 16
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Divider(
                                    color: const Color.fromARGB(255, 211, 211, 211), // Gray color
                                    thickness: 1, // Thickness of the line
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}