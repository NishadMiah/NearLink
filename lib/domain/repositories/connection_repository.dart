abstract class ConnectionRepository {
  Future<bool> connectToDevice(String deviceId);
  Future<void> disconnect();
  Stream<bool> get connectionStatus;
}
