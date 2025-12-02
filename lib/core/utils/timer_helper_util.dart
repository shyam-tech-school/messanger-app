import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimerHelperUtil {
  // -- MAIN PARSER --
  // handles both string timestamps and Firebase Timestamp objects
  static DateTime _parse(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate(); // firebase time stamp
    }

    if (timestamp is String) {
      return DateTime.parse(timestamp.replaceAll(" ", "T"));
    }
    throw Exception('Unsupported timestamp format: $timestamp');
  }

  static bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  // --------------------------------

  // -- Convert 24h → 12-hour format --
  // "2025-12-01 14:20" → "2:20 PM"
  static String formatTo12Hour(dynamic timestamp) {
    try {
      final datetime = _parse(timestamp);

      int hour = datetime.hour;
      final minutes = datetime.minute.toString().padLeft(2, '0');
      String period = hour >= 12 ? "PM" : "AM";

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return "$hour:$minutes $period";
    } catch (_) {
      return timestamp.toString();
    }
  }

  // Chat list formatting:
  // Today → "10:45 AM" | Yesterday → "Yesterday" | Older → "Dec 1"
  static String formatChatListTime(dynamic timestamp) {
    final datetime = _parse(timestamp);
    final now = DateTime.now();

    final isToday = _isSameDay(datetime, now);
    final isYesterday = _isSameDay(
      datetime,
      now.subtract(const Duration(days: 1)),
    );

    if (isToday) return formatTo12Hour(timestamp);
    if (isYesterday) return "Yesterday";

    return DateFormat("MMM d").format(datetime);
  }

  // 3️⃣ Chat bubble footer time: "10:45 AM"
  static String formatMessageBubbleTime(dynamic timestamp) {
    return formatTo12Hour(timestamp);
  }

  // message count in chat list
  static int getUnreadCount(Map<String, dynamic> chat) {
    // If chat is marked read → unread is 0
    if (chat['isRead'] == true) return 0;

    List messages = chat['messages'];

    // Find last message sent by me
    int lastMyMsgIndex = messages.lastIndexWhere((m) => m['isMe'] == true);

    if (lastMyMsgIndex == -1) {
      // User never sent a message → all received messages are unread
      return messages.where((m) => m['isMe'] == false).length;
    }

    // Count received messages after my last sent message
    int unread = messages
        .sublist(lastMyMsgIndex + 1)
        .where((m) => m['isMe'] == false)
        .length;

    return unread;
  }
}
