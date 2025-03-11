import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // Importation de l'écran principal

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Événement',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white // Ensures global white background
      ),
      home: MainScreen(), // Charge l'écran principal avec la navigation
    );
  }
}
