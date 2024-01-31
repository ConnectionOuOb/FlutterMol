import 'dart:ui';

class Point3D {
  bool isBackBone;
  bool isNitrogen;
  double x;
  double y;
  double z;

  Point3D(this.isBackBone, this.isNitrogen, this.x, this.y, this.z);

  Offset toOffset() {
    return Offset(x, y);
  }

  Point3D translate(double dx, double dy, [Offset center = Offset.zero]) {
    return Point3D(isBackBone, isNitrogen, center.dx + x + dx, center.dy + y + dy, z);
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
