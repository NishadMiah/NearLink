import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import '../sockets/socket_manager.dart';

class TransferEngine extends GetxService {
  final SocketManager _socketManager = Get.find<SocketManager>();
  static const int chunkSize = 1024 * 1024; // 1MB

  final _progressController = StreamController<double>.broadcast();
  Stream<double> get progress => _progressController.stream;

  Future<void> sendFile(File file) async {
    final length = await file.length();
    final randomAccessFile = await file.open(mode: FileMode.read);
    
    int bytesSent = 0;
    while (bytesSent < length) {
      final chunk = await randomAccessFile.read(chunkSize);
      
      // In a real implementation, wrap chunk with PacketFormatter
      // and handle pause/resume logic
      
      // For architecture demo:
      // _socketManager.socket!.add(chunk);
      // await _socketManager.socket!.flush();
      
      bytesSent += chunk.length;
      _progressController.add(bytesSent / length);
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 50));
    }
    
    await randomAccessFile.close();
  }
}
