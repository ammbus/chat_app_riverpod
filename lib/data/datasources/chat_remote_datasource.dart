import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessageModel>> getChatMessagesStream();
  Future<void> sendMessage(ChatMessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final supa.SupabaseClient client;

  ChatRemoteDataSourceImpl(this.client);

  @override
  Stream<List<ChatMessageModel>> getChatMessagesStream() {
    final streamController = StreamController<List<ChatMessageModel>>();


    client.from('Chat').stream(primaryKey: ['id']).execute().listen((data) {
      final messages = data.map((item) => ChatMessageModel.fromMap(item)).toList();
      streamController.add(messages);
    });

    return streamController.stream;
  }

  @override
  Future<void> sendMessage(ChatMessageModel message) async {
    await client.from('Chat').insert(message.toMap());
  }
}
