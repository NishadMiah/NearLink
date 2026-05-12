import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animate_do/animate_do.dart';
import 'package:nearlink/presentation/features/discovery/controllers/discovery_controller.dart';
import 'package:nearlink/core/theme/app_theme.dart';

class DiscoveryScreen extends GetView<DiscoveryController> {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Connect Nearby'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner_rounded),
              ),
              const Gap(8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMyDeviceCard(context),
                  Gap(32.h),
                  _buildScanHeader(context),
                  Gap(16.h),
                ],
              ),
            ),
          ),
          Obx(() {
            if (controller.devices.isEmpty && !controller.isScanning.value) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(context),
              );
            }
            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final device = controller.devices[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * index),
                      child: _buildDeviceCard(context, device),
                    );
                  },
                  childCount: controller.devices.length,
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            onPressed: controller.isScanning.value ? null : () => controller.scanForDevices(),
            backgroundColor: controller.isScanning.value ? Colors.grey : AppTheme.primaryColor,
            label: Text(controller.isScanning.value ? 'Scanning...' : 'Scan Devices'),
            icon: controller.isScanning.value 
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.search_rounded),
          )),
    );
  }

  Widget _buildMyDeviceCard(BuildContext context) {
    return FadeInDown(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phonelink_rounded, color: Colors.white, size: 32),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Device',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14.sp),
                  ),
                  Obx(() => Text(
                        controller.deviceName.value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Visible',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Nearby Devices',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        Obx(() {
          if (!controller.isScanning.value) return const SizedBox.shrink();
          return const Text(
            'Scanning...',
            style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
          ).animate(onPlay: (c) => c.repeat()).fade(duration: const Duration(milliseconds: 800)).then().fade(begin: 1, end: 0.3);
        }),
      ],
    );
  }

  Widget _buildDeviceCard(BuildContext context, dynamic device) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.smartphone_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          device.id,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
        trailing: TextButton(
          onPressed: () => controller.connectToDevice(device.id),
          style: TextButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Connect', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.radar_rounded,
            size: 80.w,
            color: Colors.grey.withValues(alpha: 0.3),
          ).animate(onPlay: (c) => c.repeat()).scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
              ).then().scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1)),
          Gap(24.h),
          Text(
            'No devices found',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          Gap(8.h),
          const Text(
            'Make sure the other device is scanning too!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}


