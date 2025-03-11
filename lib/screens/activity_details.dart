import 'package:flutter/material.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> activity;

  ActivityDetailsScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    final jour = activity['jour'] ?? 'Jour inconnu';
    final horaire = activity['horaire'] ?? 'Horaire inconnu';
    final emplacement = activity['emplacement'] ?? 'Emplacement inconnu';
    final url = activity['imageUrlVisible'] ?? '';
    final title = activity['title'] ?? 'Titre inconnu';
    final description = activity['description'] ?? 'Aucune description disponible';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200), // Adjust height as needed
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Header.jpg"),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          jour,
                          style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          horaire,
                          style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                     Center( 
                        child:
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 227, 85), // Color #fcd307 with 0.5 opacity
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Kiosque: $emplacement",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 230, 230, 230), width: 2),
                    ),
                    child: Image.network(
                      url,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 22, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child:
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            ),
            SizedBox(height: 40),
            
          ],
        ),

      ),
    );
  }
}