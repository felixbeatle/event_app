import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:event_app/services/exhibitor_service.dart';
import 'package:event_app/screens/exhibitor_details_screen.dart';
import 'package:event_app/controllers/favorite_controller.dart'; // Import the FavoriteController
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart'; // Import the CachedNetworkImage package

class ExhibitorsScreen extends StatefulWidget {
  @override
  _ExhibitorsScreenState createState() => _ExhibitorsScreenState();
}

class _ExhibitorsScreenState extends State<ExhibitorsScreen> {
  List<dynamic> exhibitors = [];
  bool isLoading = true;
  String errorMessage = '';
 

  @override
  void initState() {
    super.initState();
    loadExhibitors();
  }

  Future<void> loadExhibitors() async {
    try {
      final data = await ExhibitorService().fetchExhibitors();
      
      // Filter exhibitors - only keep those where 'include' is "true"
      final filteredData = data.where((exhibitor) {
        final includeValue = exhibitor['include']?.toString() ?? 'false';
        return includeValue.toLowerCase() == 'true';
      }).toList();
      
      // Sort exhibitors by the 'number' field
      filteredData.sort((a, b) {
        final columnA = double.tryParse((a['ordre'] ?? '0').toString()) ?? 0.0;
        final columnB = double.tryParse((b['ordre'] ?? '0').toString()) ?? 0.0;
        return columnA.compareTo(columnB);
      });

      setState(() {
        exhibitors = filteredData;
        isLoading = false;
      });
      
      // Simple logging - just name and number
      print('========== EXHIBITORS LIST ==========');
      print('Total exhibitors (after filtering): ${exhibitors.length}');
      print('Original data count: ${data.length}');
      for (int i = 0; i < exhibitors.length; i++) {
        final name = exhibitors[i]['title'] ?? 'Unknown';
        final includeValue = exhibitors[i]['include'];
        print('Exhibitor $i: $name (include: $includeValue)');
      }
      print('======================================');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    final double fontSizeTitle = isTablet ? 32 : 22;
    final double fontSizeSubtitle = isTablet ? 20 : 16;
    final double subsubtitle = isTablet ? 16 : 12;
    final double paddingValue = isTablet ? 30 : 15;
    final double imageHeight = isTablet ? 500 : 300;
    final double buttonFontSize = isTablet ? 20 : 16;
    final double buttonPaddingHorizontal = isTablet ? 20 : 10;
    final double buttonPaddingVertical = isTablet ? 10 : 5;

    print("📌 Rendering ListView with ${exhibitors.length} items");

    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text("Erreur: $errorMessage"))
              : Padding(
                  padding: const EdgeInsets.only(top: 0.0), // Add 50px padding from the top
                  child: SingleChildScrollView(
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
                        SizedBox(height: 20),
                        Center(child: 
                        Text(
                          "Cliquez sur les logos pour en savoir plus",
                          style: TextStyle(fontSize: subsubtitle, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        ),
                        SizedBox(height: 30),
                        ListView.builder(
                          shrinkWrap: true, // Ensure the ListView takes only the necessary space
                          physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                          itemCount: exhibitors.length,
                          itemBuilder: (context, index) {
                            final exhibitor = exhibitors[index];
                            
                            final entreprise = exhibitor['title'] ?? 'Nom inconnu';
                            final logoUrl = exhibitor['urlimagepublique'] ?? ''; // Use the actual logo URL or fallback to test URL
                            final partenaire = exhibitor['partenariat'] ?? '';

                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: paddingValue),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: 
                                        Center(child: 
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                                          ),
                                          child: logoUrl.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: logoUrl, // Use the actual logo URL
                                                  width: MediaQuery.of(context).size.width / (isTablet ? 2 : 1.5),
                                                  height: MediaQuery.of(context).size.width / (isTablet ? 2 : 1.5),
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                                )
                                              : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                        ),
                                      ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: paddingValue),
                                        alignment: Alignment.center, // Center the text
                                        child: Center(
                                          child: Text(
                                            entreprise,
                                            textAlign: TextAlign.center, // Center the text within the Text widget
                                            style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
                                            softWrap: true, // Ensure text wraps on whole words
                                            overflow: TextOverflow.visible, // Handle overflow gracefully
                                          ),
                                        ),
                                      ),
                                      if (partenaire.isNotEmpty)...[
                                         Center(child: 
                                            Text(
                                                  partenaire,
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: fontSizeSubtitle),
                                                ),
                                          ),
                                      ]
                                    ],
                                  ),
                                  
                                ),
                                SizedBox(height: 50),
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