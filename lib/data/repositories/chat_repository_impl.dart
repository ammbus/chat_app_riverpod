
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ChatMessage>> getChatMessagesStream() {
    return remoteDataSource.getChatMessagesStream().map((models) =>
        models.map((model) => ChatMessage(message: model.message, isMe: model.isMe)).toList());
  }

  @override
  Future<void> sendMessage(ChatMessage message) {
    final model = ChatMessageModel(message: message.message, isMe: message.isMe);
    return remoteDataSource.sendMessage(model);
  }
}
