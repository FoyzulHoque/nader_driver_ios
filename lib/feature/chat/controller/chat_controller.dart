import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:nader_driver/feature/chat/models/driver_chat_model.dart';
import 'package:nader_driver/feature/chat/service/chat_service.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';

class DriverChatController extends GetxController {
  final DriverChatService _service = DriverChatService();

  // ── Single, persistent subscription ───────────────────────────────────────
  // Created once in onInit() and kept alive for the controller's lifetime.
  // NEVER cancelled between screen navigations — that is the critical fix.
  StreamSubscription<Map<String, dynamic>>? _subscription;

  // ── Reactive state ─────────────────────────────────────────────────────────
  final chats = <Map<String, dynamic>>[].obs;
  final isConnected = false.obs;
  final isLoadingChats = false.obs;
  final isPeerTyping = false.obs;
  final currentChatId = ''.obs; // carTransportId — set by screen
  final chatId = ''.obs; // server chatId from joinedChat
  final participants = Rx<ChatParticipants?>(null);

  // ── Internal ───────────────────────────────────────────────────────────────
  bool _authenticated = false;
  Timer? _pollTimer;

  // Tracks confirmed message IDs — prevents duplicates and stops
  // the Messages response from wiping real-time newMessage events.
  final Set<String> _messageIds = {};

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // Subscribe once here. The service's broadcast stream stays alive
    // across connect()/close() cycles, so this subscription always works.
    _subscription = _service.messageStream.listen(
      _handleEvent,
      onError: (e) {
        log('[DriverChatController] stream error: $e');
        isConnected.value = false;
        isLoadingChats.value = false;
      },
    );
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    _subscription?.cancel();
    _service.dispose();
    super.onClose();
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Called by DriverChatScreen each time it opens.
  Future<void> connectForChat() async {
    if (_service.isConnected && _authenticated) {
      // Already authenticated — just re-join to pull latest history.
      // Real-time messages received while the screen was closed are still
      // in [chats] and will be merged, not overwritten.
      if (currentChatId.value.isNotEmpty) {
        isLoadingChats.value = true;
        _doJoinAndFetch(currentChatId.value);
      }
      return;
    }

    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null) return;

    const wsUrl = 'ws://72.61.163.212:5006';
    isLoadingChats.value = true;

