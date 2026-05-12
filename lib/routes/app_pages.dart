import 'package:get/get.dart';
import 'app_routes.dart';
import '../presentation/features/discovery/screens/discovery_screen.dart';

class AppPages {
  static const initial = Routes.discovery;

  static final routes = [
    GetPage(
      name: Routes.discovery,
      page: () => const DiscoveryScreen(),
    ),
  ];
}
