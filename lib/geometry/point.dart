import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class Point3dView extends StatefulWidget {
  const Point3dView({super.key, required this.point3Ds, required this.width, required this.height, required this.scaleFactor});

  final List<Point3D> point3Ds;
  final double width;
  final double height;
  final double scaleFactor;

  @override
  State<Point3dView> createState() => _Point3dViewState();
}

class _Point3dViewState extends State<Point3dView> {
  double rotationX = 0.0;
  double rotationY = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          rotationX += details.delta.dy * 0.01;
          rotationY += details.delta.dx * 0.01;
        });
      },
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: ThreeDPointsPainter(
          regularization(widget.point3Ds),
          widget.scaleFactor,
          rotationX,
          rotationY,
          Offset(widget.width / 2, widget.height / 2),
        ),
      ),
    );
  }

  Point3D calculateCenterPoint(List<Point3D> points) {
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

    return Point3D(centerX, centerY, centerZ);
  }

  List<Point3D> regularization(List<Point3D> points) {
    Point3D center = calculateCenterPoint(widget.point3Ds);
    return points.map((e) {
      return Point3D(e.x - center.x, e.y - center.y, e.z - center.z);
    }).toList();
  }
}

class ThreeDPointsPainter extends CustomPainter {
  final List<Point3D> points;
  final double scaleFactor;
  final double rotationX;
  final double rotationY;
  final Offset center;
  final Offset origin = Offset.zero;

  ThreeDPointsPainter(this.points, this.scaleFactor, this.rotationX, this.rotationY, [this.center = Offset.zero]);

  @override
  void paint(Canvas canvas, Size size) {
    final transformedPoints = points.map((point) {
      final scaledPoint = Point3D(point.x * scaleFactor, point.y * scaleFactor, point.z * scaleFactor);
      final rotatedPoint = rotatePoint(scaledPoint, rotationX, rotationY);
      return rotatedPoint.translate(origin.dx, origin.dy, center);
    }).toList();

    for (int i = 0; i < transformedPoints.length - 1; i++) {
      canvas.drawLine(
        transformedPoints[i].toOffset(),
        transformedPoints[i + 1].toOffset(),
        Paint()
          ..color = Colors.lightBlueAccent
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.drawPoints(
      PointMode.points,
      transformedPoints.map((e) => e.toOffset()).toList(),
      Paint()
        ..color = Colors.redAccent
        ..strokeWidth = 5.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Point3D rotatePoint(Point3D point, double angleX, double angleY) {
    final sinX = sin(angleX);
    final cosX = cos(angleX);
    final sinY = sin(angleY);
    final cosY = cos(angleY);

    final rotatedX = point.x * cosY - point.z * sinY;
    final rotatedY = point.x * sinY * sinX + point.y * cosX + point.z * sinX * cosY;
    final rotatedZ = point.x * sinY * cosX - point.y * sinX + point.z * cosX * cosY;

    return Point3D(rotatedX, rotatedY, rotatedZ);
  }
}

class Point3D {
  final double x;
  final double y;
  final double z;

  Point3D(this.x, this.y, this.z);

  Offset toOffset() {
    return Offset(x, y);
  }

  Point3D translate(double dx, double dy, [Offset center = Offset.zero]) {
    return Point3D(center.dx + x + dx, center.dy + y + dy, z);
  }

  factory Point3D.fromJson(Map<String, dynamic> json) => Point3D(
        json["x"] ?? 0.0,
        json["y"] ?? 0.0,
        json["z"] ?? 0.0,
      );
}
