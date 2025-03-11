import 'package:flutter/material.dart';
import 'package:event_app/services/ambassador_service.dart';
import 'package:event_app/screens/ambassador_details.dart';

class AmbassadorsScreen extends StatefulWidget {
  @override
  _AmbassadorsScreenState createState() => _AmbassadorsScreenState();
}

class _AmbassadorsScreenState extends State<AmbassadorsScreen> {
  List<dynamic> ambassadors = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadAmbassadors();
  }

  Future<void> loadAmbassadors() async {
    try {
      final data = await AmbassadorService().fetchAmbassadors();
      
      // Log total number of ambassadors received
      print("🔹 Total ambassadors received: ${data.length}");

      // Log first few ambassadors to verify structure
      if (data.isNotEmpty) {
        print("🔹 First ambassador sample: ${data.sublist(0, data.length > 3 ? 3 : data.length)}");
      }

      setState(() {
        ambassadors = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("❌ Error loading ambassadors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("📌 Rendering ListView with ${ambassadors.length} items");

    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
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
                        "AMBASSADEURS 2025",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Nous sommes heureux de vous présenter les ambassadeurs du Salon de l'apprentissage, des personnalités publiques qui partagent nos objectifs, notre mission et qui s'impliquent activement dans leur milieu pour faire rayonner les valeurs entourant la réussite éducative et le bien-être des jeunes.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: ambassadors.length,
                          itemBuilder: (context, index) {
                            final ambassador = ambassadors[index];
                            final name = ambassador['nom'] ?? 'Nom inconnu';
                            final photoUrl = ambassador['photoambassadeur'] ?? '';

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                children: [
                                  Image.network(
                                    photoUrl,
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.width / 2,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(fontSize: 18),textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AmbassadorDetailsScreen(ambassador: ambassador),
                                              ),
                                            );
                                          },
                                           child: Center(
                                            child: Text(
                                              "En savoir plus",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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