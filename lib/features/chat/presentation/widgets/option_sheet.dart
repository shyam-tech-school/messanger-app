import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'chat_bottom_sheet_options.dart';

class OptionSheet extends StatelessWidget {
  const OptionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(left: 16, right: 16, top: 16, bottom: 10),
      child: SafeArea(
        bottom: true,
        child: Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            ChatBottomSheetOptions(
              icon: Ionicons.images,
              label: "Photos",
              ontap: () {},
            ),
            ChatBottomSheetOptions(
              icon: Ionicons.camera,
              label: "Camera",
              ontap: () {},
            ),

            ChatBottomSheetOptions(
              icon: Ionicons.person_circle,
              label: "Contact",
              ontap: () {},
            ),

            ChatBottomSheetOptions(
              icon: Ionicons.document,
              label: "Document",
              ontap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
