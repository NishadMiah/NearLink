import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DiscoveryScreen extends StatelessWidget {
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
            Icon(Icons.radar, size: 100.w, color: Theme.of(context).primaryColor),
            Gap(20.h),
            Text(
              'Scanning for devices...',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
