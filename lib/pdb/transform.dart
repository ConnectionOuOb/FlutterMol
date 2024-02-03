import 'format.dart';
import '../object.dart';
import '../ss/determine.dart';

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

  return Point3D(SSE.unknown, "", centerX, centerY, centerZ);
}

StructureController transform2Controller(String name, List<String> textPDBs) {
  List<Point3D> cas = [];
  List<Partition> parts = [];

  PDB pdbData = PDB.fromStringList(textPDBs);

  for (var aa in pdbData.aas) {
    cas.add(Point3D(SSE.unknown, aa.chainIdentifier, aa.atoms[1].x, aa.atoms[1].y, aa.atoms[1].z));
  }

  cas = point3Ds2SS(cas);

  Point3D center = computeCenterPoint(cas);

  cas = cas.map((e) {
    return Point3D(e.sse, e.chainID, e.x - center.x, e.y - center.y, e.z - center.z);
  }).toList();

  String previousChain = "";
  for (var p in cas) {
    if (parts.isEmpty) {
      parts.add(Partition(p.sse, [p]));
    } else {
      if (parts.last.sse == p.sse && p.chainID == previousChain) {
        parts.last.points.add(p);
      } else {
        parts.add(Partition(p.sse, [p]));
      }
    }
    previousChain = p.chainID;
  }

  return StructureController(0, true, name, parts);
}

List<StructureController> text2Controllers(String name, String text) {
  bool goSecond = false;
  List<String> names = name.split("-");
  List<String> queryLines = [];
  List<String> subjectLines = [];

  for (var line in text.split("\n")) {
    if (line.startsWith("ATOM")) {
      if (goSecond) {
        subjectLines.add(line);
      } else {
        queryLines.add(line);
      }
    } else if (line.startsWith("TER")) {
      goSecond = true;
    }
  }

  return [
    transform2Controller("Query: ${names[0]}", queryLines),
    transform2Controller("Subject: ${names[1]}", subjectLines),
  ];
}
