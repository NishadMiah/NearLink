import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class VoiceMessageBubble extends StatelessWidget {
  final bool isMine;
  final int durationSeconds;

  const VoiceMessageBubble({super.key, required this.isMine, required this.durationSeconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isMine ? Colors.blueAccent : Colors.grey[300],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow, color: isMine ? Colors.white : Colors.black87),
          Gap(10.w),
          Container(
            height: 4.h,
            width: 100.w,
            color: isMine ? Colors.white54 : Colors.black26,
          ),
          Gap(10.w),
          Text(
            '00:${durationSeconds.toString().padLeft(2, '0')}',
            style: TextStyle(color: isMine ? Colors.white : Colors.black87),
          )
        ],
      ),
    );
  }
}
