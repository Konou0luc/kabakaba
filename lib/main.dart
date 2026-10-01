import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/theme_provider.dart';
import 'core/push/push_notifications.dart';
import 'app/app.dart';

Future<void> _hidePhoneStatusBar() {
  return SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}

Future<void> _bootstrapFirebase() async {
  try {
    await ensureFirebaseInitialized();
    print('KABA_PUSH: bootstrap OK');
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (error, stack) {
    print('KABA_PUSH: bootstrap échec: $error\n$stack');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _hidePhoneStatusBar();
  await _bootstrapFirebase();

  await dotenv.load(fileName: '.env');

  await GoogleFonts.pendingFonts([GoogleFonts.plusJakartaSans()]);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const KabaApp(),
    ),
  );
}
