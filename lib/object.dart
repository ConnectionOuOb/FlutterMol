import 'dart:ui';
import 'package:flutter/material.dart';
import '../ss/determine.dart';
import 'dart:math' as math;

class Setting {
  double scale;
  double ratio;

  Setting(this.scale, this.ratio);
}

class ColorSS {
  String name;
  Color normal;
  Color helix;
  Color sheet;

  ColorSS(this.name, this.normal, this.helix, this.sheet);
}

class Partition {
  SSE sse;
  List<Point3D> points;

  Partition(this.sse, this.points);
}

class StructureController {
  int showType;
  bool visible;
  String name;
  List<Partition> parts;

  StructureController(this.showType, this.visible, this.name, this.parts);
}


class Point3D {
  SSE sse;
  String chainID;
  double x;
  double y;
  double z;

  Point3D(this.sse, this.chainID, this.x, this.y, this.z);

  double distanceTo(other) {
    double dx = x - other.x;
    double dy = y - other.y;
    double dz = z - other.z;

    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }

  Offset toOffset() {
    return Offset(x, y);
  }

  Point3D scale(double factor) {
    return Point3D(sse, chainID, x * factor, y * factor, z * factor);
  }

  Point3D setCenter(Offset center) {
    return Point3D(sse, chainID, center.dx + x, center.dy + y, z);
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

    return Point3D(SSE.unknown, "", centerX, centerY, centerZ);
  }
}