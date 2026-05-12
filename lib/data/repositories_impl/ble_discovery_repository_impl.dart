import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
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

    // Check if Bluetooth is turned on
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      debugPrint('Bluetooth is turned off. Cannot start scan.');
      return;
    }

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

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      debugPrint('Error starting BLE scan: $e');
    }
  }

  @override
  Future<void> stopDiscovery() async {
    await FlutterBluePlus.stopScan();
  }

  @override
  Future<void> startAdvertising(String deviceName) async {
    final advertiseData = AdvertiseData(
      serviceUuid:
          'bf27730d-860a-4e09-889c-2d8b6a9e0fe7', // Unique UUID for our app
      localName: deviceName,
    );

    final advertiseSettings = AdvertiseSettings(
      advertiseMode: AdvertiseMode.advertiseModeBalanced,
      txPowerLevel: AdvertiseTxPower.advertiseTxPowerMedium,
      connectable: true,
    );

    await FlutterBlePeripheral().start(
      advertiseData: advertiseData,
      advertiseSettings: advertiseSettings,
    );
  }

  @override
  Future<void> stopAdvertising() async {
    await FlutterBlePeripheral().stop();
  }
}
