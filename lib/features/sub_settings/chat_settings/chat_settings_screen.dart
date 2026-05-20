import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/data/repositories/chat_repository.dart';
import '../../../core/common/widget/radio_group.dart';
import '../../../core/constants/color_constants.dart';
import '../account/two_step_verification/presentation/pages/two_step_verification.dart';
import 'provider/font_size_provider.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  late final ChatRepository _chatRepository;

  @override
  void initState() {
    super.initState();
    _chatRepository = ChatRepository(
      ChatRemoteDataSourceImpl(FirebaseFirestore.instance),
    );
  }

  Future<void> _handleClearAllChats() async {
    final confirmed = await _showConfirmationDialog(
      title: 'Clear All Chats',
      content: 'Are you sure you want to clear all your chats? The message history will be removed, but the chats will remain in your recent list.',
    );

    if (confirmed == true && mounted) {
      try {
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        await _chatRepository.clearAllChats(currentUserId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All chats cleared successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear chats: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleDeleteAllChats() async {
    final confirmed = await _showConfirmationDialog(
      title: 'Delete All Chats',
      content: 'Are you sure you want to completely delete all your chats? This cannot be undone and will remove all chats from your recent list.',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      try {
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        await _chatRepository.deleteAllChats(currentUserId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All chats deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete chats: $e')),
          );
        }
      }
    }
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String content,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.red : null,
            ),
            child: Text(isDestructive ? 'Delete' : 'Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Consumer<FontSizeProvider>(
        builder: (context, fontSizeProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select font size",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: ColorConstants.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: RadioGroup1<int>(
                    initialValue: fontSizeProvider.radioIndex,
                    options: [
                      RadioOption(label: "Small", value: 0),
                      RadioOption(label: "Medium", value: 1),
                      RadioOption(label: "Large", value: 2),
                    ],
                    onChanged: (value) {
                      fontSizeProvider.setFontSizeFromIndex(value);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SubSettingsWidget(
                  text: 'Clear all chats',
                  ontap: _handleClearAllChats,
                  isRed: true,
                ),
                const SizedBox(height: 12),
                SubSettingsWidget(
                  text: 'Delete all chats',
                  ontap: _handleDeleteAllChats,
                  isRed: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