    _clearAll();
    _authenticated = false;
    _service.connect(wsUrl, token);
    isConnected.value = _service.isConnected;
  }

  /// Call from the chat screen's initState / onResume to start auto-refresh.
  void startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_authenticated && currentChatId.value.isNotEmpty) {
        _service.fetchMessages(currentChatId.value);
      }
    });
    log('[DriverChatController] Polling started');
  }

  /// Call from the chat screen's dispose / onPause to stop auto-refresh.
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    log('[DriverChatController] Polling stopped');
  }

  /// Send a plain-text message to the rider.
  void sendMessage(String carTransportId, String text) {
    if (text.trim().isEmpty) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = {
      'id': tempId,
      'message': text,
      'isSender': true,
      'isTemp': true,
      'status': 'sending',
      'createdAt': DateTime.now().toIso8601String(),
      'images': <String>[],
    };
    chats.add(tempMsg);
    chats.refresh();
    _service.sendMessage(carTransportId, text);
  }

  /// Send a message with image URLs.
  void sendWithImages(
    String carTransportId,
    String text,
    List<String> imageUrls,
  ) {
    _service.sendMessage(carTransportId, text, images: imageUrls);
  }

  /// Typing indicator stub — wire up when server supports it.
  void userTyping(String carTransportId) {}

  // ── Private ────────────────────────────────────────────────────────────────

  void _clearAll() {
    chats.clear();
    _messageIds.clear();
  }

  void _handleEvent(Map<String, dynamic> data) {
    final event = data['event'] as String? ?? '';
    log('[DriverChatController] event: $event');

    switch (event) {
      // ── Internal socket lifecycle events from the service ─────────────────
      case '__socketError':
      case '__socketClosed':
        isConnected.value = false;
        isLoadingChats.value = false;
        _authenticated = false;
        break;

      case 'authenticated':
        _authenticated = true;
        isConnected.value = true;
        log('[DriverChatController] Authenticated as DRIVER');
        if (currentChatId.value.isNotEmpty) {
          _doJoinAndFetch(currentChatId.value);
        }
        break;

      case 'joinedChat':
        final d = data['data'] as Map<String, dynamic>? ?? {};
        final joined = JoinedChatResponse.fromJson(d);
        chatId.value = joined.chatId;
        if (joined.carTransportId.isNotEmpty) {
          currentChatId.value = joined.carTransportId;
        }
        participants.value = joined.participants;
        log('[DriverChatController] Joined chat: ${chatId.value}');
        _service.fetchMessages(currentChatId.value);
        startPolling(); // auto-refresh every 3 s
        break;

      // Merge server history — never replace the whole list.
      // Any newMessage events received while the screen was closed
      // are already in [chats] and must not be wiped out.
      case 'Messages':
        final d = data['data'] as Map<String, dynamic>? ?? {};
        final fetched = FetchMessagesResponse.fromJson(d);
        participants.value = fetched.participants;
        _mergeFromServer(fetched.messages);
        isLoadingChats.value = false;
        log('[DriverChatController] Merged. Total: ${chats.length}');
        break;

      // Real-time message from the rider — append immediately.
      case 'newMessage':
        final d = data['data'] as Map<String, dynamic>? ?? {};
        final incoming = ChatMessage.fromJson({...d, 'isSender': false});
        _appendOrSkipDuplicate(incoming.toMap());
        log('[DriverChatController] ⚡ newMessage: ${incoming.message}');
        break;

      // Driver's own message confirmed by server.
      case 'messageSent':
        final d = data['data'] as Map<String, dynamic>? ?? {};
        final sent = ChatMessage.fromJson({...d, 'isSender': true});
        _confirmOrAppend(sent);
        log('[DriverChatController] messageSent confirmed: ${sent.message}');
        break;

      default:
        log('[DriverChatController] Unhandled event: $event');
    }
  }

  void _doJoinAndFetch(String ctId) {
    currentChatId.value = ctId;
    // Do NOT clear chats — keep real-time messages received while away.
    _service.joinChat(ctId);
  }

  /// Merges server history into the current list without removing
  /// real-time messages that already arrived.
  void _mergeFromServer(List<ChatMessage> serverMessages) {
    bool changed = false;

    for (final serverMsg in serverMessages) {
      final id = serverMsg.id;
      if (_messageIds.contains(id)) continue; // already in list

      final map = serverMsg.toMap();

      // Replace a matching temp optimistic bubble
      final tempIndex = chats.indexWhere(
        (m) =>
            m['isTemp'] == true &&
            m['message'] == serverMsg.message &&
            m['isSender'] == true,
      );

      if (tempIndex != -1) {
        chats[tempIndex] = map;
      } else {
        final insertIdx = _findInsertIndex(serverMsg.createdAt);
        chats.insert(insertIdx, map);
      }

      _messageIds.add(id);
      changed = true;
    }

    if (changed) chats.refresh();
  }

  /// Returns the index where a message with [createdAt] should be inserted
  /// to keep the list sorted oldest-first.
  int _findInsertIndex(String? createdAt) {
    if (createdAt == null) return chats.length;
    final dt = DateTime.tryParse(createdAt);
    if (dt == null) return chats.length;

    for (int i = 0; i < chats.length; i++) {
      final existing = DateTime.tryParse(
        chats[i]['createdAt'] as String? ?? '',
      );
      if (existing != null && existing.isAfter(dt)) return i;
    }
    return chats.length;
  }

  /// Replaces the temp optimistic bubble when messageSent arrives.
  void _confirmOrAppend(ChatMessage confirmed) {
    final id = confirmed.id;
    if (_messageIds.contains(id)) return;

    final tempIndex = chats.indexWhere(
      (m) =>
          m['isTemp'] == true &&
          m['message'] == confirmed.message &&
          m['isSender'] == true,
    );

    final confirmedMap = {
      ...confirmed.toMap(),
      'status': 'sent',
      'isTemp': false,
    };

    if (tempIndex != -1) {
      chats[tempIndex] = confirmedMap;
    } else {
      chats.add(confirmedMap);
    }

    _messageIds.add(id);
    chats.refresh();
  }

  /// Appends an incoming message, skipping duplicates.
  void _appendOrSkipDuplicate(Map<String, dynamic> incoming) {
    final id = incoming['id'] as String?;
    if (id != null && _messageIds.contains(id)) return;

    chats.add(incoming);
    if (id != null) _messageIds.add(id);
    chats.refresh();
  }
}
