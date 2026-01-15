import 'package:mail_messanger/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';
import 'package:mail_messanger/features/chat/domain/repositories/i_chat_repositories.dart';

class ChatRepository implements IChatRepositories {
  final ChatRemoteDatasource remoteDs;

  ChatRepository(this.remoteDs);

  @override
  Future<String> startChat(String currentUserId, String otherUserId) {
    return remoteDs.startChat(currentUserId, otherUserId);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return remoteDs.getMessages(chatId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    return remoteDs.sendMessage(message);
  }
}
