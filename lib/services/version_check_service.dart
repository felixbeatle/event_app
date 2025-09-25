import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheckService {
  static const String postUrl = "https://www.salondelapprentissage.ca/_functions/appversion";

  /// Check if app needs update by comparing current version with server version
  Future<UpdateInfo> checkForUpdate() async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      String currentBuildNumber = packageInfo.buildNumber;

      // Get required version from Wix
      final requiredVersionInfo = await _fetchRequiredVersion();
      
      if (requiredVersionInfo == null) {
        return UpdateInfo(
          needsUpdate: false,
          currentVersion: currentVersion,
          requiredVersion: null,
        );
      }

      String requiredVersion = requiredVersionInfo['version'] ?? '';
      String requiredBuildNumber = requiredVersionInfo['buildNumber']?.toString() ?? '';

      // Compare versions
      bool needsUpdate = _compareVersions(currentVersion, currentBuildNumber, requiredVersion, requiredBuildNumber);

      return UpdateInfo(
        needsUpdate: needsUpdate,
        currentVersion: currentVersion,
        requiredVersion: requiredVersion,
        updateUrl: _getStoreUrl(),
        forceUpdate: true, // Always force update
        updateMessage: requiredVersionInfo['message'] ?? 'Une nouvelle version est disponible.',
      );

    } catch (e) {
      print('Error checking for update: $e');
      return UpdateInfo(
        needsUpdate: false,
        currentVersion: 'Unknown',
        requiredVersion: null,
        error: e.toString(),
      );
    }
  }

  /// Fetch required version from Wix database
  Future<Map<String, dynamic>?> _fetchRequiredVersion() async {
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
        final items = data['items'];
        if (items != null && items.isNotEmpty) {
          // Trouver la version pour la plateforme actuelle
          String platform = Platform.isIOS ? "ios" : "android";
          for (var item in items) {
            if (item['platform'] == platform) {
              return item; // Return the version data for this platform
            }
          }
        }
      }
      return null;
    } catch (e) {
      print('Error fetching required version: $e');
      return null;
    }
  }

  /// Compare current version with required version
  bool _compareVersions(String currentVersion, String currentBuild, String requiredVersion, String requiredBuild) {
    try {
      // Parse version numbers (e.g., "3.0.4" -> [3, 0, 4])
      List<int> currentVersionParts = currentVersion.split('.').map(int.parse).toList();
      List<int> requiredVersionParts = requiredVersion.split('.').map(int.parse).toList();

      // Compare version parts
      for (int i = 0; i < currentVersionParts.length && i < requiredVersionParts.length; i++) {
        if (currentVersionParts[i] < requiredVersionParts[i]) {
          return true; // Need update
        } else if (currentVersionParts[i] > requiredVersionParts[i]) {
          return false; // Current version is newer
        }
      }

      // If versions are equal, compare build numbers
      int currentBuildInt = int.tryParse(currentBuild) ?? 0;
      int requiredBuildInt = int.tryParse(requiredBuild) ?? 0;
      
      return currentBuildInt < requiredBuildInt;

    } catch (e) {
      print('Error comparing versions: $e');
      return false;
    }
  }

  /// Get the appropriate store URL based on platform
  String _getStoreUrl() {
    if (Platform.isIOS) {
      return "https://apps.apple.com/ca/app/salon-de-lapprentissage/id6743262404?l=fr-CA";
    } else {
      return "https://play.google.com/store/apps/details?id=com.felixservice.salonapprentissage";
    }
  }
}

/// Model class to hold update information
class UpdateInfo {
  final bool needsUpdate;
  final String currentVersion;
  final String? requiredVersion;
  final String? updateUrl;
  final bool forceUpdate;
  final String updateMessage;
  final String? error;

  UpdateInfo({
    required this.needsUpdate,
    required this.currentVersion,
    this.requiredVersion,
    this.updateUrl,
    this.forceUpdate = true, // Always force update by default
    this.updateMessage = 'Une nouvelle version est disponible.',
    this.error,
  });

  @override
  String toString() {
    return 'UpdateInfo(needsUpdate: $needsUpdate, current: $currentVersion, required: $requiredVersion, force: $forceUpdate)';
  }
}