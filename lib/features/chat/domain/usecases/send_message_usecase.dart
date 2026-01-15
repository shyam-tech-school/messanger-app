import 'package:mail_messanger/features/chat/domain/entities/message_entity.dart';
import 'package:mail_messanger/features/chat/domain/repositories/i_chat_repositories.dart';

class SendMessageUsecase {
  final IChatRepositories repository;

  SendMessageUsecase(this.repository);

  Future<void> call(MessageEntity message) {
    return repository.sendMessage(message);
  }
}
