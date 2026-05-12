import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nearlink/presentation/features/chat/controllers/chat_controller.dart';
import 'package:nearlink/core/theme/app_theme.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('NearLink Chat'),
            Text(
              'Connected via WiFi Direct',
              style: TextStyle(fontSize: 12.sp, color: Colors.green, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline_rounded)),
          const Gap(8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final msg = controller.messages[index];
                return _buildMessageBubble(msg, index);
              },
            )),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic msg, int index) {
    final isMine = msg.isMine;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h, left: isMine ? 50.w : 0, right: isMine ? 0 : 50.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isMine 
              ? const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMine ? null : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMine ? 20 : 0),
            bottomRight: Radius.circular(isMine ? 0 : 20),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: isMine ? Colors.white : Colors.black87,
            fontSize: 15.sp,
          ),
        ),
      ).animate().fadeIn(delay: const Duration(milliseconds: 50)).slideX(begin: isMine ? 0.2 : -0.2, end: 0),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: MediaQuery.of(context).padding.bottom + 16.h,
        top: 16.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, color: AppTheme.primaryColor),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller.textController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Gap(12.w),
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: controller.sendMessage,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

