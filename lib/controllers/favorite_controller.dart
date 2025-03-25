import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FavoriteController {
  List<String> favoriteItems = []; // Use a single list for both exhibitors and activities

  Future<void> loadFavorites() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/favorites.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      favoriteItems = List<String>.from(json.decode(contents));
    }
  }

  Future<void> saveFavorites() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/favorites.json');
    await file.writeAsString(json.encode(favoriteItems));
  }

  void toggleFavorite(String item) {
    if (favoriteItems.contains(item)) {
      favoriteItems.remove(item);
    } else {
      favoriteItems.add(item);
    }
    saveFavorites();
  }

  bool isFavorite(String item) {
    return favoriteItems.contains(item);
  }
}