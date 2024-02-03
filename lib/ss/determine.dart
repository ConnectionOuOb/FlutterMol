import '../object.dart';

const double deltaH = 2.10;
const double deltaE = 1.42;
const double deltaT = 8.00;

enum SSE {
  helix(code: "H", name: "Helix"),
  sheet(code: "E", name: "Sheet"),
  turn(code: "T", name: "Turn"),
  coil(code: "C", name: "Coil"),
  unknown(code: "X", name: "Unknown");

  final String code;
  final String name;

  const SSE({
    required this.code,
    required this.name,
  });
}

SSE determineSSE(double dis13, double dis14, double dis15, double dis24, double dis25, double dis35) {
  if ((dis13 - 5.45).abs() < deltaH &&
      (dis14 - 5.18).abs() < deltaH &&
      (dis15 - 6.37).abs() < deltaH &&
      (dis24 - 5.45).abs() < deltaH &&
      (dis25 - 5.18).abs() < deltaH &&
      (dis35 - 5.45).abs() < deltaH) {
    return SSE.helix;
  }

  if ((dis13 - 6.10).abs() < deltaE &&
      (dis14 - 10.4).abs() < deltaE &&
      (dis15 - 13.0).abs() < deltaE &&
      (dis24 - 6.10).abs() < deltaE &&
      (dis25 - 10.4).abs() < deltaE &&
      (dis35 - 6.10).abs() < deltaE) {
    return SSE.sheet;
  }

  if (dis15 < deltaT) {
    return SSE.turn;
  }

  return SSE.coil;
}

List<Point3D> point3Ds2SS(List<Point3D> points) {
  List<Point3D> ret = [];

  for (var a3 = 0; a3 < points.length; a3++) {
    int a1 = a3 - 2;
    int a2 = a3 - 1;
    int a4 = a3 + 1;
    int a5 = a3 + 2;

    Point3D old = points[a3];

    if (a1 < 0 || a5 >= points.length) {
      old.sse = SSE.coil;
    } else {
      old.sse = determineSSE(
        points[a1].distanceTo(points[a3]),
        points[a1].distanceTo(points[a4]),
        points[a1].distanceTo(points[a5]),
        points[a2].distanceTo(points[a4]),
        points[a2].distanceTo(points[a5]),
        points[a3].distanceTo(points[a5]),
      );
    }

    ret.add(old);
  }

  return ret;
}
