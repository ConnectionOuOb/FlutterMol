import 'format.dart';
import '../geometry/controller.dart';

List<String> backbones = ['N', 'CA', 'C'];

bool inRealm(Point3D from, Point3D to, List<Realm> realms) {
  bool result = false;

  for (var realm in realms) {
    if (from.chainID != realm.startChain || to.chainID != realm.endChain) {
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

Point3D computeCenterPoint(List<Point3D> points) {
  double totalX = 0.0;
  double totalY = 0.0;
  double totalZ = 0.0;

  for (var point in points) {
    totalX += point.x;
    totalY += point.y;
    totalZ += point.z;
  }

  double centerX = totalX / points.length;
  double centerY = totalY / points.length;
  double centerZ = totalZ / points.length;

  return Point3D(false, false, 0, "", centerX, centerY, centerZ);
}

StructureController transform2Controller(String name, String textPDB) {
  List<Line3D> lines = [];
  List<Point3D> points = [];

  PDB pdbData = PDB.fromText(textPDB);

  for (var atom in pdbData.atoms) {
    bool isBackBone = backbones.contains(atom.name);

    if (!isBackBone) {
      continue;
    }

    points.add(Point3D(isBackBone, atom.name == 'N', atom.residueSequenceNumber, atom.chainIdentifier, atom.x, atom.y, atom.z));
  }

  Point3D center = computeCenterPoint(points);

  points = points.map((e) {
    return Point3D(e.isBackBone, e.isNitrogen, e.residueSequenceNumber, e.chainID, e.x - center.x, e.y - center.y, e.z - center.z);
  }).toList();

  for (var idx = 0; idx < points.length - 1; idx++) {
    int nextIdx = idx + 1;

    if (points[idx].chainID != points[nextIdx].chainID) {
      continue;
    }

    if (inRealm(points[idx], points[nextIdx], pdbData.helices)) {
      lines.add(Line3D(true, false, points[idx], points[nextIdx]));
    } else if (inRealm(points[idx], points[nextIdx], pdbData.sheets)) {
      lines.add(Line3D(false, true, points[idx], points[nextIdx]));
    } else {
      lines.add(Line3D(false, false, points[idx], points[nextIdx]));
    }
  }

  return StructureController(0, true, name, lines, points);
}
