import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      body: SafeArea(
        child: SingleChildScrollView(
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
              SizedBox(height: 5),
              // Centered button
              Center(
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
            ],
          ),
        ),
      ),
    );
  }
}