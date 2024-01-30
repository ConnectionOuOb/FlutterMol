import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadLocalStorageData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String query = prefs.getString("query") ?? '';
  String subject = prefs.getString("subject") ?? '';
}

Future<void> saveLocalStorageData(String query, String subject) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString("query", query);
  prefs.setString("subject", subject);
}
