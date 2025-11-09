import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> with TickerProviderStateMixin {
  late AnimationController _dropletController;

  final List<Map<String, dynamic>> _completedOrders = [
    {
      'orderId': '#1232',
      'items': '12 items',
      'amount': '₦2,800',
      'date': 'Jan 15, 2025',
      'completedDate': '2 days ago',
      'rating': 5,
    },
    {
      'orderId': '#1231',
      'items': '8 items',
      'amount': '₦2,100',
      'date': 'Jan 10, 2025',
      'completedDate': '1 week ago',
      'rating': 4,
    },
    {
      'orderId': '#1230',
      'items': '15 items',
      'amount': '₦3,500',
      'date': 'Jan 5, 2025',
      'completedDate': '2 weeks ago',
      'rating': 5,
    },
    {
      'orderId': '#1229',
      'items': '10 items',
      'amount': '₦2,500',
      'date': 'Dec 28, 2024',
      'completedDate': '3 weeks ago',
      'rating': 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _dropletController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _dropletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFFFFFFF),
            Color(0xFFF5F9FF),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Water droplets
          ..._buildWaterDroplets(size),

          // Main content
          Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Column(
                  children: [
                    Text(
                      'Order History',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'View all your completed orders',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 16),
                    // Stats summary
                    _buildStatsSummary(),
                  ],
                ),
              ),

              // Orders list
              Expanded(
                child: _completedOrders.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _completedOrders.length,
                        itemBuilder: (context, index) {
                          return _buildHistoryCard(_completedOrders[index], index);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.check_circle_rounded,
            label: 'Completed',
            value: '${_completedOrders.length}',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            icon: Icons.star_rounded,
            label: 'Avg Rating',
            value: '4.8',
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Total Spent',
            value: '₦11K',
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0)
        .shimmer(duration: 2000.ms, delay: 800.ms);
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
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
              Icons.history_rounded,
              size: 50,
              color: Colors.white,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 24),
          Text(
            'No History Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'Your completed orders will appear here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildHistoryCard(Map<String, dynamic> order, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${order['orderId']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order['items'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order['amount'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order['completedDate'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    order['date'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (starIndex) => Icon(
                    starIndex < (order['rating'] as int)
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (300 + index * 100).ms)
        .slideX(begin: 0.2, end: 0);
  }

  List<Widget> _buildWaterDroplets(Size size) {
    return List.generate(18, (index) {
      final random = (index * 37) % 100;
      final left = (random / 100) * size.width;
      final top = ((index * 53) % 100 / 100) * size.height;
      final dropletSize = 15.0 + (random % 40);
      final duration = 3000 + (index * 250);

      return Positioned(
        left: left,
        top: top,
        child: Container(
          width: dropletSize,
          height: dropletSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.08),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .moveY(
              begin: 0,
              end: -40 - (random % 80),
              duration: duration.ms,
              curve: Curves.easeInOut,
            )
            .fade(
              begin: 0.6,
              end: 0.2,
            )
            .scale(
              begin: const Offset(1.0, 1.0),
              end: Offset(0.7 + (random % 30) / 100, 0.7 + (random % 30) / 100),
            ),
      );
    });
  }
}
