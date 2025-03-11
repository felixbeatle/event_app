import 'package:flutter/material.dart';
import 'package:event_app/services/activity_service.dart';
import 'activity_details.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<dynamic> activities = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    try {
      final data = await ActivityService().fetchActivities();
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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ACTIVITÉS",
                        style: TextStyle(
                          fontSize: 18,
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

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center( 
                                    child: Text(
                                    jour,
                                    style: TextStyle(fontSize: 16, color: Colors.pink, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                
                                  SizedBox(height: 5),
                                  Center( 
                                    child:
                                      Text(
                                      horaire,
                                      style: TextStyle(fontSize: 16, color: Colors.pink, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center( 
                                    child:
                                    Container(
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
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Image.network(
                                      url,
                                      width: double.infinity,
                                      height: 500, // Fixed height
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: 
                                      Text(
                                        title,
                                        style: TextStyle(fontSize: 16, color: Colors.pink, fontWeight: FontWeight.bold),
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