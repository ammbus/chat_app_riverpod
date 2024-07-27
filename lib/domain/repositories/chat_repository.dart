import '../entities/chat_message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getChatMessagesStream();
  Future<void> sendMessage(ChatMessage message);
}
