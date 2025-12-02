class ChatHelperUtil {
  static String buildPreviewMessage(Map<String, dynamic>? message) {
    if (message == null) return "";

    switch (message['type']) {
      case "text":
        return message['text'];
      case "image":
        return "📷 Photo";
      case "voice":
        return "🎤 Voice message (${message['voiceDuration']})";
      default:
        return "Message";
    }
  }

  // unread message
  static int calculateUnread(List messages, bool isRead) {
    if (isRead) return 0;

    // Step 1: find last message sent by me
    int lastMyMsgIndex = messages.lastIndexWhere((m) => m['isMe'] == true);

    // Step 2: count messages after lastMe that are received
    return messages
        .sublist(lastMyMsgIndex + 1)
        .where((m) => m['isMe'] == false)
        .length;
  }
}
