import '../object.dart';
import '../ss/determine.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Point3dView extends StatefulWidget {
  const Point3dView({super.key, required this.controllers, required this.width, required this.height, required this.scaleFactor});

  final List<StructureController> controllers;
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
          widget.controllers,
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
  final List<StructureController> controllers;
  final double scaleFactor;
  final double rotationX;
  final double rotationY;
  final Offset center;

  ThreeDPointsPainter(this.controllers, this.scaleFactor, this.rotationX, this.rotationY, [this.center = Offset.zero]);

  @override
  void paint(Canvas canvas, Size size) {
    for (var controller in controllers) {
      if (!controller.visible) {
        continue;
      }

      Point3D prePoint = controller.parts[0].points[0];
      List<Point3D> notShow = [];

      for (var part in controller.parts) {
        if (part.points.isEmpty) {
          continue;
        }

        if (notShow.isNotEmpty) {
          part.points.insertAll(0, notShow);
          notShow = [];
        }

        if (part.points.length == 1) {
          notShow.addAll(part.points);
          continue;
        } else if (part.points.length == 2) {
          drawLine(part.points, canvas);
        } else {
          if (part.sse == SSE.coil || part.sse == SSE.turn || part.sse == SSE.unknown) {
            drawLine(part.points, canvas);
          } else if (part.sse == SSE.helix) {
            drawHelix(part.points, canvas);
          } else if (part.sse == SSE.sheet) {
            drawSheet(part.points, canvas);
          }
        }

        drawLine([prePoint, part.points[0]], canvas);
        prePoint = part.points.last;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Point3D rotatePoint(Point3D point) {
    point = point.scale(scaleFactor);

    final sinX = math.sin(rotationX);
    final cosX = math.cos(rotationX);
    final sinY = math.sin(rotationY);
    final cosY = math.cos(rotationY);

    return Point3D(
      point.sse,
      point.chainID,
      point.x * cosY - point.z * sinY,
      point.x * sinY * sinX + point.y * cosX + point.z * sinX * cosY,
      point.x * sinY * cosX - point.y * sinX + point.z * cosX * cosY,
    ).setCenter(center);
  }

  drawLine(List<Point3D> points, Canvas canvas) {
    final paint = Paint()
      ..strokeWidth = 4
      ..color = points[0].sse == SSE.helix
          ? Colors.red
          : points[0].sse == SSE.sheet
              ? Colors.blue
              : Colors.black;

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        rotatePoint(points[i]).toOffset(),
        rotatePoint(points[i + 1]).toOffset(),
        paint,
      );
    }
  }

  drawHelix(List<Point3D> points, Canvas canvas) {
    final paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.red;

    for (var i = 0; i < points.length - 1; i++) {
      final a = rotatePoint(points[i]);
      final b = rotatePoint(points[i + 1]);
      canvas.drawLine(a.toOffset(), b.toOffset(), paint);
    }
    /*
    Offset pF1 = Offset.zero;
    Offset pF2 = Offset.zero;

    for (var i2 = 1; i2 < points.length - 1; i2++) {
      int i1 = i2 - 1;
      int i3 = i2 + 1;

      final a = rotatePoint(points[i1]);
      final b = rotatePoint(points[i2]);
      final c = rotatePoint(points[i3]);

      final a12 = Point3D(SSE.unknown, "", b.x - a.x, b.y - a.y, b.z - a.z);
      final a13 = Point3D(SSE.unknown, "", c.x - a.x, c.y - a.y, c.z - a.z);

      final perpendicularAB = Point3D(SSE.unknown, "", -a12.y, a12.x, a12.z).normalize();
      final perpendicularAC = Point3D(SSE.unknown, "", -a13.y, a13.x, a13.z).normalize();

      final nF1 = Point3D(a.sse, a.chainID, a.x + perpendicularAB.x, a.y + perpendicularAB.y, a.z + perpendicularAB.z).toOffset();
      final nF2 = Point3D(a.sse, a.chainID, a.x - perpendicularAC.x, a.y - perpendicularAC.y, a.z + perpendicularAC.z).toOffset();

      if (i2 != 1) {
        Path path = Path()
          ..moveTo(pF1.dx, pF1.dy)
          ..cubicTo(pF2.dx, pF2.dy, nF1.dx, nF1.dy, nF2.dx, nF2.dy)
          ..close();
        canvas.drawPath(path, paint);
      }

      pF1 = nF1;
      pF2 = nF2;
    }
    */
  }

  drawSheet(List<Point3D> points, Canvas canvas) {
    final paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.blue;

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        rotatePoint(points[i]).toOffset(),
        rotatePoint(points[i + 1]).toOffset(),
        paint,
      );
    }
  }
}
