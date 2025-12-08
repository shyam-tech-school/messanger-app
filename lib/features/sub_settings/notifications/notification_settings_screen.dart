import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Padding(
        padding: const .all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Message notifications",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: ColorConstants.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Column(
                children: [
                  NotificationSubSettingsWidget(
                    pTop: 16,
                    text: "Show notifications",
                  ),
                  Divider(indent: 16),
                  NotificationSubSettingsWidget(text: "Sound"),
                  Divider(indent: 16),
                  NotificationSubSettingsWidget(text: "Vibration"),
                  Divider(indent: 16),
                  NotificationSubSettingsWidget(
                    pBottom: 16,
                    text: "Reaction notifications",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Text(
              "Message notifications",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: ColorConstants.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Column(
                children: [
                  NotificationSubSettingsWidget(
                    pTop: 16,
                    text: "Call notifications",
                  ),
                  Divider(indent: 16),
                  NotificationSubSettingsWidget(text: "Sound"),
                  Divider(indent: 16),
                  NotificationSubSettingsWidget(pBottom: 16, text: "Vibration"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const NotificationSubSettingsWidget(
                pTop: 8,
                pBottom: 8,
                text: "Show preview",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSubSettingsWidget extends StatelessWidget {
  const NotificationSubSettingsWidget({
    super.key,
    this.pTop = 0.0,
    this.pLeft = 16.0,
    this.pRight = 16.0,
    this.pBottom = 0.0,
    required this.text,
  });

  final double pTop;
  final double pLeft;
  final double pRight;
  final double pBottom;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(top: pTop, left: pLeft, right: pRight, bottom: pBottom),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(text),
          Switch.adaptive(value: true, onChanged: (value) {}),
        ],
      ),
    );
  }
}
