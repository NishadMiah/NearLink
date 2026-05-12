import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nearlink/presentation/features/transfer/controllers/transfer_controller.dart';
import 'package:nearlink/core/theme/app_theme.dart';

class TransferScreen extends GetView<TransferController> {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Transfer'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressIndicator(context),
              Gap(48.h),
              _buildFileInfoCard(context),
              Gap(48.h),
              ElevatedButton.icon(
                onPressed: controller.startMockTransfer,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Demo Transfer'),
              ).animate().fadeIn(delay: const Duration(milliseconds: 400)).scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Obx(() {
      final progress = controller.transferProgress.value;
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200.w,
            height: 200.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              color: AppTheme.primaryColor,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                'Completed',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ).animate(target: progress > 0 ? 1 : 0).shimmer(duration: const Duration(seconds: 2));
    });
  }

  Widget _buildFileInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.video_collection_rounded, color: Colors.orange),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'video.mp4',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '12.5 MB • MP4 Video',
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Colors.green),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideY(begin: 0.2, end: 0);
  }
}



