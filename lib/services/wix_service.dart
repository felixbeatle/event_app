import 'dart:convert';
import 'package:http/http.dart' as http;

class WixService {
  final String baseUrl = "https://www.wixapis.com/wix-data/v2/items/query"; // URL de l'API Wix
  final String apiKey = "IST.eyJraWQiOiJQb3pIX2FDMiIsImFsZyI6IlJTMjU2In0.eyJkYXRhIjoie1wiaWRcIjpcIjA0NTIwMzI0LWUzMTctNGExZi1iMTExLTdiZjU3NGNkMDFmN1wiLFwiaWRlbnRpdHlcIjp7XCJ0eXBlXCI6XCJhcHBsaWNhdGlvblwiLFwiaWRcIjpcIjJjZmIzNDMzLWUzZmYtNGY0Mi1hYTE5LTgzYjgxZDg3Y2VjYVwifSxcInRlbmFudFwiOntcInR5cGVcIjpcImFjY291bnRcIixcImlkXCI6XCJjNmRmNGIyNS05YjNiLTQ2YjMtOWI5MC05ZWUxNDc2MmEzYjBcIn19IiwiaWF0IjoxNzQxMzg5OTc2fQ.bK1WDChEYJBo6rXX7vmCaOrS4rDq8jEYz-1ysJotjgAsgurvskqN7euZ4VnckEpyUmudH8_LHq4MkhmYzIPUatIzCY72FZOCoZZjIEyvgkhWF3SM8s9FmBukW0Lxa7ucF-069YVwp9AVysJhnXUdCJ995pSH8-YcHQ89C9hULGuTokmOUik66CZrmO7h7fmvsKEujNnM818YfINnsWVU4ZpSbh_qkNjgLN7j5gH3SdURi5WDzdUamjHmz_AUFvahNsmkSd4R0HRaeAwHu6g7uI_kjS64vMbi6CCOC_mwY13LKb2lB81JfUIZLRoZ28FmaRRFt3Rrvnz6m4TtbaMOfw"; // Mets ici ta vraie clé API Wix
  final String wixAccountId = "c6df4b25-9b3b-46b3-9b90-9ee14762a3b0"; // Mets ici ton Wix Account ID
  final String wixSiteId = "TON_SITE_ID"; // Mets ici ton Wix Site ID

  // Fonction pour tester la connexion API Wix
  Future<void> testWixConnection() async {
    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        "Authorization": apiKey,
        "wix-account-id": wixAccountId,
        "wix-site-id": wixSiteId,
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "dataCollectionId": "App exposants 2025", // Nom de ta collection Wix
        "filter": {}, // Pas de filtre pour récupérer tous les éléments
        "paging": { "limit": 10 } // Limite à 10 résultats
      }),
    );
  }
}
