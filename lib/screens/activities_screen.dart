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
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: 
                      Text(
                        "ACTIVITÉS",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ),
                      SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];
                            final emplacement = activity['emplacement'] ?? 'Emplacement inconnu';
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
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                                          ),
                                          child: Image.network(
                                            url,
                                            width: double.infinity,
                                            height: 500, // Fixed height
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
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
                      ),
                    ],
                  ),
                ),
    );
  }
}