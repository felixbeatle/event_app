import 'dart:convert';
import 'package:http/http.dart' as http;

class ConferenceService {
  static const String postUrl = "https://www.salondelapprentissage.ca/_functions/conferences"; 

  Future<List<dynamic>> fetchConferences() async {
    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "authorization": "IST.eyJraWQiOiJQb3pIX2FDMiIsImFsZyI6IlJTMjU2In0.eyJkYXRhIjoie1wiaWRcIjpcIjA0NTIwMzI0LWUzMTctNGExZi1iMTExLTdiZjU3NGNkMDFmN1wiLFwiaWRlbnRpdHlcIjp7XCJ0eXBlXCI6XCJhcHBsaWNhdGlvblwiLFwiaWRcIjpcIjJjZmIzNDMzLWUzZmYtNGY0Mi1hYTE5LTgzYjgxZDg3Y2VjYVwifSxcInRlbmFudFwiOntcInR5cGVcIjpcImFjY291bnRcIixcImlkXCI6XCJjNmRmNGIyNS05YjNiLTQ2YjMtOWI5MC05ZWUxNDc2MmEzYjBcIn19IiwiaWF0IjoxNzQxMzg5OTc2fQ.bK1WDChEYJBo6rXX7vmCaOrS4rDq8jEYz-1ysJotjgAsgurvskqN7euZ4VnckEpyUmudH8_LHq4MkhmYzIPUatIzCY72FZOCoZZjIEyvgkhWF3SM8s9FmBukW0Lxa7ucF-069YVwp9AVysJhnXUdCJ995pSH8-YcHQ89C9hULGuTokmOUik66CZrmO7h7fmvsKEujNnM818YfINnsWVU4ZpSbh_qkNjgLN7j5gH3SdURi5WDzdUamjHmz_AUFvahNsmkSd4R0HRaeAwHu6g7uI_kjS64vMbi6CCOC_mwY13LKb2lB81JfUIZLRoZ28FmaRRFt3Rrvnz6m4TtbaMOfw",
          "clientId": "5a26770a-b02d-4faf-b072-7da1108e6d9"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['conferences'] ?? []; // Retourne la liste des conférences
      } else {
        throw Exception("Erreur API Wix: ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur lors du chargement des conférences: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchConferenceByTitle(String title) async {
    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "authorization": "IST.eyJraWQiOiJQb3pIX2FDMiIsImFsZyI6IlJTMjU2In0.eyJkYXRhIjoie1wiaWRcIjpcIjA0NTIwMzI0LWUzMTctNGExZi1iMTExLTdiZjU3NGNkMDFmN1wiLFwiaWRlbnRpdHlcIjp7XCJ0eXBlXCI6XCJhcHBsaWNhdGlvblwiLFwiaWRcIjpcIjJjZmIzNDMzLWUzZmYtNGY0Mi1hYTE5LTgzYjgxZDg3Y2VjYVwifSxcInRlbmFudFwiOntcInR5cGVcIjpcImFjY291bnRcIixcImlkXCI6XCJjNmRmNGIyNS05YjNiLTQ2YjMtOWI5MC05ZWUxNDc2MmEzYjBcIn19IiwiaWF0IjoxNzQxMzg5OTc2fQ.bK1WDChEYJBo6rXX7vmCaOrS4rDq8jEYz-1ysJotjgAsgurvskqN7euZ4VnckEpyUmudH8_LHq4MkhmYzIPUatIzCY72FZOCoZZjIEyvgkhWF3SM8s9FmBukW0Lxa7ucF-069YVwp9AVysJhnXUdCJ995pSH8-YcHQ89C9hULGuTokmOUik66CZrmO7h7fmvsKEujNnM818YfINnsWVU4ZpSbh_qkNjgLN7j5gH3SdURi5WDzdUamjHmz_AUFvahNsmkSd4R0HRaeAwHu6g7uI_kjS64vMbi6CCOC_mwY13LKb2lB81JfUIZLRoZ28FmaRRFt3Rrvnz6m4TtbaMOfw",
          "clientId": "5a26770a-b02d-4faf-b072-7da1108e6d9"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> conferences = data['conferences'] ?? [];
        return conferences.firstWhere((conference) => conference['title'] == title, orElse: () => null);
      } else {
        throw Exception("Erreur API Wix: ${response.body}");
      }
    } catch (e) {
      throw Exception("Erreur lors du chargement des conférences: $e");
    }
  }
}