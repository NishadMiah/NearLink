import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/discovery_controller.dart';

class DiscoveryScreen extends GetView<DiscoveryController> {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Devices'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Icon(
                  Icons.radar,
                  size: controller.isScanning.value ? 120.w : 100.w,
                  color: controller.isScanning.value 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey,
                )),
            Gap(20.h),
            Obx(() => Text(
                  controller.isScanning.value 
                      ? 'Scanning for devices...' 
                      : 'Tap to scan for nearby devices',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                )),
            Gap(30.h),
            ElevatedButton(
              onPressed: () => controller.scanForDevices(),
              child: const Text('Scan Now'),
            ),
            Gap(20.h),
            Expanded(
              child: Obx(() {
                if (controller.devices.isEmpty) {
                  return const Center(child: Text('No devices found yet.'));
                }
                return ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];
                    return ListTile(
                      leading: const Icon(Icons.smartphone),
                      title: Text(device.name),
                      subtitle: Text(device.id),
                      trailing: ElevatedButton(
                        onPressed: () {
                          controller.connectToDevice(device.id);
                        },
                        child: const Text('Connect'),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
