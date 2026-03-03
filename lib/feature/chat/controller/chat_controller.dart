import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../service/chat_service.dart';
import '../../../../core/network_caller/endpoints.dart';

class DriverChatController extends GetxController {
  final WebSocketService webSocketService = WebSocketService();
  final ImagePicker _imagePicker = ImagePicker();

  var usersWithLastMessages = <dynamic>[].obs;
  var chats = <dynamic>[].obs;
  var isLoadingChats = true.obs;
  var isUploadingImage = false.obs;
  var selectedImagePath = "".obs;
  var isOptionsVisible = false.obs;
  var isLoadingUserList = true.obs;
  var currentUserId = ''.obs;
  var currentChatId = ''.obs;
  var isPeerTyping = false.obs;

  String? _lastSocketUrl;
  String? _lastToken;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;

  DateTime? _lastTypingSentAt;
  Timer? _typingResetTimer;

  @override
  void onInit() async {
    await _initializeSocketConnection();
    super.onInit();
  }

  @override
  void onClose() {
    webSocketService.close();
    _reconnectTimer?.cancel();
    _typingResetTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeSocketConnection() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final userId = await SharedPreferencesHelper.getUserId();

    if (token != null && token.isNotEmpty) {
      currentUserId.value = userId ?? '';
      _connectSocket('ws://brother-taxi.onrender.com', token);
    } else {
      if (kDebugMode) print("No token found, cannot initialize WebSocket.");
      isLoadingUserList.value = false;
    }
  }

  void _connectSocket(String url, String token) {
    _lastSocketUrl = url;
    _lastToken = token;

    webSocketService.connect(url, token);
    webSocketService.messages.listen(
      _handleMessage,
      onDone: _onSocketClosed,
      onError: (error, stack) {
        if (kDebugMode) print("WebSocket error: $error");
        _scheduleReconnect();
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      fetchUserList();
      if (currentChatId.value.isNotEmpty) {
        fetchChats(currentChatId.value);
      }
    });
  }

  void _handleMessage(dynamic message) {
    if (kDebugMode) print("Received WebSocket message: $message");

    try {
      final data = jsonDecode(message);

      switch (data['event']) {
        case "messageList":
          usersWithLastMessages.value = data['data'] ?? [];
          _sortUsersByLastMessage();
          isLoadingUserList.value = false;
          break;

        case "Messages":
          chats.value = data['data']?['messages'] ?? [];
          isLoadingChats.value = false;
          break;

        case "joinedChat":
          final joinedData = data['data'];
          chats.value = joinedData['messages'] ?? [];
          isLoadingChats.value = false;
          break;

        // ✅ Real-time new message — add immediately without full refetch
        case "Message":
        case "messageSent":
          final msgData = data['data'];
          if (msgData != null) {
            final incomingChatId = msgData['carTransportId']?.toString() ?? '';

            // ✅ Only add if it belongs to the current open chat
            if (incomingChatId == currentChatId.value) {
              // Avoid duplicates by checking id
              if (!chats.any((c) => c['id'] == msgData['id'])) {
                chats.add(msgData);
                chats.refresh(); // ✅ Triggers Obx rebuild
              }
            }

            // Always update the user list preview
            _updateUserListPreview(
              msgData['carTransportId']?.toString() ?? '',
              msgData,
            );
          }
          break;

        case "typing":
          _handleTypingEvent(data['data']);
          break;

        case "typingStopped":
          isPeerTyping.value = false;
          break;

        default:
          if (kDebugMode) print("Unknown event type: ${data['event']}");
      }
    } catch (e) {
      if (kDebugMode) print("Error parsing WebSocket message: $e");
    }
  }

  void _updateUserListPreview(
    String carTransportId,
    Map<String, dynamic> msgData,
  ) {
    final index = usersWithLastMessages.indexWhere(
      (u) => u['carTransportId'] == carTransportId,
    );

    if (index != -1) {
      usersWithLastMessages[index]['lastMessage'] = msgData;
    } else {
      usersWithLastMessages.insert(0, {
        'carTransportId': carTransportId,
        'user': {
          'id': msgData['receiverId'] ?? '',
          'name': '',
          'photos': {'url': ''},
        },
        'lastMessage': msgData,
      });
    }

    _sortUsersByLastMessage();
    usersWithLastMessages.refresh();
  }

