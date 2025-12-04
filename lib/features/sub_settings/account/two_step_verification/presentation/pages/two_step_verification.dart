import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';

class TwoStepVerification extends StatelessWidget {
  const TwoStepVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two-step verification')),
      body: SizedBox(
        height: .maxFinite,
        width: .maxFinite,
        child: Padding(
          padding: const .all(16.0),
          child: Column(
            children: [
              Image.asset(ImagePathConstants.twoSv, height: 160),
              const SizedBox(height: 20),
              const Text(TextConstants.twoSVText),
              const SizedBox(height: 20),
              SubSettingsWidget(text: 'Turn off', ontap: () {}, isRed: true),
              const SizedBox(height: 12),
              SubSettingsWidget(text: 'Change PIN', ontap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class SubSettingsWidget extends StatelessWidget {
  const SubSettingsWidget({
    super.key,
    required this.text,
    this.ontap,
    this.isRed = false,
  });

  final String text;
  final Function()? ontap;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: .maxFinite,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        ),
        onPressed: ontap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isRed ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
