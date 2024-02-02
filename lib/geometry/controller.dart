import 'dart:ui';

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
}

class Line3D {
  bool isHelix;
  bool isSheet;
  Point3D from;
  Point3D to;

  Line3D(this.isHelix, this.isSheet, this.from, this.to);
}

class StructureController {
  int showType;
  bool canView;
  List<Line3D> lines;
  List<Point3D> points;

  StructureController(this.showType, this.canView, this.lines, this.points);
}
