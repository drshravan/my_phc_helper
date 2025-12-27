import 'dart:math';
import 'package:flutter/material.dart';

class DashboardPieChart extends StatelessWidget {
  final int pending;
  final int delivered;
  final int aborted;
  final double size;

  const DashboardPieChart({
    super.key,
    required this.pending,
    required this.delivered,
    required this.aborted,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    int total = pending + delivered + aborted;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The Chart
          CustomPaint(
            size: Size(size, size),
            painter: _PieChartPainter(
              pending: pending,
              delivered: delivered,
              aborted: aborted,
              total: total,
            ),
          ),
          // Center Text (Donut Style)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$total",
                style: TextStyle(
                  fontSize: size * 0.2, // Auto scale font
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                "Total",
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final int pending;
  final int delivered;
  final int aborted;
  final int total;

  _PieChartPainter({
    required this.pending, 
    required this.delivered, 
    required this.aborted, 
    required this.total
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.25; // Donut thickness
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    if (total == 0) {
      // Draw empty gray ring
      paint.color = Colors.grey.withValues(alpha: 0.2);
      canvas.drawArc(rect, 0, 2 * pi, false, paint);
      return;
    }

    double startAngle = -pi / 2; // Start at top

    // 1. Pending (Orange)
    if (pending > 0) {
      final sweep = (pending / total) * 2 * pi;
      paint.color = Colors.orange;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }

    // 2. Delivered (Green)
    if (delivered > 0) {
      final sweep = (delivered / total) * 2 * pi;
      paint.color = Colors.green;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }

    // 3. Aborted (Red)
    if (aborted > 0) {
      final sweep = (aborted / total) * 2 * pi;
      paint.color = Colors.red;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
