import '../config.dart';
import '../object.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../ss/determine.dart';

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

      for (var part in controller.parts) {
        if (part.points.isEmpty) {
          continue;
        }

        final paint = Paint()
          ..strokeWidth = 4.0
          ..color = part.sse == SSE.helix
              ? colorSS[controller.showType].helix
              : part.sse == SSE.sheet
                  ? colorSS[controller.showType].sheet
                  : colorSS[controller.showType].normal;

        if (part.points.length == 1) {
          canvas.drawPoints(
            PointMode.points,
            [rotatePoint(part.points[0].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset()],
            paint,
          );
        } else if (part.points.length == 2) {
          canvas.drawLine(
            rotatePoint(part.points[0].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset(),
            rotatePoint(part.points[1].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset(),
            paint,
          );
        } else {
          if (part.sse == SSE.coil || part.sse == SSE.turn || part.sse == SSE.unknown) {
            for (var i = 0; i < part.points.length - 1; i++) {
              canvas.drawLine(
                rotatePoint(part.points[i].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset(),
                rotatePoint(part.points[i + 1].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset(),
                paint,
              );
            }
          } else if (part.sse == SSE.helix) {
            final path = Path();
            final startPoint = rotatePoint(part.points[0].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset();
            path.moveTo(startPoint.dx, startPoint.dy);
            for (var i = 1; i < part.points.length; i++) {
              final routePoint = rotatePoint(part.points[i].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset();
              path.lineTo(routePoint.dx, routePoint.dy);
            }
            canvas.drawPath(path, paint);
          } else if (part.sse == SSE.sheet) {
            final path = Path();
            final startPoint = rotatePoint(part.points[0].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset();
            path.moveTo(startPoint.dx, startPoint.dy);
            for (var i = 1; i < part.points.length; i++) {
              final routePoint = rotatePoint(part.points[i].scale(scaleFactor), rotationX, rotationY).setCenter(center).toOffset();
              path.lineTo(routePoint.dx, routePoint.dy);
            }
            canvas.drawPath(path, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Point3D rotatePoint(Point3D point, double angleX, double angleY) {
    final sinX = math.sin(angleX);
    final cosX = math.cos(angleX);
    final sinY = math.sin(angleY);
    final cosY = math.cos(angleY);

    final rotatedX = point.x * cosY - point.z * sinY;
    final rotatedY = point.x * sinY * sinX + point.y * cosX + point.z * sinX * cosY;
    final rotatedZ = point.x * sinY * cosX - point.y * sinX + point.z * cosX * cosY;

    return Point3D(point.sse, point.chainID, rotatedX, rotatedY, rotatedZ);
  }
}
