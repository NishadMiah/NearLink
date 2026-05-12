import 'package:get/get.dart';
import 'app_routes.dart';
import '../presentation/features/discovery/screens/discovery_screen.dart';
import '../presentation/features/chat/screens/chat_screen.dart';
import '../presentation/features/chat/controllers/chat_controller.dart';
import '../presentation/features/transfer/screens/transfer_screen.dart';
import '../presentation/features/transfer/controllers/transfer_controller.dart';

class AppPages {
  static const initial = Routes.discovery;

  static final routes = [
    GetPage(
      name: Routes.discovery,
      page: () => const DiscoveryScreen(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ChatController());
      }),
    ),
    GetPage(
      name: Routes.transfer,
      page: () => const TransferScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TransferController());
      }),
    ),
  ];
}
