import 'package:mail_messanger/features/chat/domain/repositories/i_chat_repositories.dart';

class StartChatUsecases {
  final IChatRepositories repositories;

  StartChatUsecases(this.repositories);

  Future<String> call(String currentUserId, String otherUserid) {
    return repositories.startChat(currentUserId, otherUserid);
  }
}
