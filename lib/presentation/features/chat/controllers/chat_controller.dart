import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../sockets/socket_manager.dart';

class ChatController extends GetxController {
  final SocketManager socketManager = Get.find<SocketManager>();
  
  var messages = <MessageEntity>[].obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Listen to incoming messages from socket
    socketManager.messages.listen((text) {
      final msg = MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMine: false,
        timestamp: DateTime.now(),
      );
      messages.add(msg);
    });
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final msg = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMine: true,
      timestamp: DateTime.now(),
    );
    
    messages.add(msg);
    socketManager.sendMessage(text);
    textController.clear();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
