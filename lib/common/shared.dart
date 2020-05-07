import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static const String favorites = 'favorites';
  static const String font_size = 'font_size';
  static const String theme_mode = 'theme_mode';

  // For plain-text data
  Future<void> set(String key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPreferences.setBool(key, value);
    } else if (value is String) {
      sharedPreferences.setString(key, value);
    } else if (value is double) {
      sharedPreferences.setDouble(key, value);
    } else if (value is int) {
      sharedPreferences.setInt(key, value);
    }
  }

  Future<dynamic> get(String key, {dynamic defaultValue}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.get(key) ?? defaultValue;
  }

  Future<void> setFavorites(String value) async {
    return await set(favorites, value);
  }

  Future<bool> getFavorites() async {
    return await get(favorites);
  }

  Future<void> setThemeMode(String value) async {
    return await set(theme_mode, value);
  }

  Future<String> getThemeMode() async {
    return await get(theme_mode);
  }
}
