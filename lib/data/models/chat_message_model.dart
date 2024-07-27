class ChatMessageModel {
  final String message;
  final bool isMe;

  ChatMessageModel({required this.message, required this.isMe});

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      message: map['message'] ?? '',
      isMe: map['is_me'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'is_me': isMe,
    };
  }
}
