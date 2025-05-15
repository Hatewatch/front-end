import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeJson(var data, String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      name,
      jsonEncode(
          data)); // Mettre un nom de string, ensuite on va le récup avec le meme nom
}

Future<dynamic> loadJson(String name) async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(name); // Prend le nom de la string
  if (jsonString != null && jsonString.isNotEmpty) {
    return jsonDecode(jsonString);
  } else {
    return null;
  }
}

Future<bool> isJsonDecodable(String str) async {
  try {
    await jsonDecode(str);
    return true;
  } catch (e) {
    return false;
  }
}