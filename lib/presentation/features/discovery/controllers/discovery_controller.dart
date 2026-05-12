import 'package:get/get.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../domain/repositories/discovery_repository.dart';
import '../../../../domain/repositories/connection_repository.dart';
import '../../../../services/permission_service.dart';

class DiscoveryController extends GetxController {
  final DiscoveryRepository discoveryRepository;
  final ConnectionRepository connectionRepository = Get.find<ConnectionRepository>();
  final PermissionService permissionService = Get.find<PermissionService>();

  var devices = <DeviceEntity>[].obs;
  var isScanning = false.obs;

  DiscoveryController({required this.discoveryRepository});

  @override
  void onInit() {
    super.onInit();
    discoveryRepository.nearbyDevices.listen((deviceList) {
      devices.value = deviceList;
    });
  }

  Future<void> scanForDevices() async {
    bool hasPermissions = await permissionService.requestOfflineNetworkingPermissions();
    if (!hasPermissions) {
      Get.snackbar('Permissions Denied', 'Please grant networking permissions to discover devices.');
      return;
    }

    isScanning.value = true;
    await discoveryRepository.startDiscovery();
    
    // Auto stop scanning after 15 seconds
    Future.delayed(const Duration(seconds: 15), () {
      isScanning.value = false;
      discoveryRepository.stopDiscovery();
    });
  }

  Future<void> connectToDevice(String deviceId) async {
    Get.snackbar('Connecting', 'Negotiating P2P connection...');
    final success = await connectionRepository.connectToDevice(deviceId);
    if (success) {
      Get.snackbar('Connected', 'Successfully connected via WiFi Direct');
    } else {
      Get.snackbar('Failed', 'Could not establish connection');
    }
  }
}
