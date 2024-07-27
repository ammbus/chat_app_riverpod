import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../../domain/entities/chat_message.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late TextEditingController messageController;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatStream = ref.watch(chatStreamProvider);

    return Scaffold(
      body: Center(
        child: chatStream.when(
          data: (data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final messageData = data[index];
                        return Align(
                          alignment: messageData.isMe ? Alignment.topRight : Alignment.topLeft,
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: messageData.isMe ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: messageData.isMe ? Radius.circular(20) : Radius.zero,
                                  bottomRight: messageData.isMe ? Radius.zero : Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              width: 300,
                              height: 100,
                              child: Center(
                                child: Text(messageData.message),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(border: OutlineInputBorder()),
                          )),
                    ),
                    IconButton(
                        onPressed: () async {
                          final repository = ref.read(chatRepositoryProvider);
                          final newMessage = ChatMessage(
                            message: messageController.text,
                            isMe: false,
                          );
                          await repository.sendMessage(newMessage);
                          messageController.clear();
                        },
                        icon: Icon(Icons.send))
                  ],
                )
              ],
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
