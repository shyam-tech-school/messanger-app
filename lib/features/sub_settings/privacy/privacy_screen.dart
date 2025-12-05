import 'package:flutter/material.dart';

import '../../../core/routes/route_name.dart';

class PrivacyScreen extends StatelessWidget {
  PrivacyScreen({super.key});

  final List privacySettingsOptions = [
    'Last seen & online',
    'Profile photo',
    'About',
    'Blocked contacts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: .min,
            children: List.generate(privacySettingsOptions.length, (index) {
              return SubSettingsTileWidget(
                options: privacySettingsOptions[index],
                index: index,
                items: privacySettingsOptions,
                ontap: () {
                  switch (index) {
                    case 0:
                      Navigator.pushNamed(context, RouteName.lastSeenScreen);
                    case 1:
                      Navigator.pushNamed(
                        context,
                        RouteName.profilePhotoScreen,
                      );
                    case 2:
                      Navigator.pushNamed(context, RouteName.aboutScreen);
                    case 3:
                      Navigator.pushNamed(
                        context,
                        RouteName.blockedContactsScreen,
                      );
                    default:
                      const Scaffold(
                        body: Center(child: Text('/404 Page not found')),
                      );
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class SubSettingsTileWidget extends StatelessWidget {
  const SubSettingsTileWidget({
    super.key,
    required this.options,
    required this.index,
    required this.items,
    required this.ontap,
  });

  final String options;
  final int index;
  final List items;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: ontap,
          title: Text(options),
          trailing: const Icon(
            Icons.chevron_right,
            size: 28,
            color: Colors.grey,
          ),
        ),
        if (index != items.length - 1)
          Divider(
            height: 1,
            thickness: 0.3,
            color: Colors.grey.shade400,
            indent: 15,
          ),
      ],
    );
  }
}
