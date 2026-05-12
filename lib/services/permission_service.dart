import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  Future<bool> requestOfflineNetworkingPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.nearbyWifiDevices,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
        print('Permission denied: $permission');
      }
    });

    return allGranted;
  }
}