  void _sortUsersByLastMessage() {
    usersWithLastMessages.sort((a, b) {
      final aTime =
          DateTime.tryParse(a['lastMessage']?['createdAt'] ?? '') ??
          DateTime(1970);
      final bTime =
          DateTime.tryParse(b['lastMessage']?['createdAt'] ?? '') ??
          DateTime(1970);
      return bTime.compareTo(aTime);
    });
  }

  Future<void> fetchUserList() async {
    isLoadingUserList.value = true;
    webSocketService.sendMessage("messageList", {});
  }

  Future<void> fetchChats(String carTransportId) async {
    isLoadingChats.value = true;
    currentChatId.value = carTransportId; // ✅ Always update current chat ID
    webSocketService.sendMessage("joinChat", {
      "carTransportId": carTransportId,
    });
  }

  void sendMessage(
    String carTransportId,
    String message, {
    List<String>? images,
  }) {
    // ✅ Optimistically add message to UI immediately
    final tempMsg = {
      'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'carTransportId': carTransportId,
      'message': message,
      'senderId': currentUserId.value,
      'isSender': true,
      'createdAt': DateTime.now().toIso8601String(),
      'isTemp': true,
    };
    chats.add(tempMsg);
    chats.refresh();

    // Then send via WebSocket
    webSocketService.sendMessage("Message", {
      "carTransportId": carTransportId,
      "message": message,
      "images": images ?? [],
    });

    _sendTypingStopped(carTransportId);
  }

  Future<void> pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      if (kDebugMode) print("Error selecting image: $e");
    }
  }

  Future<void> uploadImage(String carTransportId, String message) async {
    if (selectedImagePath.value.isEmpty) return;
    isUploadingImage.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final imageUrl = await _uploadImageToServer(token);
      if (imageUrl != null) {
        sendMessage(carTransportId, message, images: [imageUrl]);
        selectedImagePath.value = "";
      }
    } catch (e) {
      if (kDebugMode) print("Error uploading image: $e");
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<String?> _uploadImageToServer(String token) async {
    final uri = Uri.parse('${Urls.baseUrl}/chats/upload-images');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = token;

    final file = await http.MultipartFile.fromPath(
      'images',
      selectedImagePath.value,
    );
    request.files.add(file);

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);
      return responseJson['data'][0];
    }
    return null;
  }

  void userTyping(String carTransportId) {
    final now = DateTime.now();
    if (_lastTypingSentAt == null ||
        now.difference(_lastTypingSentAt!).inMilliseconds > 800) {
      _lastTypingSentAt = now;
      webSocketService.sendMessage("typing", {
        "carTransportId": carTransportId,
      });
    }
    _typingResetTimer?.cancel();
    _typingResetTimer = Timer(
      const Duration(seconds: 3),
      () => _sendTypingStopped(carTransportId),
    );
  }

  void _sendTypingStopped(String carTransportId) {
    webSocketService.sendMessage("typingStopped", {
      "carTransportId": carTransportId,
    });
  }

  void _handleTypingEvent(dynamic payload) {
    if (payload == null) return;
    final carTransportId = payload['carTransportId'] as String? ?? '';
    final senderId = payload['senderId'] as String? ?? '';
    if (carTransportId.isEmpty || senderId.isEmpty) return;
    if (carTransportId != currentChatId.value) return;
    if (senderId == currentUserId.value) return;

    isPeerTyping.value = true;
    _typingResetTimer?.cancel();
    _typingResetTimer = Timer(const Duration(seconds: 3), () {
      isPeerTyping.value = false;
    });
  }

  void _onSocketClosed() {
    if (kDebugMode) print("WebSocket closed");
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectTimer?.isActive == true) return;
    _reconnectAttempt += 1;
    final delay = Duration(seconds: _backoffSeconds(_reconnectAttempt));
    if (kDebugMode) {
      print(
        "Scheduling reconnect in ${delay.inSeconds}s (attempt $_reconnectAttempt)",
      );
    }
    _reconnectTimer = Timer(delay, () async {
      if (_lastSocketUrl != null && _lastToken != null) {
        _connectSocket(_lastSocketUrl!, _lastToken!);
      } else {
        await _initializeSocketConnection();
      }
    });
  }

  int _backoffSeconds(int attempt) {
    final v = 1 << (attempt - 1);
    return v > 16 ? 16 : v;
  }
}
