import 'dart:ui';

class Realm {
  int start;
  int end;
  String startChain;
  String endChain;

  Realm(this.start, this.end, this.startChain, this.endChain);
}

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

class StructureController {
  int showType;
  bool canView;
  List<Point3D> points;
  List<Realm> helix;
  List<Realm> sheet;

  StructureController(this.showType, this.canView, this.points, this.helix, this.sheet);
}
