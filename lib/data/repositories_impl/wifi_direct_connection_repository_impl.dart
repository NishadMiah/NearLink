import 'dart:async';
import '../../domain/repositories/connection_repository.dart';

class WifiDirectConnectionRepositoryImpl implements ConnectionRepository {
  final _statusController = StreamController<bool>.broadcast();

  @override
  Stream<bool> get connectionStatus => _statusController.stream;

  @override
  Future<bool> connectToDevice(String deviceId) async {
    // Mocking WiFi Direct P2P negotiation logic
    print("Negotiating WiFi Direct connection with $deviceId...");
    await Future.delayed(const Duration(seconds: 2));
    _statusController.add(true);
    return true;
  }

  @override
  Future<void> disconnect() async {
    print("Disconnecting WiFi Direct...");
    _statusController.add(false);
  }
}
