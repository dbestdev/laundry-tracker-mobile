import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Order Ready for Pickup',
      'message': 'Your laundry order #1234 is ready for pickup',
      'time': '5 min ago',
      'icon': Icons.check_circle_rounded,
      'color': AppColors.success,
      'isRead': false,
    },
    {
      'title': 'Order in Progress',
      'message': 'Your order #1233 is currently being processed',
      'time': '1 hour ago',
      'icon': Icons.autorenew_rounded,
      'color': AppColors.primary,
      'isRead': false,
    },
    {
      'title': 'Payment Received',
      'message': 'Payment of \$45.00 received successfully',
      'time': '2 hours ago',
      'icon': Icons.payment_rounded,
      'color': AppColors.success,
      'isRead': true,
    },
    {
      'title': 'New Promotion',
      'message': 'Get 20% off on your next order this weekend!',
      'time': '1 day ago',
      'icon': Icons.local_offer_rounded,
      'color': AppColors.warning,
      'isRead': true,
    },
    {
      'title': 'Order Delivered',
      'message': 'Your order #1232 has been delivered',
      'time': '2 days ago',
      'icon': Icons.local_shipping_rounded,
      'color': AppColors.info,
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification['isRead'] = true;
                  }
                });
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryLight.withValues(alpha: 0.1),
              AppColors.background,
              AppColors.accentLight.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: _notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return _buildNotificationCard(
                      notification: notification,
                      index: index,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 60,
              color: Colors.white,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 32),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required Map<String, dynamic> notification,
    required int index,
  }) {
    final isRead = notification['isRead'] as bool;

    return Dismissible(
      key: Key('notification_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isRead
              ? AppColors.surface
              : AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? AppColors.border
                : AppColors.primary.withValues(alpha: 0.2),
            width: isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                notification['isRead'] = true;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (notification['color'] as Color)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notification['icon'] as IconData,
                      color: notification['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification['message'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              notification['time'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: (index * 50).ms)
          .slideX(begin: 0.2, end: 0),
    );
  }
}
