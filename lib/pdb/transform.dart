import 'format.dart';
import '../geometry/controller.dart';

List<String> backbones = ['N', 'CA', 'C', 'O'];

bool inRealm(Atom from, Atom to, List<Realm> realms) {
  bool result = false;

  for (var realm in realms) {
    if (from.chainIdentifier != realm.startChain || to.chainIdentifier != realm.endChain) {
      continue;
    }

    if (from.residueSequenceNumber >= realm.start &&
        from.residueSequenceNumber <= realm.end &&
        to.residueSequenceNumber >= realm.start &&
        to.residueSequenceNumber <= realm.end) {
      result = true;
      break;
    }
  }

  return result;
}

StructureController transform2Controller(String textPDB) {
  PDB pdbData = PDB.fromText(textPDB);
  List<Line3D> lines = [];
  List<Point3D> points = [];

  for (var idx = 0; idx < pdbData.atoms.length; idx++) {
    Point3D thisPoint = Point3D(
      backbones.contains(pdbData.atoms[idx].name),
      pdbData.atoms[idx].name == 'N',
      pdbData.atoms[idx].x,
      pdbData.atoms[idx].y,
      pdbData.atoms[idx].z,
    );
    if (idx + 1 == pdbData.atoms.length) {
      points.add(thisPoint);
    } else {
      int nextIdx = idx + 1;
      Point3D nextPoint = Point3D(
        backbones.contains(pdbData.atoms[nextIdx].name),
        pdbData.atoms[nextIdx].name == 'N',
        pdbData.atoms[nextIdx].x,
        pdbData.atoms[nextIdx].y,
        pdbData.atoms[nextIdx].z,
      );

      if (inRealm(pdbData.atoms[idx], pdbData.atoms[idx + 1], pdbData.helices)) {
        lines.add(Line3D(true, false, thisPoint, nextPoint));
      } else if (inRealm(pdbData.atoms[idx], pdbData.atoms[idx + 1], pdbData.helices)) {
        lines.add(Line3D(false, true, thisPoint, nextPoint));
      }

      points.add(thisPoint);
    }
  }

  return StructureController(0, true, lines, points);
}
