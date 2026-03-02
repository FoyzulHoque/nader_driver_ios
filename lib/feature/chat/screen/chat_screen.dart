import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../controller/chat_controller.dart';
import 'app_constants.dart';

class DriverChatScreen extends StatefulWidget {
  final String carTransportId;

  const DriverChatScreen({super.key, required this.carTransportId});

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  late final DriverChatController chatController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    chatController = Get.find<DriverChatController>();

    // ✅ Load userId once upfront
    _loadUserId();

    // ✅ Fetch chat messages
    chatController.fetchChats(widget.carTransportId);

    // ✅ Scroll to bottom when new messages arrive
    ever(chatController.chats, (_) {
      _scrollToBottom();
    });
  }

  Future<void> _loadUserId() async {
    final id = await SharedPreferencesHelper.getUserId();
    if (mounted) {
      setState(() {
        _currentUserId = id ?? '';
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.shade200,
      elevation: 0.5,
      foregroundColor: Colors.black,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.arrow_back, color: AppConstants.orangeAccent),
        ),
      ),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      if (chatController.isLoadingChats.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppConstants.orangeAccent),
        );
      }

      if (chatController.chats.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 56,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 12),
              Text(
                'No messages yet',
                style: TextStyle(color: Colors.grey[400], fontSize: 15),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: chatController.chats.length,
        itemBuilder: (context, index) {
          // reverse: true so index 0 = latest message
          final chat =
              chatController.chats[chatController.chats.length - 1 - index];
          final isMine =
              chat['isSender'] == true || chat['senderId'] == _currentUserId;
          return _buildMessageBubble(chat, isMine);
        },
      );
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> chat, bool isMine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMine ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMine
                  ? const Radius.circular(16)
                  : const Radius.circular(4),
              bottomRight: isMine
                  ? const Radius.circular(4)
                  : const Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (chat['message'] != null &&
                  chat['message'].toString().isNotEmpty)
                Text(
                  chat['message'],
                  style: TextStyle(
                    fontSize: 15,
                    color: isMine ? Colors.white : Colors.black87,
                    height: 1.4,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                _formatTime(chat['createdAt']),
                style: TextStyle(
                  fontSize: 11,
                  color: isMine
                      ? Colors.white.withOpacity(0.55)
                      : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Obx(() {
      if (!chatController.isPeerTyping.value) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 6),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DotAnimation(),
                const SizedBox(width: 6),
                Text(
                  'typing…',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) {
                    chatController.userTyping(widget.carTransportId);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Your message',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppConstants.orangeAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    chatController.sendMessage(widget.carTransportId, text);
    _messageController.clear();
    _scrollToBottom();
  }

  String _formatTime(dynamic createdAt) {
    try {
      if (createdAt is String && createdAt.isNotEmpty) {
        final dt = DateTime.tryParse(createdAt)?.toLocal();
        if (dt != null) {
          final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
          final m = dt.minute.toString().padLeft(2, '0');
          final ampm = dt.hour >= 12 ? 'PM' : 'AM';
          return '$h:$m $ampm';
        }
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}

// ✅ Simple animated typing dots
class _DotAnimation extends StatefulWidget {
  @override
  State<_DotAnimation> createState() => _DotAnimationState();
}

class _DotAnimationState extends State<_DotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final opacity = ((_controller.value * 3 - i) % 1).clamp(0.2, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
