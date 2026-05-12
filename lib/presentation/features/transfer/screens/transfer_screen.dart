import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../controllers/transfer_controller.dart';

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
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_copy, size: 80.w, color: Theme.of(context).primaryColor),
              Gap(20.h),
              Text(
                'Sending video.mp4',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Gap(30.h),
              Obx(() => LinearProgressIndicator(
                    value: controller.transferProgress.value,
                    minHeight: 10.h,
                    backgroundColor: Colors.grey[300],
                    color: Theme.of(context).primaryColor,
                  )),
              Gap(10.h),
              Obx(() => Text(
                    '${(controller.transferProgress.value * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 16.sp),
                  )),
              Gap(40.h),
              ElevatedButton(
                onPressed: controller.startMockTransfer,
                child: const Text('Start Demo Transfer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
