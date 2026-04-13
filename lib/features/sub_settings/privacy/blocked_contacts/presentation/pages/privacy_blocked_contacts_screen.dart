import 'package:flutter/material.dart';
import 'package:mail_messanger/features/chats/data/datasources/chat_data_mock.dart';

import '../../../../../../core/constants/color_constants.dart';

class PrivacyBlockedContactsScreen extends StatelessWidget {
  const PrivacyBlockedContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blocked contacts"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: chatData.length,
          itemBuilder: (context, index) {
            final users = chatData[index];
            return Padding(
              padding: const .only(top: 10),
              child: ListTile(
                onTap: () {},
                leading: Container(
                  height: 55,
                  width: 55,
                  padding: const .all(2),
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: ColorConstants.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(users['profileDp']),
                  ),
                ),
                title: Text(
                  users['name'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right_outlined),
                contentPadding: .zero,
              ),
            );
          },
          padding: const .symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
