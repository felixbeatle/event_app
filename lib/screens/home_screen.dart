import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      body: SafeArea(
        child: Stack(
          children: [
            // Image from URL
            Positioned.fill(
              child: Image.asset(
                "assets/images/Accueil.jpg", // Ensure this path is correct
                fit: BoxFit.contain, // Cover the available space
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text('Could not load image'));
                },
              ),
            ),
            // "Inscrivez-vous ici" Button
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse("https://www.salondelapprentissage.ca/event-details/salon-de-lapprentissage-de-montreal2025");
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      print('Could not launch $url: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Black background
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Rectangular shape
                    ),
                  ),
                  child: Text(
                    "Inscrivez-vous ici",
                    style: TextStyle(color: Colors.white, fontSize: 20), // White text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}