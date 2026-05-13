import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/discovery_repository.dart';

class BleDiscoveryRepositoryImpl implements DiscoveryRepository {
  final _devicesController = StreamController<List<DeviceEntity>>.broadcast();
  final List<DeviceEntity> _discoveredDevices = [];
  final _p2p = FlutterP2pConnection();

  @override
  Stream<List<DeviceEntity>> get nearbyDevices => _devicesController.stream;

  @override
  Future<void> startDiscovery() async {
    await _p2p.initialize();
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
          _updateOrAddDevice(device);
        }
      }
    });

    // Start Wi-Fi Direct discovery to get MAC addresses
    await _p2p.discover();
    _p2p.streamPeers().listen((peers) {
      for (var peer in peers) {
        final device = DeviceEntity(
          id: peer.deviceAddress, // Use MAC address as ID for Wi-Fi Direct
          name: peer.deviceName,
        );
        _updateOrAddDevice(device);
      }
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      debugPrint('Error starting BLE scan: $e');
    }
  }

  void _updateOrAddDevice(DeviceEntity device) {
    // Check if we already have this device by name (to link BLE and WiFi Direct)
    final existingIndex = _discoveredDevices.indexWhere(
      (d) => d.name == device.name || d.id == device.id,
    );

    if (existingIndex != -1) {
      // Update existing device, prefer MAC address as ID if available
      final existing = _discoveredDevices[existingIndex];
      // If the new device has a MAC-like ID (contains colons), prefer it
      final newId = device.id.contains(':') ? device.id : existing.id;

      _discoveredDevices[existingIndex] = DeviceEntity(
        id: newId,
        name: device.name,
        isConnected: existing.isConnected,
      );
    } else {
      _discoveredDevices.add(device);
    }
    _devicesController.add(List.from(_discoveredDevices));
  }

  @override
  Future<void> stopDiscovery() async {
    await FlutterBluePlus.stopScan();
    await _p2p.stopDiscovery();
  }

  @override
  Future<void> startAdvertising(String deviceName) async {
    // Start P2P discovery mode so we are searchable via MAC address
    await _p2p.discover();

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
    await _p2p.stopDiscovery();
  }
}
