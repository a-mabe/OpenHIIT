import 'package:shared_preferences/shared_preferences.dart';

class WhatsNewService {
  static const _versionKey = 'last_whats_new_version';
  static const _firstLaunchKey = 'has_launched_before';

  /// Returns true if this is the user's first app launch.
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunched = prefs.getBool(_firstLaunchKey) ?? false;

    if (!hasLaunched) {
      await prefs.setBool(_firstLaunchKey, true);
      return true; // first launch
    }

    return false; // user has launched before
  }

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
