import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

class ChangePhoneNumberInfo extends StatelessWidget {
  const ChangePhoneNumberInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change phone number'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
            onPressed: () =>
                Navigator.pushNamed(context, RouteName.changePhoneNumberScreen),

            child: const Text(
              "Next",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
        actionsPadding: const .only(right: 8),
      ),
      body: SizedBox(
        height: .maxFinite,
        width: .maxFinite,
        child: Padding(
          padding: const .all(16.0),
          child: Column(
            children: [
              Image.asset(ImagePathConstants.sim, height: 140),
              const SizedBox(height: 20),
              const Text(
                TextConstants.changeNumberText1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                TextConstants.changeNumberText2,
                textAlign: TextAlign.center,
              ),
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
