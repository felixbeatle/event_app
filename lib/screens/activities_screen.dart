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
      
      // Sort activities by day and hours
      data.sort((a, b) {
        final dayOrder = {'samedi': 1, 'dimanche': 2};
        final jourA = a['jour'] ?? '';
        final jourB = b['jour'] ?? '';
        final horaireA = a['horaire'] ?? '';
        final horaireB = b['horaire'] ?? '';

        // Compare days
        final dayComparison = (dayOrder[jourA] ?? 3).compareTo(dayOrder[jourB] ?? 3);
        if (dayComparison != 0) {
          return dayComparison;
        }

        // Compare hours
        final hourA = int.tryParse(horaireA.split(' ')[0]) ?? 0;
        final hourB = int.tryParse(horaireB.split(' ')[0]) ?? 0;
        return hourA.compareTo(hourB);
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

  void _toggleFavorite(String title) {
    setState(() {
      _favoriteController.toggleFavorite(title);
    });
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
                      Text(
                        "ACTIVITÉS",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];
                            final jour = activity['jour'] ?? 'Jour inconnu';
                            final horaire = activity['horaire'] ?? 'Horaire inconnu';
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
                                      Center(
                                        child: Text(
                                          jour,
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          horaire,
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                      
                                    
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
                                        ),
                                      ),
                                      SizedBox(height: 10),
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
                                            _toggleFavorite(title);
                                          },
                                        ),
                                      ),
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