import 'controller.dart';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class Point3dView extends StatefulWidget {
  const Point3dView({super.key, required this.controller, required this.width, required this.height, required this.scaleFactor});

  final StructureController controller;
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
          widget.controller.points,
          widget.scaleFactor,
          rotationX,
          rotationY,
          Offset(widget.width / 2, widget.height / 2),
        ),
      ),
    );
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
      final scaledPoint = Point3D(
        point.isBackBone,
        point.isNitrogen,
        point.x * scaleFactor,
        point.y * scaleFactor,
        point.z * scaleFactor,
      );
      final rotatedPoint = rotatePoint(scaledPoint, rotationX, rotationY);
      return rotatedPoint.translate(origin.dx, origin.dy, center);
    }).toList();

    /*for (int i = 0; i < transformedPoints.length - 1; i++) {
      canvas.drawLine(
        transformedPoints[i].toOffset(),
        transformedPoints[i + 1].toOffset(),
        Paint()
          ..color = Colors.lightBlueAccent
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round,
      );
    }*/
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

    return Point3D(point.isBackBone, point.isNitrogen, rotatedX, rotatedY, rotatedZ);
  }
}
