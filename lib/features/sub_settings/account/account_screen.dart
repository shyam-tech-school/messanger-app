import 'package:flutter/material.dart';
import 'package:mail_messanger/core/routes/route_name.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: .min,
            children: List.generate(accountSettingsOptions.length, (index) {
              return SubSettingsTileWidget(
                options: accountSettingsOptions[index],
                index: index,
                items: accountSettingsOptions,
                ontap: () {
                  switch (index) {
                    case 0:
                      Navigator.pushNamed(context, RouteName.twoSVScreen);
                    case 1:
                      Navigator.pushNamed(context, RouteName.emailScreen);
                    case 2:
                      Navigator.pushNamed(
                        context,
                        RouteName.changePhoneNumberInfoScreen,
                      );
                    case 3:
                      Navigator.pushNamed(context, RouteName.deleteScreen);
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

List accountSettingsOptions = [
  'Two-setp verification',
  'Email address',
  'Change phone number',
  'Delete my account',
];
