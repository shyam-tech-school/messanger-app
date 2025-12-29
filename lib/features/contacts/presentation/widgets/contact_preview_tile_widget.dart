import 'package:flutter/material.dart';
import 'package:mail_messanger/core/constants/color_constants.dart'
    show ColorConstants;

class ContactPreviewTile extends StatelessWidget {
  final String name;
  final double opacity;
  final String image;

  const ContactPreviewTile({
    super.key,
    required this.name,
    this.opacity = 1,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const .fromLTRB(30, 12, 30, 0),
        padding: const .symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: .circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundImage: NetworkImage(image)),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: ColorConstants.black,
                    ),
                  ),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: .circular(12),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: .circular(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),

            const Icon(
              Icons.chevron_right,
              size: 30,
              color: ColorConstants.grey,
            ),
          ],
        ),
      ),
    );
  }
}
