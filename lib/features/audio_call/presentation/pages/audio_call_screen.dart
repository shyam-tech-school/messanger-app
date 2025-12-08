import 'package:flutter/material.dart';

class AudioCallScreen extends StatelessWidget {
  const AudioCallScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF23243A),
          borderRadius: BorderRadius.circular(40),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeArea(child: _buildTopSection()),
              _buildActionButtons(),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: _buildHangupButton(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        SizedBox(
          height: 230,
          width: 230,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ripple
              _rippleCircle(500, Colors.grey, 1),
              _rippleCircle(200, Colors.orange, 2),
              // _rippleCircle(180),
              //  _rippleCircle(1),

              // Profile Image
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(userData['profileDp']),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Text(
          userData['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

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
    );
  }

  Widget _rippleCircle(double size, Color color, double width) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.6), width: width),
      ),
    );
  }

  Widget _buildActionButtons() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CallActionButton(icon: Icons.mic_off, label: "Mute"),
            CallActionButton(icon: Icons.chat_bubble_outline, label: "Chat"),
            CallActionButton(icon: Icons.volume_up, label: "Speaker"),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CallActionButton(icon: Icons.mic, label: "Record"),
            CallActionButton(icon: Icons.person_add, label: "Add"),
            CallActionButton(icon: Icons.apps, label: "More"),
          ],
        ),
      ],
    );
  }

  Widget _buildHangupButton() {
    return Container(
      height: 65,
      width: 65,
      decoration: const BoxDecoration(
        color: Color(0xFFE76F51),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.call_end, color: Colors.white, size: 32),
    );
  }
}

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const CallActionButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Colors.white12,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
