import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  static const String messagesBox = 'messagesBox';

  static Future<void> init() async {
    // In a full implementation, you register adapters here after build_runner generates them
    // Hive.registerAdapter(MessageModelAdapter());
    await Hive.openBox<dynamic>(messagesBox);
  }

  static Box getMessagesBox() {
    return Hive.box<dynamic>(messagesBox);
  }
}
