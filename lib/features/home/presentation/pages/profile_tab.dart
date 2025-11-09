import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUserAsync = ref.watch(currentUserProvider);

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
          SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                  child: currentUserAsync.when(
                    data: (user) => _buildProfileHeader(
                      name: user?.fullName ?? 'Guest User',
                      email: user?.email ?? 'guest@example.com',
                    ),
                    loading: () => _buildProfileHeader(
                      name: 'Loading...',
                      email: '',
                    ),
                    error: (_, __) => _buildProfileHeader(
                      name: 'Guest User',
                      email: 'guest@example.com',
                    ),
                  ),
                ),

                // Profile Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSectionTitle('Account Settings'),
                      const SizedBox(height: 12),
                      _buildOptionCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: 'Update your personal information',
                        onTap: () {},
                        delay: 300,
                      ),
                      _buildOptionCard(
                        icon: Icons.location_on_outlined,
                        title: 'Addresses',
                        subtitle: 'Manage your delivery addresses',
                        onTap: () {},
                        delay: 350,
                      ),
                      _buildOptionCard(
                        icon: Icons.payment_rounded,
                        title: 'Payment Methods',
                        subtitle: 'Manage your payment options',
                        onTap: () {},
                        delay: 400,
                      ),

                      const SizedBox(height: 24),
                      _buildSectionTitle('Preferences'),
                      const SizedBox(height: 12),
                      _buildOptionCard(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage notification preferences',
                        onTap: () {},
                        delay: 450,
                      ),
                      _buildOptionCard(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: 'English',
                        onTap: () {},
                        delay: 500,
                      ),
                      _buildOptionCard(
                        icon: Icons.dark_mode_outlined,
                        title: 'Theme',
                        subtitle: 'Light mode',
                        onTap: () {},
                        delay: 550,
                      ),

                      const SizedBox(height: 24),
                      _buildSectionTitle('Support'),
                      const SizedBox(height: 12),
                      _buildOptionCard(
                        icon: Icons.help_outline_rounded,
                        title: 'Help Center',
                        subtitle: 'Get help and support',
                        onTap: () {},
                        delay: 600,
                      ),
                      _buildOptionCard(
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                        subtitle: 'App version 1.0.0',
                        onTap: () {},
                        delay: 650,
                      ),
                      _buildOptionCard(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        onTap: () {},
                        delay: 700,
                      ),

                      const SizedBox(height: 24),
                      _buildLogoutButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader({required String name, required String email}) {
    return Column(
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
            Icons.person_rounded,
            size: 50,
            color: Colors.white,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 4),
        Text(
          email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 250.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required int delay,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
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
          onTap: () {
            _showLogoutDialog();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 750.ms)
        .slideY(begin: 0.2, end: 0);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateNotifierProvider.notifier).signOut().then((_) {
                if (mounted) {
                  context.go(AppRoutes.welcome);
                }
              });
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
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
