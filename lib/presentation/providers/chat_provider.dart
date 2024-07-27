import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

final supabaseClientProvider = Provider<supa.SupabaseClient>((ref) {
  return supa.Supabase.instance.client;
});

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ChatRemoteDataSourceImpl(client);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(remoteDataSource);
});

final chatStreamProvider = StreamProvider.autoDispose<List<ChatMessage>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatMessagesStream();
});
