import 'package:flutter/material.dart';
import 'package:mail_messanger/features/chats/data/datasources/chat_data_mock.dart';
import 'package:mail_messanger/features/otp/presentation/widgets/padding16_symmetric.dart';

import '../../../../core/constants/color_constants.dart';

class ContactsListScreen extends StatelessWidget {
  const ContactsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contacts",
          style: TextStyle(
            fontFamily: 'LuckiestGuy',
            color: ColorConstants.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding16Symmetric(
          child: ListView.builder(
            itemCount: chatData.length,
            itemBuilder: (context, index) {
              final list = chatData[index];
              return ListTile(
                onTap: () {},
                leading: Container(
                  height: 55,
                  width: 55,
                  padding: const .all(1),
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: ColorConstants.dotColor,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(list['profileDp']),
                  ),
                ),
                title: Text(
                  list['name'],
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
