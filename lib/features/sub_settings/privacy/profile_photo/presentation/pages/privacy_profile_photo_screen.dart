import 'package:flutter/material.dart';

import '../../../../../../core/common/widget/radio_group.dart';
import '../../../../../../core/constants/color_constants.dart';

class PrivacyProfilePhotoScreen extends StatelessWidget {
  const PrivacyProfilePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile photo")),
      body: Padding(
        padding: const .all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Who can see my profile photo",
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
          ],
        ),
      ),
    );
  }
}
