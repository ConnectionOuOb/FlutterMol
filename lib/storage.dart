import 'pdb/transform.dart';
import 'geometry/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearLocalStoragePDB() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.remove("query");
  prefs.remove("subject");
}

Future<StructureController> loadLocalStoragePDB() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String query = prefs.getString("query") ?? '';
  String subject = prefs.getString("subject") ?? '';

  if (query.isNotEmpty && subject.isNotEmpty) {
    return transform2Controller(query);
    //transform2Controller(subject);
  }

  return StructureController(-1, false, [], [], []);
}

Future<void> saveLocalStoragePDB(String query, String subject) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString("query", query);
  prefs.setString("subject", subject);
}
