import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/widget/dp_circle_image_widget.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/timer_helper_util.dart';

class CallTile extends StatelessWidget {
  const CallTile({
    super.key,
    required this.username,
    required this.dpImage,
    required this.callType,
    required this.direction,
    required this.time,
    required this.isMissed,
  });

  final String username;
  final String dpImage;
  final String callType;
  final String direction;
  final String time;
  final bool isMissed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DpCircleImageWidget(imageUrl: dpImage),
      title: Text(
        username,
        maxLines: 1,
        overflow: .ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: isMissed ? Colors.red : null,
        ),
      ),
      subtitle: Row(
        spacing: 4,
        children: [
          if (callType == 'audio') ...[
            Icon(
              direction == 'incoming'
                  ? CupertinoIcons.phone_fill_arrow_down_left
                  : CupertinoIcons.phone_fill_arrow_up_right,
              size: 20,
            ),
          ] else ...[
            Image.asset(
              direction == 'incoming'
                  ? 'assets/icons/video_incoming.png'
                  : 'assets/icons/video_outgoing.png',
              height: 22,
              color: ColorConstants.grey,
            ),
          ],
          Text(direction),
        ],
      ),
      trailing: Text(
        TimerHelperUtil.formatChatListTime(time),
        style: const TextStyle(color: ColorConstants.grey),
      ),
    );
  }
}
