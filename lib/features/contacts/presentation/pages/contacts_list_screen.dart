import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mail_messanger/core/constants/image_path_constants.dart';
import 'package:mail_messanger/core/constants/text_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/core/utils/app_logger.dart';
import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/contacts/domain/entities/matched_contact.dart';
import 'package:mail_messanger/features/contacts/presentation/provider/contact_permission_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/color_constants.dart';
import '../widgets/contacts_tile_widget.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}
class _ContactsListScreenState extends State<ContactsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ContactsProvider>().requestAndSyncContacts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactsProvider>(context);
    final List<MatchedContact> contacts = provider.matchedContacts;

    AppLogger.i('matched contacts: ${provider.matchedContacts.length}');

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "Contacts",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontFamily: 'LuckiestGuy',
              color: ColorConstants.primaryColor,
              letterSpacing: 2,
            ),
          ),
        ),
        actions: const [ContactMoreOptionWidget()],
        titleSpacing: 5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const .all(16),
          child: Column(
            children: [
              const CupertinoSearchTextField(),
              const SizedBox(height: 12),

              if (contacts.isEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Container(
                        //color: Colors.red,
                        child: Lottie.asset(
                          ImagePathConstants.noContacts,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(TextConstants.noContactsFound),
                    ],
                  ),
                ),

              if (contacts.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) => ContactsTileWidget(
                      matchedContact: contacts[index],
                      onTap: () async {
                        final chatRemoteDs = ChatRemoteDataSourceImpl(
                          FirebaseFirestore.instance,
                        );

                        final currentUserId =
                            FirebaseAuth.instance.currentUser!.uid;

                        final otherUserId = contacts[index].uid;

                        final chatRoomId = await chatRemoteDs.startChat(
                          currentUserId,
                          otherUserId,
                        );

                        final otherUserNamme = contacts[index].name;
                        final otherUserImagerUrl = contacts[index].photoUrl;

                        Navigator.pushNamed(
                          context,
                          RouteName.chatScreen,
                          arguments: {
                            'chatRoomId': chatRoomId,
                            'otherUserId': otherUserId,
                            'otherUserName': otherUserNamme,
                            'otherUserImageUrl': otherUserImagerUrl,
                            'currentUserId': currentUserId,
                          },
                        );
                      },
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

class ContactMoreOptionWidget extends StatelessWidget {
  const ContactMoreOptionWidget({super.key});

  void _openSettings() {
    debugPrint('Contact settings');
  }

  void _onContactRefresh(BuildContext context) async {
    AppLogger.i('Contact refreshed');
    context.read<ContactsProvider>().requestAndSyncContacts();
  }

  void _onHelp() {
    debugPrint('On help');
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'settings':
            _openSettings();
            break;
          case 'refresh':
            _onContactRefresh(context);
            break;
          case 'help':
            _onHelp();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'settings', child: Text('Contact Settings')),
        const PopupMenuItem(value: 'refresh', child: Text('Refresh')),
        const PopupMenuItem(value: 'help', child: Text('Help')),
      ],
      tooltip: 'More options',
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
    );
  }
}
