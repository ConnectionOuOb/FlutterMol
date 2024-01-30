import 'format.dart';

transform2Controller(String query, String subject) {
  PDB queryPDB = PDB.fromText(query);
  PDB subjectPDB = PDB.fromText(subject);

  for (var atom in queryPDB.atoms) {
    print("${atom.x} ${atom.y} ${atom.z}");
  }
}
