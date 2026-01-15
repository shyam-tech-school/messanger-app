import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';
import '../../domain/entities/matched_contact.dart';

class ContactsTileWidget extends StatelessWidget {
  final MatchedContact matchedContact;
  final VoidCallback onTap;

  const ContactsTileWidget({
    super.key,
    required this.matchedContact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 5),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 55,
          width: 55,
          padding: const .all(1),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: ColorConstants.dotColor,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            backgroundImage: matchedContact.photoUrl != null
                ? NetworkImage(matchedContact.photoUrl!)
                : null,
            child: matchedContact.photoUrl == null
                ? const Icon(Icons.person, size: 35)
                : null,
          ),
        ),
        title: Text(
          matchedContact.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        contentPadding: .zero,
      ),
    );
  }
}
