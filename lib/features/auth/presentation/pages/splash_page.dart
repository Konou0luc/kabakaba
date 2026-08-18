import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted || _tapped) return;

    final authState = ref.read(authProvider);
    final isLoggedIn = authState == AuthState.authenticated;
    context.go(isLoggedIn ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/icons/kabakaba.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.white,
                              child: const Icon(
                                Icons.restaurant_rounded,
                                size: 60,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.easeOutBack)
                    .shimmer(delay: 800.ms, duration: 1200.ms),
                const SizedBox(height: 24),
                Text(
                      'KabaKaba',
                      style: AppTextStyles.h1.copyWith(color: Colors.white),
                    )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 60),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: TextButton(
                      onPressed: () {
                        _tapped = true;
                        context.go('/home');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.line),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.rocket_launch_rounded, size: 16),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '[DÉMO] Accueil',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 1200)),
                const SizedBox(height: 12),
                Text(
                  '⚠️ Mode test uniquement — désactiver en prod',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 1400)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
