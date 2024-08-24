import 'dart:async';
import 'package:flutter/material.dart';

class TextClock extends StatefulWidget {
  const TextClock({super.key});

  @override
  State<TextClock> createState() => _TextClockState();
}

class _TextClockState extends State<TextClock> {
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
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = '${_currentTime.hour.toString().padLeft(2, '0')} : '
        '${_currentTime.minute.toString().padLeft(2, '0')} : '
        '${_currentTime.second.toString().padLeft(2, '0')}';

    return Center(
      child: Text(
        formattedTime,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
