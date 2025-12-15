import 'package:flutter/material.dart';

import '../pages/audio_call_screen.dart';

class CallAppbarWidget extends StatelessWidget {
  const CallAppbarWidget({super.key, required this.widget});

  final AudioCallScreen widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF23243A),
      title: Column(
        children: [
          Text(
            widget.userData['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
              SizedBox(width: 6),
              Text(
                "00:03:40",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}
