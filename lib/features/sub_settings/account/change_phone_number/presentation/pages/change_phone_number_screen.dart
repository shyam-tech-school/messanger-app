import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/constants/color_constants.dart';

class ChangePhoneNumberScreen extends StatelessWidget {
  const ChangePhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change phone number'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
            onPressed: () {},
            child: const Text(
              "Next",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
        actionsPadding: const .only(right: 8),
      ),
      body: Padding(
        padding: const .all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirm old number:",
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
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "New number:",
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
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
