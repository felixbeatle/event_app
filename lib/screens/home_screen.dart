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
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Image at the top
                  Image.asset(
                    "assets/images/Acceuil.jpg", // Ensure this path is correct
                    fit: BoxFit.contain, // Keep full image without cropping
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Could not load image'));
                    },
                  ),
                  SizedBox(height: 100), // Extra space for the overlaid button
                ],
              ),
            ),
            // Gradient overlay with button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 75, // Height of the gradient area
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.0), // Transparent at top
                      Colors.white.withValues(alpha: 0.5), // Slight fade
                      Colors.white.withValues(alpha: 0.9), // More visible
                      Colors.white, // Full white at bottom
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse("https://www.salondelapprentissage.ca/billetterie");
                        try {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          print('Could not launch $url: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black background
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15), // Slightly larger button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // Rectangular shape
                        ),
                        elevation: 8, // Add shadow for better visibility
                      ),
                      child: Text(
                        "Inscrivez-vous ici",
                        style: TextStyle(color: Colors.white, fontSize: 20), // White text
                      ),
                    ),
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