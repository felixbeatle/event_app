import 'package:flutter/material.dart';
import 'package:event_app/services/exhibitor_service.dart';
import 'package:event_app/screens/exhibitor_details_screen.dart';

class ContributorsScreen extends StatefulWidget {
  @override
  _ContributorsScreenState createState() => _ContributorsScreenState();
}

class _ContributorsScreenState extends State<ContributorsScreen> {
  List<dynamic> exhibitors = [];
  bool isLoading = true;
  String errorMessage = '';
  static const String testLogoUrl =
      "https://static.wixstatic.com/media/0025ee_725045c7d09d4de58fc9bf7cac135334~mv2.jpg/v1/fill/w_1080,h_1080,al_c,q_85,enc_auto/Troubadour%20-%20Logo.jpg";

  @override
  void initState() {
    super.initState();
    loadExhibitors();
  }

  Future<void> loadExhibitors() async {
    try {
      final data = await ExhibitorService().fetchExhibitors();
      
      // Log total number of exhibitors received
      print("🔹 Total exhibitors received: ${data.length}");

      // Filter exhibitors to only include partners
      final partners = data.where((exhibitor) => exhibitor['partenariat'] != null && exhibitor['partenariat'].isNotEmpty).toList();

      // Log first few partners to verify structure
      if (partners.isNotEmpty) {
        print("🔹 First partner sample: ${partners.sublist(0, partners.length > 3 ? 3 : partners.length)}");
      }

      setState(() {
        exhibitors = partners;
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
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PARTENAIRES",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: exhibitors.length,
                          itemBuilder: (context, index) {
                            final exhibitor = exhibitors[index];
                            
                            final entreprise = exhibitor['entreprise'] ?? 'Nom inconnu';
                            final kiosque = exhibitor['kiosque'] ?? 'N/A';
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
                                        Image.network(
                                          logoUrl, // Use the actual logo URL
                                          width: MediaQuery.of(context).size.width / 2,
                                          height: MediaQuery.of(context).size.width / 2,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
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
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      child: Text(
                                        partenaireText,
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 227, 85), // Color #fcd307 with 0.5 opacity
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