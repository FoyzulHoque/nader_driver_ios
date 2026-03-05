// ─── Sender ──────────────────────────────────────────────────────────────────

class ChatSender {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;

  ChatSender({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  factory ChatSender.fromJson(Map<String, dynamic> json) => ChatSender(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    profileImage: json['profileImage'] ?? '',
  );
}

// ─── Chat Message ─────────────────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final List<String> images;
  final bool isRead;
  final bool isSender; // true = current driver sent this
  final String createdAt;
  final String updatedAt;
  final ChatSender? sender;

  // Local-only fields for optimistic UI
  final String status; // 'sending' | 'sent' | 'delivered' | 'read'
  final bool isTemp;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.images,
    required this.isRead,
    required this.isSender,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.status = 'sent',
    this.isTemp = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] ?? '',
    chatId: json['ChatId'] ?? json['chatId'] ?? '',
    senderId: json['senderId'] ?? '',
    message: json['message'] ?? '',
    images: List<String>.from(json['images'] ?? []),
    isRead: json['isRead'] ?? false,
    isSender: json['isSender'] ?? false,
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
    sender: json['sender'] != null ? ChatSender.fromJson(json['sender']) : null,
    status: 'sent',
    isTemp: false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'ChatId': chatId,
    'senderId': senderId,
    'message': message,
    'images': images,
    'isRead': isRead,
    'isSender': isSender,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'status': status,
    'isTemp': isTemp,
    if (sender != null)
      'sender': {
        'id': sender!.id,
        'fullName': sender!.fullName,
        'email': sender!.email,
        'profileImage': sender!.profileImage,
      },
  };

  ChatMessage copyWith({String? status, bool? isTemp, bool? isRead}) =>
      ChatMessage(
        id: id,
        chatId: chatId,
        senderId: senderId,
        message: message,
        images: images,
        isRead: isRead ?? this.isRead,
        isSender: isSender,
        createdAt: createdAt,
        updatedAt: updatedAt,
        sender: sender,
        status: status ?? this.status,
        isTemp: isTemp ?? this.isTemp,
      );
}

// ─── Participants ─────────────────────────────────────────────────────────────

class ChatParticipants {
  final ChatSender sender;
  final ChatSender driver;

  ChatParticipants({required this.sender, required this.driver});

  factory ChatParticipants.fromJson(Map<String, dynamic> json) =>
      ChatParticipants(
        sender: ChatSender.fromJson(json['sender'] ?? {}),
        driver: ChatSender.fromJson(json['driver'] ?? {}),
      );
}

// ─── joinedChat response ──────────────────────────────────────────────────────

class JoinedChatResponse {
  final String chatId;
  final String carTransportId;
  final ChatParticipants participants;
  final List<ChatMessage> messages;

  JoinedChatResponse({
    required this.chatId,
    required this.carTransportId,
    required this.participants,
    required this.messages,
  });

  factory JoinedChatResponse.fromJson(Map<String, dynamic> json) =>
      JoinedChatResponse(
        chatId: json['chatId'] ?? '',
        carTransportId: json['riderDriverTransportId'] ?? '',
        participants: ChatParticipants.fromJson(json['participants'] ?? {}),
        messages: (json['messages'] as List? ?? [])
            .map((m) => ChatMessage.fromJson(m))
            .toList(),
      );
}

// ─── Messages (fetchMessages) response ───────────────────────────────────────

class FetchMessagesResponse {
  final String carTransportId;
  final ChatParticipants participants;
  final List<ChatMessage> messages;

  FetchMessagesResponse({
    required this.carTransportId,
    required this.participants,
    required this.messages,
  });

  factory FetchMessagesResponse.fromJson(Map<String, dynamic> json) =>
      FetchMessagesResponse(
        carTransportId: json['carTransportId'] ?? '',
        participants: ChatParticipants.fromJson(json['participants'] ?? {}),
        messages: (json['messages'] as List? ?? [])
            .map((m) => ChatMessage.fromJson(m))
            .toList(),
      );
}
