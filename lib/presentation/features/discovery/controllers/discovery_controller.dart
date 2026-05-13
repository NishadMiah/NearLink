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
  var deviceName = "Unknown Device".obs;
  var deviceId = "Unknown ID".obs;

  DiscoveryController({required this.discoveryRepository});

  @override
  void onInit() {
    super.onInit();
    _loadDeviceName();
    discoveryRepository.nearbyDevices.listen((deviceList) {
      devices.value = deviceList;
    });
  }

  Future<void> _loadDeviceName() async {
    // In a real app, we would fetch the actual device name
    deviceName.value = "My NearLink Device";
    
    // Generate a unique random ID for this device session
    final random = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    deviceId.value = "NL-$random-${_generateShortHash()}";

    // START ADVERTISING: This makes your Name + ID visible to others scanning
    // We combine name and ID so it's easy for Device B to identify you in their list
    await discoveryRepository.startAdvertising("${deviceName.value} (${deviceId.value})");
  }

  String _generateShortHash() {
    const chars = 'ABCDEF0123456789';
    final rnd = DateTime.now().microsecondsSinceEpoch;
    return List.generate(4, (i) => chars[(rnd + i) % chars.length]).join();
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

  void handleQrScan(String? code) {
    if (code == null || !code.startsWith('NEARLINK:')) {
      Get.snackbar('Invalid QR', 'This is not a valid NearLink connection code.');
      return;
    }

    // Extract device ID from QR code (Format: NEARLINK:DEVICE_ID)
    final scannedId = code.replaceFirst('NEARLINK:', '');
    Get.snackbar('QR Identified', 'Connecting to $scannedId...');
    connectToDevice(scannedId);
  }
}
