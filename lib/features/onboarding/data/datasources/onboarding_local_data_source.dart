import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingLocalDataSource {
  List<OnboardingPageEntity> getOnboardingPages() {
    return const [
      OnboardingPageEntity(
        title: 'Track Your Laundry',
        description:
            'Keep a detailed record of every item you send to the laundry. Never lose track of your clothes again.',
        imagePath: 'assets/images/onboarding1.png',
      ),
      OnboardingPageEntity(
        title: 'Accurate Billing',
        description:
            'Get precise billing calculations for every order. Know exactly what you\'re paying for.',
        imagePath: 'assets/images/onboarding2.png',
      ),
      OnboardingPageEntity(
        title: 'Delivery Tracking',
        description:
            'Track when your clothes will be ready and receive notifications for delays or updates.',
        imagePath: 'assets/images/onboarding3.png',
      ),
    ];
  }

  Future<bool> isOnboardingCompleted() async {
    // This will be implemented with SharedPreferences
    return false;
  }

  Future<void> setOnboardingCompleted() async {
    // This will be implemented with SharedPreferences
  }
}
