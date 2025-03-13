import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:event_app/services/exhibitor_service.dart';
import 'package:event_app/screens/exhibitor_details_screen.dart';
import 'package:event_app/controllers/favorite_controller.dart'; // Import the FavoriteController
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExhibitorsScreen extends StatefulWidget {
  @override
  _ExhibitorsScreenState createState() => _ExhibitorsScreenState();
}

class _ExhibitorsScreenState extends State<ExhibitorsScreen> {
  List<dynamic> exhibitors = [];
  bool isLoading = true;
  String errorMessage = '';
  static const String testLogoUrl =
      "https://static.wixstatic.com/media/0025ee_725045c7d09d4de58fc9bf7cac135334~mv2.jpg/v1/fill/w_1080,h_1080,al_c,q_85,enc_auto/Troubadour%20-%20Logo.jpg";

  final FavoriteController _favoriteController = FavoriteController(); // Initialize the FavoriteController

  @override
  void initState() {
    super.initState();
    loadExhibitors();
    _favoriteController.loadFavorites(); // Load favorites
  }

Future<void> loadExhibitors() async {
  try {
    final data = await ExhibitorService().fetchExhibitors();
    
    // Log total number of exhibitors received
    print("🔹 Total exhibitors received: ${data.length}");

    // Log first few exhibitors to verify structure
    if (data.isNotEmpty) {
      print("🔹 First exhibitor sample: ${data.sublist(0, data.length > 3 ? 3 : data.length)}");
    }

    // Sort exhibitors by the 'number' field
    data.sort((a, b) {
      final columnA = double.tryParse((a['ordre'] ?? '0').toString()) ?? 0.0;
      final columnB = double.tryParse((b['ordre'] ?? '0').toString()) ?? 0.0;
      return columnA.compareTo(columnB);
    });

    setState(() {
      exhibitors = data;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      errorMessage = e.toString();
      isLoading = false;
    });
    print("❌ Error loading exhibitors: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    print("📌 Rendering ListView with ${exhibitors.length} items");

    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text("Erreur: $errorMessage"))
              : Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(child:Text(
                        "EXPOSANT ET PARTENAIRES",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Expanded(
                        child: ListView.builder(
                          itemCount: exhibitors.length,
                          itemBuilder: (context, index) {
                            final exhibitor = exhibitors[index];
                            
                            final entreprise = exhibitor['entreprise'] ?? 'Nom inconnu';
                            final logoUrl = exhibitor['urlImagePublique'] ?? testLogoUrl; // Use the actual logo URL or fallback to test URL
                            final partenaire = exhibitor['partenariat'] ?? '';

                            // Remove '[' and ']' from the partenariat text
                            final partenaireText = partenaire.replaceAll('[', '').replaceAll(']', '');

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExhibitorDetailsScreen(exhibitor: exhibitor),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                                          ),
                                          child: Image.network(
                                            logoUrl, // Use the actual logo URL
                                            width: MediaQuery.of(context).size.width / 2,
                                            height: MediaQuery.of(context).size.width / 2,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                                    alignment: Alignment.center, // Center the text
                                    child: Center(
                                      child: Text(
                                        entreprise,
                                        textAlign: TextAlign.center, // Center the text within the Text widget
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        softWrap: true, // Ensure text wraps on whole words
                                        overflow: TextOverflow.visible, // Handle overflow gracefully
                                      ),
                                    ),
                                  ),
                                  if (partenaireText.isNotEmpty)
                                      Positioned(
                                        top: 10,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          child: Text(
                                            partenaireText,
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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