import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/images/Accueil.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: SpinKitCircle(
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}