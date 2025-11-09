import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/onboarding_local_data_source.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/entities/onboarding_page_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';

// Data Source Provider
final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>(
  (ref) => OnboardingLocalDataSource(),
);

// Repository Provider
final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(
    localDataSource: ref.watch(onboardingLocalDataSourceProvider),
  ),
);

// Onboarding Pages Provider
final onboardingPagesProvider = Provider<List<OnboardingPageEntity>>(
  (ref) {
    final repository = ref.watch(onboardingRepositoryProvider);
    return repository.getOnboardingPages();
  },
);

// Current Page Index Provider
final currentPageIndexProvider = StateProvider<int>((ref) => 0);

// Onboarding Completed Check Provider
final isOnboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  return await repository.isOnboardingCompleted();
});

// Complete Onboarding Provider
final completeOnboardingProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.setOnboardingCompleted();
  };
});
