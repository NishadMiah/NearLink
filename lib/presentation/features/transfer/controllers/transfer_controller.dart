import 'dart:io';
import 'package:get/get.dart';
import '../../../../transfer_engine/transfer_engine.dart';

class TransferController extends GetxController {
  final TransferEngine transferEngine = Get.find<TransferEngine>();
  
  var transferProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    transferEngine.progress.listen((progress) {
      transferProgress.value = progress;
    });
  }

  Future<void> startMockTransfer() async {
    // Mocking file transfer for architecture demonstration
    for (int i = 0; i <= 100; i++) {
      transferProgress.value = i / 100.0;
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
