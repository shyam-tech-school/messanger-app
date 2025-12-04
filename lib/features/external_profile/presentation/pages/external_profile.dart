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

              // Profile Settings
            ],
          ),
        ),
      ),
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
