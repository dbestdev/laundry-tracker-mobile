import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import 'orders_tab.dart';
import 'history_tab.dart';
import 'profile_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _dropletController;

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

  Widget _getSelectedTab() {
    switch (_selectedIndex) {
      case 0:
        final currentUserAsync = ref.watch(currentUserProvider);
        return currentUserAsync.when(
          data: (user) => _buildHomeContent(user?.fullName ?? 'Guest'),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildHomeContent('Guest'),
        );
      case 1:
        return const OrdersTab();
      case 2:
        return const HistoryTab();
      case 3:
        return const ProfileTab();
      default:
        final currentUserAsync = ref.watch(currentUserProvider);
        return currentUserAsync.when(
          data: (user) => _buildHomeContent(user?.fullName ?? 'Guest'),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildHomeContent('Guest'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedTab(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 6,
              child: const Icon(Icons.add_rounded, size: 28),
            )
              .animate()
              .fadeIn(duration: 600.ms, delay: 800.ms)
              .scale(begin: const Offset(0.8, 0.8))
              .shimmer(duration: 2000.ms, delay: 1000.ms)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_laundry_service_outlined),
              selectedIcon: Icon(Icons.local_laundry_service_rounded),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildHomeContent(String userName) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD), // Light blue
            Color(0xFFFFFFFF), // White
            Color(0xFFF5F9FF), // Very light blue
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Water droplets in background
            ..._buildWaterDroplets(size),

            // Main content with fixed header and stats
            Column(
              children: [
                // Fixed Header
                _buildHeader(userName),

                // Fixed Quick Stats
                _buildQuickStats(),

                const SizedBox(height: 16),

                // Scrollable content underneath
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Active Orders Section
                        _buildSectionHeader('Active Orders', 'View All'),
                        _buildActiveOrdersSection(),

                        // Quick Actions
                        _buildSectionHeader('Quick Actions', ''),
                        _buildQuickActions(),

                        // Spacing for FAB
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $userName! 👋',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.2, end: 0),
                    const SizedBox(height: 4),
                    Text(
                      'Fresh laundry, tracked perfectly',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideX(begin: -0.2, end: 0),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.push(AppRoutes.notifications);
                    },
                    icon: const Icon(Icons.notifications_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.primary,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedIndex = 3);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Total Spent - Large Card on Top
          _buildTotalSpentCard(),

          const SizedBox(height: 16),

          // Active, Pending, and Completed - Row Below
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.water_drop_rounded,
                  label: 'Active',
                  value: '3',
                  color: AppColors.primary,
                  delay: 500,
                  isCurrency: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.schedule_rounded,
                  label: 'Pending',
                  value: '0',
                  color: AppColors.warning,
                  delay: 550,
                  isCurrency: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Completed',
                  value: '2',
                  color: AppColors.success,
                  delay: 600,
                  isCurrency: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSpentCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Spent',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₦0.00',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'All time laundry expenses',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(begin: 0.2, end: 0)
        .shimmer(duration: 2000.ms, delay: 800.ms);
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required int delay,
    required bool isCurrency,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isCurrency ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (action.isNotEmpty)
            TextButton(
              onPressed: () {
                context.push(AppRoutes.viewAllOrders);
              },
              child: Text(action),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 700.ms)
        .slideX(begin: -0.2, end: 0);
  }

  Widget _buildActiveOrdersSection() {
    // Sample active orders data
    final List<Map<String, dynamic>> activeOrders = [
      {
        'orderId': '#1235',
        'status': 'Washing',
        'statusColor': AppColors.primary,
        'items': '15 items',
        'progress': 0.6,
        'estimatedTime': '2 hours left',
      },
      {
        'orderId': '#1234',
        'status': 'Drying',
        'statusColor': AppColors.warning,
        'items': '8 items',
        'progress': 0.8,
        'estimatedTime': '1 hour left',
      },
      {
        'orderId': '#1233',
        'status': 'Ready',
        'statusColor': AppColors.success,
        'items': '12 items',
        'progress': 1.0,
        'estimatedTime': 'Ready for pickup',
      },
    ];

    if (activeOrders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Active Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start tracking your laundry by creating a new order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 800.ms)
            .scale(begin: const Offset(0.95, 0.95)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: activeOrders.asMap().entries.map((entry) {
          final index = entry.key;
          final order = entry.value;
          return _buildActiveOrderCard(order, index);
        }).toList(),
      ),
    );
  }

  Widget _buildActiveOrderCard(Map<String, dynamic> order, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (order['statusColor'] as Color)
                          .withValues(alpha: 0.1),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (order['statusColor'] as Color)
                      .withValues(alpha: 0.1),
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
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: const TextStyle(
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
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
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (800 + index * 100).ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.add_circle_outline_rounded,
        'title': 'New Order',
        'subtitle': 'Create laundry order',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.qr_code_scanner_rounded,
        'title': 'Scan QR',
        'subtitle': 'Track with QR code',
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.receipt_long_outlined,
        'title': 'View Bills',
        'subtitle': 'Check invoices',
        'color': AppColors.warning,
      },
      {
        'icon': Icons.support_agent_rounded,
        'title': 'Support',
        'subtitle': 'Get help',
        'color': AppColors.success,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return _buildQuickActionCard(
            icon: action['icon'] as IconData,
            title: action['title'] as String,
            subtitle: action['subtitle'] as String,
            color: action['color'] as Color,
            delay: 900 + (index * 100),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay.ms)
        .scale(begin: const Offset(0.9, 0.9));
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
