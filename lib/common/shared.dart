import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static const String favorites = 'favorites';
  static const String font_size = 'font_size';
  static const String theme_mode = 'theme_mode';
  static const String reminder = 'reminder';
  static const String songs_index_updatedAt = 'updatedAt';

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
    return sharedPreferences.get(key) ?? defaultValue;
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

  Future<void> setRemind(DateTime remind) async {
    return await set(reminder, remind.millisecondsSinceEpoch);
  }

  Future<int> getRemind() async {
    return await get(reminder);
  }

  Future<void> setSongsIndexUpdatedAt(DateTime updatedAt) async {
    return await set(songs_index_updatedAt, updatedAt.millisecondsSinceEpoch);
  }

  Future<DateTime> getSongsIndexUpdatedAt() async {
    final milliseconds = await get(songs_index_updatedAt, defaultValue: null);
    return milliseconds == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }
}
