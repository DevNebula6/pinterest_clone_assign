import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import 'widgets/notification_card.dart';

class _NotificationData {
  const _NotificationData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.imageUrl,
    this.isRead = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String timeAgo;
  final String? imageUrl;
  final bool isRead;
}

const _mockNotifications = [
  _NotificationData(
    icon: Icons.favorite,
    iconColor: AppColors.pinterestRed,
    iconBg: Color(0xFFFFE5E5),
    title: 'Sarah',
    subtitle: 'saved your pin to Summer Vibes',
    timeAgo: '2 min ago',
    imageUrl: 'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?w=80',
  ),
  _NotificationData(
    icon: Icons.person_add,
    iconColor: Color(0xFF4CAF50),
    iconBg: Color(0xFFE8F5E9),
    title: 'Mark',
    subtitle: 'started following you',
    timeAgo: '15 min ago',
    isRead: true,
  ),
  _NotificationData(
    icon: Icons.dashboard_outlined,
    iconColor: Color(0xFF2196F3),
    iconBg: Color(0xFFE3F2FD),
    title: 'Alex',
    subtitle: 'created a board inspired by your pins',
    timeAgo: '1 hr ago',
    imageUrl: 'https://images.pexels.com/photos/3184418/pexels-photo-3184418.jpeg?w=80',
    isRead: true,
  ),
  _NotificationData(
    icon: Icons.comment_outlined,
    iconColor: Color(0xFFFF9800),
    iconBg: Color(0xFFFFF3E0),
    title: 'Emma',
    subtitle: 'commented on your pin: "Love this!"',
    timeAgo: '3 hr ago',
    isRead: true,
  ),
  _NotificationData(
    icon: Icons.trending_up,
    iconColor: Color(0xFF9C27B0),
    iconBg: Color(0xFFF3E5F5),
    title: 'Trending!',
    subtitle: 'Your pin "Mountain sunrise" is getting attention',
    timeAgo: '5 hr ago',
    imageUrl: 'https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?w=80',
    isRead: true,
  ),
  _NotificationData(
    icon: Icons.favorite,
    iconColor: AppColors.pinterestRed,
    iconBg: Color(0xFFFFE5E5),
    title: 'James',
    subtitle: 'saved your pin to Architecture',
    timeAgo: '1 day ago',
    isRead: true,
  ),
];

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.paddingLarge,
                topPad + AppDimensions.paddingSmall,
                AppDimensions.paddingLarge,
                AppDimensions.paddingMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notifications', style: AppTypography.h2),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Mark all read',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.pinterestRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.paddingLarge,
                0,
                AppDimensions.paddingLarge,
                AppDimensions.paddingSmall,
              ),
              child: Text('Recent', style: AppTypography.labelMedium),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final n = _mockNotifications[index];
                return NotificationCard(
                  icon: n.icon,
                  iconColor: n.iconColor,
                  iconBg: n.iconBg,
                  title: n.title,
                  subtitle: n.subtitle,
                  timeAgo: n.timeAgo,
                  imageUrl: n.imageUrl,
                  isRead: n.isRead,
                );
              },
              childCount: _mockNotifications.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

