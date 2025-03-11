import 'package:flutter/material.dart';

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

          SizedBox(height: 25), // Space between image and button

          // "Inscrivez-vous ici" Button
          ElevatedButton(
            onPressed: () {
              // TODO: Add action when button is clicked
              print("Inscription button clicked!");
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
        ],
      ),
    );
  }
}
