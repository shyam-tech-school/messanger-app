import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart';
import 'package:mail_messanger/features/profile/presentation/provider/current_user_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.ontap});
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrentUserProvider>();
    final user = provider.user;
    final photoUrl = user?.photoUrl ?? '';
    final name = user?.name ?? '—';
    final about = (user?.about?.isNotEmpty == true) ? user!.about! : 'No status set';

    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          spacing: 14,
          children: [
            // Avatar
            Container(
              height: 72,
              width: 72,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
                border: Border.all(
                  color: ColorConstants.primaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : (photoUrl.isNotEmpty
                      ? Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.white38,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 36,
                          color: Colors.white38,
                        )),
            ),

            // Name + status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                      letterSpacing: .5,
                    ),
                  ),
                  Text(
                    about,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
