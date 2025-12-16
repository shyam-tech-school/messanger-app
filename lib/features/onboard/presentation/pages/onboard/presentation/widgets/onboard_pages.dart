import 'package:flutter/material.dart';
import 'package:mail_messanger/features/onboard/presentation/pages/onboard/model/onboard_model.dart';

class OnboardPages extends StatelessWidget {
  final OnboardModel onboardData;

  const OnboardPages({super.key, required this.onboardData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 0.6,
          child: Image.asset(onboardData.image, fit: .cover),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 400),
            offset: Offset.zero,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: 1,
              child: Container(
                height: 330,
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF0E1220),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    Text(
                      onboardData.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'LuckiestGuy',
                        fontSize: 35,
                        color: Color(0xFFD7FC70),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      onboardData.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
