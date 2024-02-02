import 'format.dart';
import '../geometry/controller.dart';

List<String> backbones = ['N', 'CA', 'C'];

bool inRealm(Point3D p, List<Realm> realms) {
  bool result = false;

  for (var realm in realms) {
    if (p.chainID != realm.chainID) {
      continue;
    }

    if (p.residueSequenceNumber >= realm.start && p.residueSequenceNumber <= realm.end) {
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
  List<Point3D> points = [];
  List<Partition> parts = [];

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

  String previousChain = "";
  for (var p in points) {
    int ssType = inRealm(p, pdbData.helices)
        ? 1
        : inRealm(p, pdbData.sheets)
            ? 2
            : 0;

    if (parts.isEmpty) {
      parts.add(Partition(ssType, [p]));
    } else {
      if (parts.last.ssType == ssType && p.chainID == previousChain) {
        parts.last.points.add(p);
      } else {
        parts.add(Partition(ssType, [p]));
      }
    }
    previousChain = p.chainID;
  }

  return StructureController(0, true, name, parts);
}
