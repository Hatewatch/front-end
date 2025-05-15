// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void saveData(String key, String value) {
  html.window.localStorage[key] = value;
}

String? getData(String key) {
  return html.window.localStorage[key];
}

void removeData(String key) {
  html.window.localStorage.remove(key);
}