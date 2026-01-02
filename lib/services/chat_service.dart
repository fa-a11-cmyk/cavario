import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatService extends ChangeNotifier {
  IO.Socket? _socket;
  final List<ChatMessage> _messages = [];
  bool _isConnected = false;

  List<ChatMessage> get messages => _messages;
  bool get isConnected => _isConnected;

  void connect(String userId, String userName) {
    _socket = IO.io('https://chat.cavario.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.on('connect', (_) {
      _isConnected = true;
      _socket!.emit('join', {'userId': userId, 'userName': userName});
      notifyListeners();
    });

    _socket!.on('disconnect', (_) {
      _isConnected = false;
      notifyListeners();
    });

    _socket!.on('message', (data) {
      final message = ChatMessage.fromJson(data);
      _messages.add(message);
      notifyListeners();
    });

    _socket!.on('user_joined', (data) {
      final systemMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'system',
        senderName: 'Système',
        message: '${data['userName']} a rejoint le chat',
        timestamp: DateTime.now(),
      );
      _messages.add(systemMessage);
      notifyListeners();
    });
  }

  void sendMessage(String message, String userId, String userName) {
    if (_socket != null && _isConnected) {
      final messageData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderId': userId,
        'senderName': userName,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      _socket!.emit('send_message', messageData);
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _isConnected = false;
    _messages.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}