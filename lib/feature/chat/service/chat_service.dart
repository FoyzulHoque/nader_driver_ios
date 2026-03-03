import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  final isConnected = false.obs;
  final isAuthenticated = false.obs;

  StreamSubscription? _subscription;

  void connect(String url, String token) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      isConnected.value = true;

      _subscription = _channel!.stream.listen(
        (message) {
          _handleIncoming(message);
        },
        onDone: () {
          if (kDebugMode) print("WebSocket closed.");
          isConnected.value = false;
          isAuthenticated.value = false;
        },
        onError: (error) {
          if (kDebugMode) print("WebSocket error: $error");
          isConnected.value = false;
          isAuthenticated.value = false;
        },
      );

      _authenticate(token);
    } catch (e) {
      if (kDebugMode) print("WebSocket connection failed: $e");
      isConnected.value = false;
    }
  }

  void _authenticate(String token) {
    final authMessage = jsonEncode({"event": "authenticate", "token": token});

    _channel?.sink.add(authMessage);

    if (kDebugMode) {
      print("Sent authentication message: $authMessage");
    }
  }

  void _handleIncoming(dynamic message) {
    try {
      final data = jsonDecode(message);

      if (data['event'] == 'authenticated') {
        if (kDebugMode) print("WebSocket authenticated.");
        isAuthenticated.value = true;
      }
    } catch (_) {}
  }

  Stream get messages => _channel!.stream;

  void sendMessage(String event, Map<String, dynamic> data) {
    if (!isConnected.value) {
      if (kDebugMode) print("Cannot send. Socket not connected.");
      return;
    }

    final message = jsonEncode({"event": event, ...data});
    _channel?.sink.add(message);

    if (kDebugMode) {
      print("Sent WebSocket message: $message");
    }
  }

  void close() {
    if (kDebugMode) print("Closing WebSocket connection.");
    isConnected.value = false;
    isAuthenticated.value = false;
    _subscription?.cancel();
    _channel?.sink.close();
  }
}
