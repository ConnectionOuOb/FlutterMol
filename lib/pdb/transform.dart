import 'format.dart';
import '../geometry/controller.dart';

List<String> backbones = ['N', 'CA', 'C'];

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

  return Point3D(false, false, centerX, centerY, centerZ);
}

StructureController transform2Controller(String textPDB) {
  PDB pdbData = PDB.fromText(textPDB);
  List<Line3D> lines = [];
  List<Point3D> points = [];

  for (var idx = 0; idx < pdbData.atoms.length; idx++) {
    bool isBackBone = backbones.contains(pdbData.atoms[idx].name);

    if (!isBackBone) {
      continue;
    }

    Point3D thisPoint = Point3D(
      isBackBone,
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

  Point3D center = computeCenterPoint(points);

  return StructureController(
    0,
    true,
    lines,
    points.map((e) {
      return Point3D(e.isBackBone, e.isNitrogen, e.x - center.x, e.y - center.y, e.z - center.z);
    }).toList(),
  );
}
