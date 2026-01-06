import 'package:shared_preferences/shared_preferences.dart';

class WhatsNewService {
  static const _versionKey = 'last_whats_new_version';

  /// Checks if the popup should show for this version.
  static Future<bool> shouldShow(String version) async {
    final prefs = await SharedPreferences.getInstance();

    final lastVersion = prefs.getString(_versionKey);

    // Show only if the version is different and user *is not* first launch
    return lastVersion != version;
  }

  /// Marks this version as shown.
  static Future<void> markShown(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_versionKey, version);
  }
}
