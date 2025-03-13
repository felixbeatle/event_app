import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Accueil.jpg
          Image.asset(
            "assets/images/Accueil.jpg", // Ensure this image exists in assets/images
            width: double.infinity, // Full width
            height: 650, // Adjust height as needed
            fit: BoxFit.contain, // Cover the available space
          ),
          Spacer(), // Push the button to the bottom
          // "Inscrivez-vous ici" Button
          Center(
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
          Spacer(), // Push the button to the bottom
        ],
      ),
    );
  }
}