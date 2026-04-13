import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/features/profile/presentation/provider/current_user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'LuckiestGuy',
            color: ColorConstants.primaryColor,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/edit_profile')
                .then((_) => context.read<CurrentUserProvider>().refresh()),
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<CurrentUserProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = provider.user;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ─── Avatar section ───────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorConstants.primaryColor.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'profile-avatar',
                        child: _buildAvatar(user?.photoUrl, radius: 55),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user?.name ?? '—',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.phone ?? '—',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ─── Info tiles ───────────────────────────────────────
                _InfoTile(
                  label: 'Name',
                  value: user?.name ?? '—',
                  icon: Icons.person_outline,
                ),
                const Divider(height: 1, indent: 56),
                _InfoTile(
                  label: 'About',
                  value: user?.about?.isNotEmpty == true
                      ? user!.about!
                      : 'No status set',
                  icon: Icons.info_outline,
                ),
                const Divider(height: 1, indent: 56),
                _InfoTile(
                  label: 'Phone',
                  value: user?.phone ?? '—',
                  icon: Icons.phone_outlined,
                ),

                const SizedBox(height: 32),

                // ─── Edit button ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Profile'),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/edit_profile').then(
                        (_) => context.read<CurrentUserProvider>().refresh(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String? url, {double radius = 40}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white12,
      backgroundImage:
          (url != null && url.isNotEmpty) ? NetworkImage(url) : null,
      child: (url == null || url.isEmpty)
          ? Icon(Icons.person, size: radius, color: Colors.white38)
          : null,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: ColorConstants.primaryColor),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
