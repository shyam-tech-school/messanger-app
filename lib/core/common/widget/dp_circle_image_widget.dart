import 'package:flutter/cupertino.dart';

import '../../constants/color_constants.dart';

class DpCircleImageWidget extends StatelessWidget {
  const DpCircleImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      padding: const .all(1),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: ColorConstants.primary,
        shape: BoxShape.circle,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Image.network(imageUrl),
      ),
    );
  }
}
