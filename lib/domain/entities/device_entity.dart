class DeviceEntity {
  final String id;
  final String name;
  final bool isConnected;

  DeviceEntity({required this.id, required this.name, this.isConnected = false});
}
