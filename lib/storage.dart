import 'object.dart';
import 'pdb/transform.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLocalStoragePDB(String name, String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString(name, data);
}

Future<void> clearLocalStoragePDB(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.remove(name);
}

Future<List<StructureController>> loadLocalStoragePDB(name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String data = prefs.getString(name) ?? '';

  if (data.isNotEmpty) {
    return text2Controllers(name, data);
  } else {
    return [];
  }
}
