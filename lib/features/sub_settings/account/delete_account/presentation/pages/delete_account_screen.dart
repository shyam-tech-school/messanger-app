import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';

import '../../../../../../core/constants/color_constants.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});

  final List points = [
    TextConstants.deletePoint1,
    TextConstants.deletePoint2,
    TextConstants.deletePoint3,
    TextConstants.deletePoint4,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete my account')),
      body: SizedBox(
        height: .maxFinite,
        width: .maxFinite,
        child: Padding(
          padding: const .all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                TextConstants.deleteHeadText,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium!.copyWith(fontSize: 20),
              ),

              ...List.generate(points.length, (index) {
                return Row(
                  children: [const SizedBox(width: 20), Text(points[index])],
                );
              }),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your phone number:",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const .all(8),
                decoration: BoxDecoration(
                  color: ColorConstants.greyShade300,
                  borderRadius: .circular(12),
                ),
                child: Row(
                  children: [
                    const Text(
                      "+91  ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: .only(top: 1),
                          border: InputBorder.none,
                          hintText: "your phone number",
                          hintStyle: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: ColorConstants.primary,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SubSettingsWidget(
                text: 'Delete my account',
                isRed: true,
                ontap: () {},
              ),
              const SizedBox(height: 12),
              SubSettingsWidget(
                text: 'Change phone number instead',
                ontap: () {},
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
