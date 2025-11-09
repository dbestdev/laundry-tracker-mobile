import '../entities/onboarding_page_entity.dart';

abstract class OnboardingRepository {
  List<OnboardingPageEntity> getOnboardingPages();
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted();
}
