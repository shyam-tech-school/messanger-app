import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';

class ExternalProfile extends StatelessWidget {
  const ExternalProfile({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact info')),
      body: SizedBox(
        width: .maxFinite,
        height: .maxFinite,
        child: Padding(
          padding: const .all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(user['profileDp']),
              ),
              const SizedBox(height: 12),

              Text(
                user['name'],
                maxLines: 2,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text('+91 98XXXXXX00'),
              const SizedBox(height: 12 / 2),
              const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Options
              Row(
                spacing: 12,
                mainAxisAlignment: .center,
                children: [
                  const ContactOptionsProfile(
                    icon: CupertinoIcons.phone,
                    text: "Audio ",
                  ),
                  Container(
                    padding: const .all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorConstants.greyShade300),
                      borderRadius: .circular(12),
                    ),
                    child: Column(
                      spacing: 6,
                      children: [
                        Image.asset('assets/icons/video.png', height: 24),
                        const Text("Video "),
                      ],
                    ),
                  ),
                  const ContactOptionsProfile(
                    icon: CupertinoIcons.search,
                    text: "Search",
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Profile Settings
              Container(
                padding: const .fromLTRB(16, 16, 0, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  children: [
                    TileInExternalProfileWidget(
                      icon: CupertinoIcons.photo,
                      text: 'Media, links and docs',
                      trailingContent1: '150',
                    ),
                    Divider(),
                    TileInExternalProfileWidget(
                      icon: CupertinoIcons.star,
                      text: "Starred",
                      trailingContent1: "None",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Clear, Block, Report
              // SubSettingsWidget(text: 'Clear chat', ontap: () {}, isRed: true),
              // const SizedBox(height: 12),
              // SubSettingsWidget(text: 'Block user', ontap: () {}, isRed: true),
              // const SizedBox(height: 12),
              // SubSettingsWidget(text: 'Report user', ontap: () {}, isRed: true),
              Container(
                padding: const .fromLTRB(16, 16, 0, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    ExternalProfileOptionWidget(
                      ontap: () {
                        debugPrint('Clear chat');
                      },
                      tileLabel: "Clear chat",
                    ),
                    Divider(),
                    ExternalProfileOptionWidget(
                      ontap: () {
                        debugPrint('Block user');
                      },
                      tileLabel: "Block User",
                    ),
                    Divider(),
                    ExternalProfileOptionWidget(
                      ontap: () {
                        debugPrint('Report User');
                      },
                      tileLabel: "Report User",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExternalProfileOptionWidget extends StatelessWidget {
  const ExternalProfileOptionWidget({
    super.key,
    this.ontap,
    required this.tileLabel,
  });

  final Function()? ontap;
  final String tileLabel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      contentPadding: .zero,
      minVerticalPadding: 0,
      minTileHeight: 40,
      title: Text(
        tileLabel,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class TileInExternalProfileWidget extends StatelessWidget {
  const TileInExternalProfileWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.trailingContent1,
  });

  final IconData icon;
  final String text;
  final String trailingContent1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Text(text),
        const Spacer(),
        Row(
          children: [
            Text(
              trailingContent1,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 30,
            ),
          ],
        ),
      ],
    );
  }
}

class ContactOptionsProfile extends StatelessWidget {
  const ContactOptionsProfile({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(20),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.greyShade300),
        borderRadius: .circular(12),
      ),
      child: Column(spacing: 6, children: [Icon(icon), Text(text)]),
    );
  }
}
