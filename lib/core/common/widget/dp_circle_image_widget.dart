import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class DpCircleImageWidget extends StatelessWidget {
  const DpCircleImageWidget({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: imageUrl == null
            ? const Icon(Icons.person, size: 35)
            : Image.network(imageUrl!, fit: BoxFit.cover),
      ),
    );
  }
}
