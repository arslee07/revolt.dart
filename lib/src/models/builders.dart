import 'package:revolt/src/utils/builder.dart';

class CompleteOnboardingBuilder extends Builder<Map<String, dynamic>> {
  final String username;

  CompleteOnboardingBuilder({required this.username});

  @override
  Map<String, dynamic> build() => {'username': username};
}
