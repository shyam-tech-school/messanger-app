import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';

import '../../../../../../core/constants/color_constants.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email')),
      body: SizedBox(
        height: .maxFinite,
        width: .maxFinite,
        child: Padding(
          padding: const .all(16.0),
          child: Column(
            children: [
              Image.asset(ImagePathConstants.email, height: 160),
              const SizedBox(height: 20),
              const Text(TextConstants.emailText, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "EMAIL",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstants.greyShade300,
                  border: OutlineInputBorder(
                    borderRadius: .circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "username@gmail.com",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
