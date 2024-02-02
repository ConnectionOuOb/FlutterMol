import 'controller.dart';
import 'dart:math';
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

      /*List<Point3D> transformedPoints = controller.points.map((point) {
        return rotatePoint(point.scale(scaleFactor), rotationX, rotationY).setCenter(center);
      }).toList();

      canvas.drawPoints(
        PointMode.points,
        transformedPoints.map((e) => e.toOffset()).toList(),
        Paint()
          ..color = Colors.redAccent
          ..strokeWidth = 2.0,
      );*/

      for (var line in controller.lines) {
        Point3D from = rotatePoint(line.from.scale(scaleFactor), rotationX, rotationY).setCenter(center);
        Point3D to = rotatePoint(line.to.scale(scaleFactor), rotationX, rotationY).setCenter(center);

        canvas.drawLine(
            from.toOffset(),
            to.toOffset(),
            Paint()
              ..strokeWidth = 4.0
              ..color = line.isHelix
                  ? Colors.blue
                  : line.isSheet
                      ? Colors.red
                      : Colors.black);
      }
    }
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

    return Point3D(
      point.isBackBone,
      point.isNitrogen,
      point.residueSequenceNumber,
      point.chainID,
      rotatedX,
      rotatedY,
      rotatedZ,
    );
  }
}
