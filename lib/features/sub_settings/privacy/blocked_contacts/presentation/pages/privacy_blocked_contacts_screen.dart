import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/common/widget/dp_circle_image_widget.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/external_profile/data/datasources/external_profile_datasource.dart';

class PrivacyBlockedContactsScreen extends StatefulWidget {
  const PrivacyBlockedContactsScreen({super.key});

  @override
  State<PrivacyBlockedContactsScreen> createState() =>
      _PrivacyBlockedContactsScreenState();
}

class _PrivacyBlockedContactsScreenState
    extends State<PrivacyBlockedContactsScreen> {
  late final ExternalProfileDatasource _ds;
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _ds = ExternalProfileDatasource();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked contacts'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<String>>(
          stream: _ds.streamBlockedUsers(_currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final blockedIds = snapshot.data ?? [];

            if (blockedIds.isEmpty) {
              return const Center(
                child: Text(
                  'No blocked contacts',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _ds.fetchUsersByIds(blockedIds),
              builder: (context, userSnap) {
                if (userSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = userSnap.data ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final uid = user['uid'] as String? ?? '';
                    final name = user['name'] as String? ?? 'Unknown';
                    final photoUrl = user['photoUrl'] as String?;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.externalProfileScreen,
                          arguments: {
                            'userId': uid,
                            'currentUserId': _currentUserId,
                            'chatRoomId': null,
                          },
                        );
                      },
                      leading: DpCircleImageWidget(imageUrl: photoUrl),
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right_outlined),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
