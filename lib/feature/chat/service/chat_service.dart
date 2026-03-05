import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DriverChatService {
  WebSocketChannel? _channel;
  StreamSubscription? _channelSub;

  // Single broadcast controller that lives for the lifetime of the service.
  // It is NEVER closed between reconnections — only on dispose().
  final _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool _isConnected = false;

  bool get isConnected => _isConnected && _channel != null;

  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  /// Opens a WebSocket connection and pipes every message into [messageStream].
  /// Safe to call multiple times — tears down the old socket first.
  void connect(String url, String token) {
    // ── Tear down any existing socket ──────────────────────────────────────
    _channelSub?.cancel();
    _channelSub = null;
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;

    // ── Open new socket ────────────────────────────────────────────────────
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;

      // Pipe raw WebSocket frames into the shared broadcast stream.
      // The controller subscription keeps working across screen navigations.
      _channelSub = _channel!.stream.listen(
        (raw) {
          if (_messageStreamController.isClosed) return;
          try {
            final data = jsonDecode(raw as String) as Map<String, dynamic>;
            if (kDebugMode) print('[DriverChatService] ← $data');
            _messageStreamController.add(data);
          } catch (e) {
            if (kDebugMode) print('[DriverChatService] JSON decode error: $e');
          }
        },
        onError: (error) {
          if (kDebugMode) print('[DriverChatService] Stream error: $error');
          _isConnected = false;
          if (!_messageStreamController.isClosed) {
            _messageStreamController.add({
              'event': '__socketError',
              'error': error.toString(),
            });
          }
        },
        onDone: () {
          if (kDebugMode) print('[DriverChatService] Connection closed');
          _isConnected = false;
          if (!_messageStreamController.isClosed) {
            _messageStreamController.add({'event': '__socketClosed'});
          }
        },
        cancelOnError: false,
      );

      _sendRaw({"event": "authenticate", "token": token});
    } catch (e) {
      if (kDebugMode) print('[DriverChatService] Connection error: $e');
      _isConnected = false;
    }
  }

  void joinChat(String carTransportId) {
    _sendRaw({"event": "joinChat", "carTransportId": carTransportId});
  }

  void fetchMessages(String carTransportId) {
    _sendRaw({"event": "fetchMessages", "carTransportId": carTransportId});
  }

  void sendMessage(
    String carTransportId,
    String message, {
    List<String> images = const [],
  }) {
    _sendRaw({
      "event": "Message",
      "carTransportId": carTransportId,
      "message": message,
      if (images.isNotEmpty) "images": images,
    });
  }

  void _sendRaw(Map<String, dynamic> payload) {
    if (!isConnected) {
      if (kDebugMode) {
        print('[DriverChatService] Not connected. Cannot send: $payload');
      }
      return;
    }
    try {
      final encoded = jsonEncode(payload);
      _channel!.sink.add(encoded);
      if (kDebugMode) print('[DriverChatService] → $encoded');
    } catch (e) {
      if (kDebugMode) print('[DriverChatService] Send error: $e');
    }
  }

  /// Closes only the WebSocket, leaving [messageStream] open.
  /// The controller can reconnect by calling [connect] again.
  void close() {
    _channelSub?.cancel();
    _channelSub = null;
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    if (kDebugMode) print('[DriverChatService] Socket closed');
  }

  /// Closes everything including the broadcast stream. Call only when the
  /// service is being permanently discarded (controller onClose).
  void dispose() {
    close();
    if (!_messageStreamController.isClosed) {
      _messageStreamController.close();
    }
    if (kDebugMode) print('[DriverChatService] Disposed');
  }
}
