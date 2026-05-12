import 'package:get/get.dart';
import '../services/permission_service.dart';
import '../domain/repositories/discovery_repository.dart';
import '../domain/repositories/connection_repository.dart';
import '../data/repositories_impl/ble_discovery_repository_impl.dart';
import '../data/repositories_impl/wifi_direct_connection_repository_impl.dart';
import '../presentation/features/discovery/controllers/discovery_controller.dart';
import '../sockets/socket_manager.dart';
import '../transfer_engine/transfer_engine.dart';
import '../encryption/encryption_service.dart';
import '../encryption/key_exchange_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<PermissionService>(PermissionService(), permanent: true);
    Get.put<SocketManager>(SocketManager(), permanent: true);
    Get.put<TransferEngine>(TransferEngine(), permanent: true);
    Get.put<EncryptionService>(EncryptionService(), permanent: true);
    Get.put<KeyExchangeService>(KeyExchangeService(), permanent: true);

    // Repositories
    Get.lazyPut<DiscoveryRepository>(() => BleDiscoveryRepositoryImpl(), fenix: true);
    Get.lazyPut<ConnectionRepository>(() => WifiDirectConnectionRepositoryImpl(), fenix: true);

    // Controllers
    Get.lazyPut(() => DiscoveryController(discoveryRepository: Get.find<DiscoveryRepository>()));
  }
}
