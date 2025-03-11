import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Explicitly set to white
      appBar: AppBar(title: Text("Favoris")),
      body: Center(
        child: Text("Vos favoris apparaîtront ici", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
