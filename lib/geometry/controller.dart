import 'dart:ui';
import 'dart:math' as math;

class Point3D {
  bool isBackBone;
  bool isNitrogen;
  int residueSequenceNumber;
  String chainID;
  double x;
  double y;
  double z;

  Point3D(this.isBackBone, this.isNitrogen, this.residueSequenceNumber, this.chainID, this.x, this.y, this.z);

  Offset toOffset() {
    return Offset(x, y);
  }

  Point3D scale(double factor) {
    return Point3D(isBackBone, isNitrogen, residueSequenceNumber, chainID, x * factor, y * factor, z * factor);
  }

  Point3D setCenter(Offset center) {
    return Point3D(isBackBone, isNitrogen, residueSequenceNumber, chainID, center.dx + x, center.dy + y, z);
  }

  distanceTo(other) {
    double dx = x - other.x;
    double dy = y - other.y;
    double dz = z - other.z;

    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }
}

class Partition {
  int ssType;
  List<Point3D> points;

  Partition(this.ssType, this.points);
}

class StructureController {
  int showType;
  bool visible;
  String name;
  List<Partition> parts;

  StructureController(this.showType, this.visible, this.name, this.parts);
}
