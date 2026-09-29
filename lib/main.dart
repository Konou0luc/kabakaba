import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/theme_provider.dart';
import 'app/app.dart';

Future<void> _hidePhoneStatusBar() {
  return SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _hidePhoneStatusBar();

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
