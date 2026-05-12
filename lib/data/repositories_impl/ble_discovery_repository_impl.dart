import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/discovery_repository.dart';

class BleDiscoveryRepositoryImpl implements DiscoveryRepository {
  final _devicesController = StreamController<List<DeviceEntity>>.broadcast();
  final List<DeviceEntity> _discoveredDevices = [];

  @override
  Stream<List<DeviceEntity>> get nearbyDevices => _devicesController.stream;

  @override
  Future<void> startDiscovery() async {
    _discoveredDevices.clear();
    _devicesController.add(_discoveredDevices);
    
    // Start scanning
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.advName.isNotEmpty) {
          final device = DeviceEntity(
            id: r.device.remoteId.toString(),
            name: r.device.advName,
          );
          if (!_discoveredDevices.any((d) => d.id == device.id)) {
            _discoveredDevices.add(device);
            _devicesController.add(List.from(_discoveredDevices));
          }
        }
      }
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
  }

  @override
  Future<void> stopDiscovery() async {
    await FlutterBluePlus.stopScan();
  }

  @override
  Future<void> startAdvertising(String deviceName) async {
    // Note: flutter_blue_plus does not support BLE advertising directly.
    // For production, flutter_ble_peripheral would be used here.
    print("Started advertising as $deviceName");
  }

  @override
  Future<void> stopAdvertising() async {
    print("Stopped advertising");
  }
}
