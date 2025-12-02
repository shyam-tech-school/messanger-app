import 'package:flutter/material.dart';

import 'settings_tile.dart';

class SettingsSection extends StatelessWidget {
  final List<SettingsTile> items;

  const SettingsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index != items.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.3,
                  color: Colors.grey.shade400,
                  indent: 55,
                ),
            ],
          );
        }),
      ),
    );
  }
}
