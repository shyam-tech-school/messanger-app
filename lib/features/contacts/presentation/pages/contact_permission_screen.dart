import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/contacts/presentation/provider/contact_permission_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/contact_preview_tile_widget.dart';

class ContactPermissionScreen extends StatelessWidget {
  const ContactPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactPermissionProvider = context.watch<ContactsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 100),

              /// Contact preview
              const Column(
                children: [
                  ContactPreviewTile(
                    name: "Kestrel Jane",
                    image: "https://randomuser.me/api/portraits/women/21.jpg",
                  ),
                  ContactPreviewTile(
                    name: "Jordan Monaco",
                    image: "https://randomuser.me/api/portraits/men/32.jpg",
                    opacity: 0.8,
                  ),
                  ContactPreviewTile(
                    name: "Josie Holtman",
                    image: "https://randomuser.me/api/portraits/women/44.jpg",
                    opacity: 0.6,
                  ),
                  ContactPreviewTile(
                    name: "Daniel Grey",
                    image: "https://randomuser.me/api/portraits/men/12.jpg",
                    opacity: 0.3,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// Title
              Text(
                "Find Your Friends",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'LuckiestGuy',
                  color: ColorConstants.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              /// Description
              Text(
                "Turn on contacts so you can send messages and share events with friends on Dive Chat.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: ColorConstants.white),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              /// Privacy note
              Text(
                "This is only used to find people you know. "
                "We won’t text or notify anyone without your permission.",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              /// Primary button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: contactPermissionProvider.isSyncing
                      ? null
                      : () async {
                          final success = await contactPermissionProvider
                              .requestAndSyncContacts();

                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              RouteName.navigationScreen,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                  ),
                  child: contactPermissionProvider.isSyncing
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.black,
                          ),
                        )
                      : const Text(
                          "Turn on Contacts",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.black,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
