import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_providers.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isFromSignUp;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.isFromSignUp = false,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isLoading = false;
  int _remainingSeconds = AppConstants.otpResendDelay;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = AppConstants.otpResendDelay);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  void _handleVerifyOtp() async {
    if (_otpController.text.length != AppConstants.otpLength) {
      _showSnackBar('Please enter the complete OTP', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    await ref.read(authStateNotifierProvider.notifier).verifyOtp(
          email: widget.email,
          otp: _otpController.text,
        );

    setState(() => _isLoading = false);

    final authState = ref.read(authStateNotifierProvider);

    if (authState is AuthAuthenticated) {
      if (mounted) {
        if (widget.isFromSignUp) {
          // From sign-up flow: show success and go to home
          _showSuccessDialog();
        } else {
          // From forgot password flow: go to reset password screen
          context.push(
            '${AppRoutes.resetPassword}?email=${widget.email}&otp=${_otpController.text}',
          );
        }
      }
    } else if (authState is AuthError) {
      _showSnackBar(authState.message, isError: true);
      _otpController.clear();
    }
  }

  void _handleResendOtp() async {
    if (_remainingSeconds > 0) return;

    await ref.read(authStateNotifierProvider.notifier).resendOtp(
          email: widget.email,
        );

    final authState = ref.read(authStateNotifierProvider);

    if (authState is AuthOtpSent) {
      _showSnackBar(authState.message);
      _startTimer();
    } else if (authState is AuthError) {
      _showSnackBar(authState.message, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error : null,
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
              'Verification Successful!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your email has been verified successfully',
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
                  context.go(AppRoutes.home);
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
    );

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
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Illustration
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
                  Icons.mark_email_read_outlined,
                  size: 60,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8))
                  .then()
                  .shimmer(duration: 2000.ms, delay: 500.ms),

              const SizedBox(height: 32),

              // Title
              Text(
                'Verify Your Email',
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

              // Description
              Text(
                'We\'ve sent a verification code to',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 4),

              Text(
                widget.email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 400.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 40),

              // PIN Input
              Pinput(
                controller: _otpController,
                focusNode: _focusNode,
                length: AppConstants.otpLength,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                autofocus: true,
                showCursor: true,
                onCompleted: (_) => _handleVerifyOtp(),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 40),

              // Verify Button
              GradientButton(
                text: 'Verify OTP',
                onPressed: _isLoading ? null : _handleVerifyOtp,
                isLoading: _isLoading,
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 700.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive the code? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (_remainingSeconds > 0)
                    Text(
                      'Resend in $_remainingSeconds s',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    )
                  else
                    TextButton(
                      onPressed: _handleResendOtp,
                      child: const Text('Resend'),
                    ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 800.ms),

              const SizedBox(height: 16),

              // Change Email
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Change Email'),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 900.ms),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
