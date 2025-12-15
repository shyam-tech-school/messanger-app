import 'package:flutter/material.dart';

import '../widgets/call_appbar_widget.dart';
import '../widgets/call_screen_bottom_option_widget.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacity = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23243A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const .only(top: 12),
          child: CallAppbarWidget(widget: widget),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _buildTopSection(),
            const Spacer(),
            const CallScreenBottomOptionWidget(),
          ],
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
              // Animated Glow Circle
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scale.value,
                    child: Opacity(
                      opacity: _opacity.value,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // SECOND ripple for nicer effect
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scale.value * 1.2,
                    child: Opacity(
                      opacity: _opacity.value * 0.7,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.withOpacity(0.2),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Profile Image
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(widget.userData['profileDp']),
              ),
            ],
          ),
        ),
        //const SizedBox(height: 20),
      ],
    );
  }
}
