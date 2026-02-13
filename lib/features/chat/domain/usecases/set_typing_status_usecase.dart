import 'package:mail_messanger/features/chat/domain/repositories/i_chat_repositories.dart';

class SetTypingStatusUsecase {
  final IChatRepositories repository;

  SetTypingStatusUsecase(this.repository);

  Future<void> call(String chatId, String userId, bool isTyping) {
    return repository.setTypingStatus(chatId, userId, isTyping);
  }
}
