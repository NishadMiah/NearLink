import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  bool _isRequesting = false;

  Future<bool> requestOfflineNetworkingPermissions() async {
    if (_isRequesting) return false;
    _isRequesting = true;

    try {
      // Request granular permissions for Android 12+ (API 31+)
      // and legacy ones for older devices.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        // Permission.bluetooth is often problematic on Android 12+, 
        // granular ones below are preferred.
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.nearbyWifiDevices,
        Permission.storage,
        Permission.manageExternalStorage,
        // For Android 13+ (API 33+), storage permission is split
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ].request();

      bool allGranted = true;
      statuses.forEach((permission, status) {
        // Permission.storage can be denied on Android 13+ even if the app works fine 
        // because it's replaced by granular ones. We'll be flexible here.
        if (!status.isGranted && 
            permission != Permission.bluetooth && 
            permission != Permission.storage) {
          allGranted = false;
          debugPrint('Permission denied: $permission');
        }
      });

      return allGranted;
    } finally {
      _isRequesting = false;
    }
  }
}
