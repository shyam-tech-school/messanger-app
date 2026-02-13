import 'package:mail_messanger/features/chat/domain/repositories/i_chat_repositories.dart';

class StreamTypingStatusUsecase {
  final IChatRepositories repository;

  StreamTypingStatusUsecase(this.repository);

  Stream<bool> call(String chatId, String userId) {
    return repository.streamTypingStatus(chatId, userId);
  }
}
