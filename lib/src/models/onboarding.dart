/// Onboarding information
class OnboardingInformation {
  /// Whether is onboarding
  final bool onboarding;

  OnboardingInformation({required this.onboarding});

  OnboardingInformation.fromJson(Map<String, dynamic> json)
      : onboarding = json['onboarding'];
}
