import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key});

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure to cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 10, color: Colors.grey),
        ),
        child: CustomPaint(
          painter: ClockPainter(time: _currentTime),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 10;

    // Draw clock circle
    paint.color = Colors.grey;
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      paint,
    );

    // Draw hour numbers
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );

    for (int i = 1; i <= 12; i++) {
      final angle = i * 30 * pi / 180;
      final x = centerX + (radius - 20) * cos(angle - pi / 2);
      final y = centerY + (radius - 20) * sin(angle - pi / 2);

      textPainter.text = TextSpan(
        text: '$i',
        style: textStyle,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Draw hour hand
    final hourHandPaint = Paint()
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    final hourHandLength = radius - 30;
    final hourHandAngle =
        (time.hour % 12) * 30 + time.minute * 0.5;
    final hourHandX =
        centerX + hourHandLength * cos(hourHandAngle * pi / 180 - pi / 2);
    final hourHandY =
        centerY + hourHandLength * sin(hourHandAngle * pi / 180 - pi / 2);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(hourHandX, hourHandY),
      hourHandPaint,
    );

    // Draw minute hand
    final minuteHandPaint = Paint()
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    final minuteHandLength = radius - 20;
    final minuteHandAngle =
        time.minute * 6 + time.second * 0.1;
    final minuteHandX =
        centerX + minuteHandLength * cos(minuteHandAngle * pi / 180 - pi / 2);
    final minuteHandY =
        centerY + minuteHandLength * sin(minuteHandAngle * pi / 180 - pi / 2);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(minuteHandX, minuteHandY),
      minuteHandPaint,
    );

    // Draw second hand
    final secondHandPaint = Paint()
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.red;

    final secondHandLength = radius - 10;
    final secondHandAngle = time.second * 6;
    final secondHandX =
        centerX + secondHandLength * cos(secondHandAngle * pi / 180 - pi / 2);
    final secondHandY =
        centerY + secondHandLength * sin(secondHandAngle * pi / 180 - pi / 2);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(secondHandX, secondHandY),
      secondHandPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
