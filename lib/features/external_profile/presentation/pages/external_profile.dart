import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/core/routes/route_name.dart';
import 'package:mail_messanger/features/external_profile/data/datasources/external_profile_datasource.dart';

class ExternalProfile extends StatefulWidget {
  const ExternalProfile({super.key, required this.args});

  /// Expected keys:
  ///   'userId'       — required, the profile owner's UID
  ///   'chatRoomId'   — optional, present when opened from inside a chat
  ///   'currentUserId'— optional, falls back to FirebaseAuth.currentUser
  final Map<String, dynamic> args;

  @override
  State<ExternalProfile> createState() => _ExternalProfileState();
}

class _ExternalProfileState extends State<ExternalProfile> {
  late final ExternalProfileDatasource _ds;
  late final String _userId;
  late final String? _chatRoomId;
  late final String _currentUserId;

  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _ds = ExternalProfileDatasource();
    _userId = widget.args['userId'] as String? ?? '';
    _chatRoomId = widget.args['chatRoomId'] as String?;
    _currentUserId =
        (widget.args['currentUserId'] as String?) ??
        FirebaseAuth.instance.currentUser?.uid ??
        '';
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final data = await _ds.fetchUser(_userId);
    if (mounted) setState(() { _userData = data; _loading = false; });
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    Color confirmColor = const Color(0xFFE53935),
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: confirmColor),
            child: Text(
              confirmLabel,
              style: TextStyle(fontWeight: FontWeight.w700, color: confirmColor),
            ),
          ),
        ],
      ),
    );
    return result == true;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _onAudioCall() {
    Navigator.pushNamed(
      context,
      RouteName.audioCallScreen,
      arguments: {
        'mode': 'outgoing',
        'otherUserId': _userId,
        'otherUserName': _userData?['name'] ?? '',
        'otherPhotoUrl': _userData?['photoUrl'],
      },
    );
  }

  void _onVideoCall() {
    Navigator.pushNamed(
      context,
      RouteName.videoCallScreen,
      arguments: {
        'mode': 'outgoing',
        'otherUserId': _userId,
        'otherUserName': _userData?['name'] ?? '',
        'otherPhotoUrl': _userData?['photoUrl'],
      },
    );
  }

  Future<void> _onClearChat() async {
    final chatRoomId = _chatRoomId;
    if (chatRoomId == null) return;
    final confirmed = await _showConfirmDialog(
      title: 'Clear Chat',
      body: 'All messages in this chat will be permanently deleted. This cannot be undone.',
      confirmLabel: 'Clear',
    );
    if (!confirmed) return;
    try {
      await _ds.clearChat(chatRoomId);
      _showSnackBar('Chat cleared.');
    } catch (_) {
      _showSnackBar('Failed to clear chat. Please try again.');
    }
  }

  Future<void> _onBlockUser() async {
    final name = _userData?['name'] ?? 'this user';
    final confirmed = await _showConfirmDialog(
      title: 'Block $name?',
      body: 'Blocked contacts will no longer be able to call you or send you messages.',
      confirmLabel: 'Block',
    );
    if (!confirmed) return;
    try {
      await _ds.blockUser(_currentUserId, _userId);
      _showSnackBar('$name has been blocked.');
    } catch (_) {
      _showSnackBar('Failed to block user. Please try again.');
    }
  }

  Future<void> _onUnblockUser() async {
    final name = _userData?['name'] ?? 'this user';
    try {
      await _ds.unblockUser(_currentUserId, _userId);
      _showSnackBar('$name has been unblocked.');
    } catch (_) {
      _showSnackBar('Failed to unblock user. Please try again.');
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        appBar: _ContactInfoAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userData == null) {
      return const Scaffold(
        appBar: _ContactInfoAppBar(),
        body: Center(child: Text('User not found.')),
      );
    }

    final name = (_userData!['name'] as String?) ?? 'Unknown';
    final phone = (_userData!['phone'] as String?) ?? '';
    final photoUrl = (_userData!['photoUrl'] as String?);
    final about = (_userData!['about'] as String?) ??
        "Hey there! I'm using Offenso";

    return Scaffold(
      appBar: const _ContactInfoAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ── Profile photo ──────────────────────────────────────────
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: (photoUrl?.isNotEmpty == true)
                      ? NetworkImage(photoUrl!)
                      : null,
                  child: (photoUrl?.isNotEmpty == true)
                      ? null
                      : const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white54,
                        ),
                ),
                const SizedBox(height: 12),

                // ── Name ──────────────────────────────────────────────────
                Text(
                  name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // ── Phone ─────────────────────────────────────────────────
                if (phone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                  ),
                ],

                // ── About / Status ────────────────────────────────────────
                const SizedBox(height: 6),
                Text(
                  about,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Action buttons ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: CupertinoIcons.phone,
                      label: 'Audio',
                      onTap: _onAudioCall,
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      customIcon: Image.asset(
                        'assets/icons/video.png',
                        height: 22,
                        color: Colors.white,
                      ),
                      label: 'Video',
                      onTap: _onVideoCall,
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: CupertinoIcons.search,
                      label: 'Search',
                      onTap: () =>
                          _showSnackBar('This feature will be available soon.'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Media / Starred tiles ─────────────────────────────────
                const _SectionCard(
                  children: [
                    TileInExternalProfileWidget(
                      icon: CupertinoIcons.photo,
                      text: 'Media, links and docs',
                      trailingContent1: '150',
                    ),
                    Divider(),
                    TileInExternalProfileWidget(
                      icon: CupertinoIcons.star,
                      text: 'Starred',
                      trailingContent1: 'None',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Chat management + Block/Unblock ───────────────────────
                StreamBuilder<List<String>>(
                  stream: _ds.streamBlockedUsers(_currentUserId),
                  builder: (context, snapshot) {
                    final blockedList = snapshot.data ?? [];
                    final isBlocked = blockedList.contains(_userId);

                    return _SectionCard(
                      children: [
                        if (_chatRoomId != null) ...[
                          ExternalProfileOptionWidget(
                            ontap: _onClearChat,
                            tileLabel: 'Clear chat',
                          ),
                          const Divider(),
                        ],
                        ExternalProfileOptionWidget(
                          ontap:
                              isBlocked ? _onUnblockUser : _onBlockUser,
                          tileLabel: isBlocked
                              ? 'Unblock ${_userData!['name'] ?? 'User'}'
                              : 'Block User',
                        ),
                        const Divider(),
                        ExternalProfileOptionWidget(
                          ontap: () =>
                              _showSnackBar(
                                'This feature will be available soon.',
                              ),
                          tileLabel: 'Report User',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared app bar ──────────────────────────────────────────────────────────
class _ContactInfoAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ContactInfoAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Contact info'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ── Section card wrapper ────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// ── Action button (Audio / Video / Search) ──────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    this.icon,
    this.customIcon,
    required this.label,
    required this.onTap,
  }) : assert(icon != null || customIcon != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customIcon != null)
              customIcon!
            else
              Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable option tile (red text) ─────────────────────────────────────────
class ExternalProfileOptionWidget extends StatelessWidget {
  const ExternalProfileOptionWidget({
    super.key,
    this.ontap,
    required this.tileLabel,
  });

  final VoidCallback? ontap;
  final String tileLabel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      minTileHeight: 44,
      title: Text(
        tileLabel,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Media / Starred row tile ─────────────────────────────────────────────────
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(text),
          const Spacer(),
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
            size: 28,
          ),
        ],
      ),
    );
  }
}

// ── Contact options widget (kept for backward compat) ─────────────────────────
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.greyShade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [Icon(icon), const SizedBox(height: 6), Text(text)],
      ),
    );
  }
}
