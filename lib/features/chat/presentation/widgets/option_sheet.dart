import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'chat_bottom_sheet_options.dart';

class OptionSheet extends StatelessWidget {
  const OptionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(left: 16, right: 16, top: 16),
      child: SafeArea(
        child: Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            ChatBottomSheetOptions(
              icon: Ionicons.images,
              label: "Photos",
              ontap: () {},
              iconColor: Colors.blue.shade700,
            ),
            ChatBottomSheetOptions(
              icon: Ionicons.camera,
              label: "Camera",
              ontap: () {},
              iconColor: Colors.black,
            ),

            ChatBottomSheetOptions(
              icon: Ionicons.person_circle,
              label: "Contact",
              ontap: () {},
              iconColor: Colors.blue,
            ),

            ChatBottomSheetOptions(
              icon: Ionicons.document,
              label: "Document",
              ontap: () {},
              iconColor: Colors.blue.shade800,
            ),
          ],
        ),
      ),
    );
  }
}
