import '../entities/device_entity.dart';

abstract class DiscoveryRepository {
  Stream<List<DeviceEntity>> get nearbyDevices;
  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Future<void> startAdvertising(String deviceName);
  Future<void> stopAdvertising();
}
