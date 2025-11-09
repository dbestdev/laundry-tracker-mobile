import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/password_strength_indicator.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    await ref.read(authStateNotifierProvider.notifier).resetPassword(
          email: widget.email,
          otp: _otpController.text,
          newPassword: _newPasswordController.text,
        );

    setState(() => _isLoading = false);

    final authState = ref.read(authStateNotifierProvider);

    if (authState is AuthPasswordResetSuccess) {
      if (mounted) {
        _showSuccessDialog();
      }
    } else if (authState is AuthError) {
      _showSnackBar(authState.message);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 50,
              ),
            )
                .animate()
                .scale(
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(),
            const SizedBox(height: 24),
            Text(
              'Password Reset Successful!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your password has been reset successfully. You can now sign in with your new password.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.signIn);
                },
                child: const Text('Go to Sign In'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Illustration
                Center(
                  child: Container(
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
                      Icons.lock_open,
                      size: 60,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ),

                const SizedBox(height: 32),

                // Header
                Text(
                  'Create New Password',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 12),

                Text(
                  'Your new password must be different from previously used passwords.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 40),

                // OTP Field
                AnimatedTextField(
                  label: 'Verification Code',
                  hint: 'Enter 6-digit code',
                  controller: _otpController,
                  prefixIcon: Icons.pin_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter verification code';
                    }
                    if (value.length != 6) {
                      return 'Code must be 6 digits';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 400.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                // New Password Field
                AnimatedTextField(
                  label: 'New Password',
                  hint: 'Enter new password',
                  controller: _newPasswordController,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setState(() {}),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 500.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 12),

                // Password Strength Indicator
                PasswordStrengthIndicator(
                  password: _newPasswordController.text,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 600.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                // Confirm Password Field
                AnimatedTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter new password',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: (value) =>
                      Validators.confirmPassword(value, _newPasswordController.text),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleResetPassword(),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 700.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Reset Password Button
                GradientButton(
                  text: 'Reset Password',
                  onPressed: _isLoading ? null : _handleResetPassword,
                  isLoading: _isLoading,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 800.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
