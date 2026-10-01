import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/utils/kaba_snack.dart';
import '../core/push/push_notifications.dart';
import '../features/auth/data/auth_provider.dart';
import '../shared/widgets/light_page_scaffold.dart';
import 'router/app_router.dart';

class KabaApp extends ConsumerWidget {
  const KabaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final mode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'KabaKaba',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: switch (mode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      },
      routerConfig: router,
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;
        LightPageColors.apply(brightness);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: const [SystemUiOverlay.bottom],
        );
        final overlay = brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlay.copyWith(
            statusBarColor: Colors.transparent,
            systemStatusBarContrastEnforced: false,
          ),
          child: KabaSnackHost(
            child: _PushSessionBinder(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}

class _PushSessionBinder extends ConsumerStatefulWidget {
  final Widget child;

  const _PushSessionBinder({required this.child});

  @override
  ConsumerState<_PushSessionBinder> createState() => _PushSessionBinderState();
}

class _PushSessionBinderState extends ConsumerState<_PushSessionBinder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(authProvider) == AuthState.authenticated) {
        ref.read(pushNotificationsProvider).syncToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      final push = ref.read(pushNotificationsProvider);
      if (next == AuthState.authenticated) {
        push.syncToken();
      } else if (next == AuthState.unauthenticated &&
          previous == AuthState.authenticated) {
        push.unregister();
      }
    });
    return widget.child;
  }
}
