import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

import '../../../../../../core/common/widget/radio_group.dart';

class PrivacyLastSeenScreen extends StatelessWidget {
  const PrivacyLastSeenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Last seen & online')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Who can see my Last Seen",
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
                  RadioOption(label: "Everyone", value: 0),
                  RadioOption(label: "My contacts", value: 1),
                  RadioOption(label: "Nobody", value: 2),
                ],
                onChanged: (value) {
                  print("Selected: $value");
                },
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Who can see when I'm online",
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
                  RadioOption(label: "Everyone", value: 0),
                  RadioOption(label: "Same as last seen", value: 1),
                ],
                onChanged: (value) {
                  print("Selected: $value");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
