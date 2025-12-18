import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class PrimaryBtnWidget extends StatelessWidget {
  const PrimaryBtnWidget({
    super.key,
    required this.progress,
    required this.label,
    required this.ontap,
    required this.isEnabled,
  });

  final double progress;
  final String label;
  final Function()? ontap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? ontap : null,
      child: SizedBox(
        height: 60,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: .circular(10),
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: MediaQuery.of(context).size.width * progress,
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class PrimaryButton extends StatelessWidget {
//   const PrimaryButton({super.key, required this.onTap, required this.label});

//   final Function()? onTap;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 60,
//         width: .maxFinite,
//         decoration: BoxDecoration(
//           color: ColorConstants.primaryColor,
//           borderRadius: .circular(10),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           label,
//           style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//             fontWeight: FontWeight.w700,
//             color: ColorConstants.black,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//       ),
//     );
//   }
// }
