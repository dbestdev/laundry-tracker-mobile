import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/router/app_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.accent,
              AppColors.primaryLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated bubbles in the background
              ..._buildFloatingBubbles(size),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // App Logo with animation
                    _buildLogo(),

                    const SizedBox(height: 32),

                    // App Name
                    Text(
                      AppConstants.appName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 12),

                    // Tagline
                    Text(
                      AppConstants.appTagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.5,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 500.ms)
                        .slideY(begin: 0.3, end: 0),

                    const Spacer(flex: 3),

                    // Sign Up Button
                    CustomButton(
                      text: 'Create Account',
                      onPressed: () => context.push(AppRoutes.signUp),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 700.ms)
                        .slideY(begin: 0.3, end: 0)
                        .then()
                        .shimmer(
                          duration: 2000.ms,
                          delay: 1000.ms,
                          color: AppColors.primaryLight.withValues(alpha: 0.3),
                        ),

                    const SizedBox(height: 16),

                    // Sign In Button
                    CustomButton(
                      text: 'Sign In',
                      onPressed: () => context.push(AppRoutes.signIn),
                      isOutlined: true,
                      foregroundColor: Colors.white,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 900.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 32),

                    // Skip for now
                    TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1100.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_laundry_service_rounded,
        size: 60,
        color: AppColors.primary,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
        .then(delay: 2000.ms)
        .shimmer(duration: 2000.ms, color: AppColors.accent.withValues(alpha: 0.5));
  }

  List<Widget> _buildFloatingBubbles(Size size) {
    return List.generate(15, (index) {
      final random = (index * 37) % 100;
      final left = (random / 100) * size.width;
      final top = ((index * 53) % 100 / 100) * size.height;
      final bubbleSize = 20.0 + (random % 60);
      final duration = 3000 + (index * 200);

      return Positioned(
        left: left,
        top: top,
        child: Container(
          width: bubbleSize,
          height: bubbleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .moveY(
              begin: 0,
              end: -50 - (random % 100),
              duration: duration.ms,
              curve: Curves.easeInOut,
            )
            .fadeIn(duration: 1000.ms)
            .then()
            .fadeOut(duration: 1000.ms),
      );
    });
  }
}
