import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'chat_bottom_sheet_options.dart';

class OptionSheet extends StatelessWidget {
  const OptionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(16.0),
      child: Wrap(
        spacing: 30,
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
            icon: Ionicons.location,
            label: "Location",
            ontap: () {},
            iconColor: Colors.red.shade600,
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
    );
  }
}
