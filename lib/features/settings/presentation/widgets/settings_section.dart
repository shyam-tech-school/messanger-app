import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

import 'settings_tile.dart';

class SettingsSection extends StatelessWidget {
  final List<SettingsTile> items;

  const SettingsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: .circular(20),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index != items.length - 1)
                const Divider(
                  height: 1,
                  thickness: 2,
                  color: ColorConstants.darkScaffoldBgColor,
                ),
            ],
          );
        }),
      ),
    );
  }
}
