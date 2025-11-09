import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _dropletController;

  final List<Map<String, dynamic>> _activeOrders = [
    {
      'orderId': '#1235',
      'status': 'Washing',
      'statusColor': AppColors.primary,
      'items': '15 items',
      'progress': 0.6,
      'estimatedTime': '2 hours left',
      'amount': '₦3,500',
    },
    {
      'orderId': '#1234',
      'status': 'Drying',
      'statusColor': AppColors.warning,
      'items': '8 items',
      'progress': 0.8,
      'estimatedTime': '1 hour left',
      'amount': '₦2,100',
    },
    {
      'orderId': '#1233',
      'status': 'Ready',
      'statusColor': AppColors.success,
      'items': '12 items',
      'progress': 1.0,
      'estimatedTime': 'Ready for pickup',
      'amount': '₦2,800',
    },
  ];

  final List<Map<String, dynamic>> _pendingOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dropletController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                      'My Orders',
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
                      'Track all your laundry orders',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideY(begin: -0.2, end: 0),
                  ],
                ),
              ),

              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Active'),
                    Tab(text: 'Pending'),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 20),

              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildActiveOrdersList(),
                    _buildPendingOrdersList(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrdersList() {
    if (_activeOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No Active Orders',
        subtitle: 'Your active orders will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _activeOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(_activeOrders[index], index);
      },
    );
  }

  Widget _buildPendingOrdersList() {
    if (_pendingOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.schedule_rounded,
        title: 'No Pending Orders',
        subtitle: 'Orders awaiting confirmation will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _pendingOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(_pendingOrders[index], index);
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
            child: Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 24),
          Text(
            title,
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
            subtitle,
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

  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (order['statusColor'] as Color).withValues(alpha: 0.3),
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
                      color: (order['statusColor'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_laundry_service_rounded,
                      color: order['statusColor'] as Color,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (order['statusColor'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order['status'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: order['statusColor'] as Color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${((order['progress'] as double) * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: order['statusColor'] as Color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: order['progress'] as double,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    order['statusColor'] as Color,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order['estimatedTime'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    order['amount'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 100).ms)
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
