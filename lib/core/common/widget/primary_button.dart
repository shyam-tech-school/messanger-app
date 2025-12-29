import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class PrimaryBtnWidget extends StatelessWidget {
  const PrimaryBtnWidget({
    super.key,
    required this.progress,
    required this.label,
    required this.onTap,
    required this.isLoading,
  });

  final double progress;
  final String label;
  final Function()? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
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

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        key: ValueKey('loader'),
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        key: const ValueKey('text'),
                        label,
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: ColorConstants.black,
                        ),
                      ),
                    ),
            ),

            // Center(
            //   child: Text(
            //     label,
            //     style: const TextStyle(
            //       fontFamily: 'OpenSans',
            //       fontWeight: FontWeight.w700,
            //       color: ColorConstants.black,
            //     ),
            //   ),
            // ),
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
