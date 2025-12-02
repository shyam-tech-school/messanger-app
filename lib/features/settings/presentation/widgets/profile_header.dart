import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Row(
        spacing: 12,
        children: [
          const CircleAvatar(radius: 35),
          Expanded(
            child: Column(
              spacing: 6,
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Username",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    letterSpacing: .8,
                  ),
                ),
                const Text(
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
