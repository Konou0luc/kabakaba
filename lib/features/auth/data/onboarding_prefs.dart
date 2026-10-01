import 'package:shared_preferences/shared_preferences.dart';

const kOnboardingSeenKey = 'onboarding_seen';

bool hasSeenOnboarding(SharedPreferences prefs) =>
    prefs.getBool(kOnboardingSeenKey) == true;

Future<void> markOnboardingSeen(SharedPreferences prefs) =>
    prefs.setBool(kOnboardingSeenKey, true);
