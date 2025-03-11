import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExhibitorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> exhibitor;

  ExhibitorDetailsScreen({required this.exhibitor});

  @override
  Widget build(BuildContext context) {
    final entreprise = exhibitor['entreprise'] ?? 'Nom inconnu';
    final kiosque = exhibitor['kiosque'] ?? 'N/A';
    final logoUrl = exhibitor['urlImagePublique'] ?? '';
    final partenaire = exhibitor['partenariat'] ?? '';
    final description = exhibitor['description']?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ') ?? '';
    final partenaireText = partenaire.replaceAll('[', '').replaceAll(']', '');
    final siteInternetDeLEntreprise = exhibitor['siteInternetDeLEntreprise'] ?? '';
    final urlPub = exhibitor['urlPub'] ?? '';


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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align the image to the top
              children: [
                 Column(
                  children: [
                    Image.network(
                      logoUrl,
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                    if (siteInternetDeLEntreprise.isNotEmpty) ...[
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.parse(siteInternetDeLEntreprise);
                          print('Attempting to launch URL: $url');
                          if (await canLaunchUrl(url)) {
                            print('Launching URL: $url');
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            print('Could not launch URL: $url');
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text(
                          "VOIR LE SITE WEB",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(width: 10), // Add some space between the image and the text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                            partenaireText,
                            style: TextStyle(fontSize:18, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      Text(
                        entreprise,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                     Container(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 227, 85), // Color #fcd307 with 0.5 opacity
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Kiosque: $kiosque",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      if (partenaireText.isNotEmpty) ...[
                        SizedBox(height: 10),
                        Text(
                          description,
                          style: TextStyle(color: Colors.grey[700]),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (partenaireText.isNotEmpty) ...[
              SizedBox(height: 10), // Add some space between the rows
              Row(
                children: [
                  Expanded(
                    flex: 2, // Take 33% of the screen width
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4, // Take 66% of the screen width
                    child: GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(urlPub);
                        print('Attempting to launch URL: $url');
                        if (await canLaunchUrl(url)) {
                          print('Launching URL: $url');
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          print('Could not launch URL: $url');
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image.network(
                        "https://static.wixstatic.com/media/0025ee_3947a0b250754aeb923cc1aef01bf672~mv2.jpg/v1/fill/w_1080,h_1080,al_c,q_85,enc_auto/Mtrenka%20(1).jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}