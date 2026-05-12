import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import '../../domain/repositories/connection_repository.dart';
import '../../sockets/socket_manager.dart';

class WifiDirectConnectionRepositoryImpl implements ConnectionRepository {
  final _statusController = StreamController<bool>.broadcast();

  final _p2p = FlutterP2pConnection();
  final SocketManager _socketManager = Get.find<SocketManager>();

  WifiDirectConnectionRepositoryImpl() {
    _initP2p();
  }

  Future<void> _initP2p() async {
    await _p2p.initialize();
    
    _p2p.streamWifiP2PInfo().listen((info) {
      if (info.isConnected) {
        _statusController.add(true);
        if (info.isGroupOwner) {
          _socketManager.startServer('0.0.0.0', 4000);
        } else {
          _socketManager.connectToServer(info.groupOwnerAddress, 4000);
        }
      } else {
        _statusController.add(false);
        _socketManager.disconnect();
      }
    });
  }

  @override
  Stream<bool> get connectionStatus => _statusController.stream;

  @override
  Future<bool> connectToDevice(String deviceAddress) async {
    return await _p2p.connect(deviceAddress);
  }

  @override
  Future<void> disconnect() async {
    await _p2p.removeGroup();
    _socketManager.disconnect();
    _statusController.add(false);
  }
}
