import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../data/onboarding_prefs.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _currentPage = 0;
  final _pageController = PageController();

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Savourez chaque bouchée, livré rapidement',
      description:
          'KabaKaba - Savourez chaque repas de votre cantine universitaire, rapidement et simplement.',
      image: 'assets/images/onboarding1.webp',
    ),
    OnboardingItem(
      title: 'Commandez en un éclair',
      description:
          'Choisissez votre menu et commandez votre repas en moins de 30 secondes.',
      image: 'assets/images/onboarding2.webp',
    ),
    OnboardingItem(
      title: 'Suivez votre commande',
      description: 'Restez informé de l\'état de votre commande en temps réel.',
      image: 'assets/images/onbording.webp',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await markOnboardingSeen(ref.read(sharedPreferencesProvider));
    if (!mounted) return;
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView avec les images et les textes
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final item = _items[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.primary.withValues(alpha: 0.95),
                        ],
                        stops: const [0.2, 0.8],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 5),
                          Text(
                                item.title,
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.white,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideX(begin: -0.1, end: 0),
                          const SizedBox(height: 12),
                          Text(
                            item.description,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // UI en superposition
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Bouton Passer en haut à droite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_currentPage < _items.length - 1)
                        KabaButton(
                          text: 'Passer',
                          type: KabaButtonType.ghost,
                          fullWidth: false,
                          onPressed: _finish,
                        ),
                    ],
                  ),
                  const Spacer(),
                  // Indicateur de page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _items.length,
                      (i) => AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == i ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.accent
                              : AppColors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bouton principal
                  KabaButton(
                    text: _currentPage == _items.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    onPressed: () {
                      if (_currentPage == _items.length - 1) {
                        _finish();
                      } else {
                        _pageController.nextPage(
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}
