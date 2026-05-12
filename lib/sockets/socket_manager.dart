import 'dart:async';
import 'dart:io';
import 'packet_formatter.dart';

class SocketManager {
  ServerSocket? _serverSocket;
  Socket? _socket;
  Timer? _heartbeatTimer;

  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  Future<void> startServer(String ip, int port) async {
    _serverSocket = await ServerSocket.bind(ip, port);
    print("Server started on $ip:$port");
    _serverSocket!.listen((client) {
      _socket = client;
      _listenToSocket();
      _startHeartbeat();
    });
  }

  Future<void> connectToServer(String ip, int port) async {
    _socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 10));
    print("Connected to server at $ip:$port");
    _listenToSocket();
    _startHeartbeat();
  }

  void _listenToSocket() {
    _socket?.listen((data) {
      // Decode the data (in a real app, handle stream chunking/buffering)
      if (data.length > 5) {
        final type = data[4];
        if (type == PacketType.heartbeat.index) {
          print("Heartbeat received");
        } else if (type == PacketType.text.index) {
          final text = PacketFormatter.decodePacket(data) as String;
          _messageController.add(text);
        }
      }
    }, onDone: () {
      disconnect();
    }, onError: (e) {
      print("Socket error: $e");
      disconnect();
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      sendMessage("PING", isHeartbeat: true);
    });
  }

  void sendMessage(String text, {bool isHeartbeat = false}) {
    if (_socket != null) {
      final packet = PacketFormatter.encodePacket(
        isHeartbeat ? PacketType.heartbeat : PacketType.text,
        text,
      );
      _socket!.add(packet);
    }
  }

  void disconnect() {
    _heartbeatTimer?.cancel();
    _socket?.close();
    _serverSocket?.close();
    _socket = null;
    _serverSocket = null;
  }
}
