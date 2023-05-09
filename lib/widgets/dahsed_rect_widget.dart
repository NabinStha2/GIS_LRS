import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;

  const DashedRect(
      {super.key,
      this.color = Colors.black,
      this.strokeWidth = 1.0,
      this.gap = 5.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(strokeWidth / 2),
        child: CustomPaint(
          painter:
              DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
        ),
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter(
      {this.strokeWidth = 5.0, this.color = Colors.red, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path topPath = getDashedPath(
      a: const math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path leftPath = getDashedPath(
      a: const math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(topPath, dashedPaint);
    canvas.drawPath(rightPath, dashedPaint);
    canvas.drawPath(bottomPath, dashedPaint);
    canvas.drawPath(leftPath, dashedPaint);
  }

  Path getDashedPath({
    required math.Point<double> a,
    required math.Point<double> b,
    required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x.toDouble(), currentPoint.y.toDouble())
          : path.moveTo(currentPoint.x.toDouble(), currentPoint.y.toDouble());
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// import 'dart:ui';

// import 'package:flutter/material.dart';

// class DottedBorderPainter extends CustomPainter {
//   final double borderWidth;
//   final Color borderColor;
//   final double borderRadius;

//   DottedBorderPainter({
//     required this.borderWidth,
//     required this.borderColor,
//     required this.borderRadius,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = borderWidth
//       ..strokeCap = StrokeCap.round;

//     final path = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(
//             borderWidth / 2,
//             borderWidth / 2,
//             size.width - borderWidth,
//             size.height - borderWidth,
//           ),
//           Radius.circular(borderRadius),
//         ),
//       );

//     const dotSize = Offset(2, 2);
//     const dotSpacing = Offset(5, 0);

//     for (PathMetric metric in path.computeMetrics()) {
//       double start = 0;
//       while (start < metric.length) {
//         canvas.drawCircle(
//             metric.getTangentForOffset(start)!.position, dotSize.dx / 2, paint);
//         start += dotSize.dx + dotSpacing.dx;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
