import 'package:flutter/material.dart';

import '../../../core/common/widget/radio_group.dart';
import '../../../core/constants/color_constants.dart';
import '../account/two_step_verification/presentation/pages/two_step_verification.dart';

class ChatSettingsScreen extends StatelessWidget {
  const ChatSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Select font size",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: ColorConstants.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const .all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: RadioGroup1(
                initialValue: 0,
                options: [
                  RadioOption(label: "Small", value: 0),
                  RadioOption(label: "Medium", value: 1),
                  RadioOption(label: "Large", value: 2),
                ],
                onChanged: (value) {
                  print("Selected: $value");
                },
              ),
            ),
            const SizedBox(height: 30),

            SubSettingsWidget(
              text: 'Clear all chats',
              ontap: () {},
              isRed: true,
            ),
            const SizedBox(height: 12),
            SubSettingsWidget(
              text: 'Delete all chats',
              ontap: () {},
              isRed: true,
            ),
          ],
        ),
      ),
    );
  }
}
