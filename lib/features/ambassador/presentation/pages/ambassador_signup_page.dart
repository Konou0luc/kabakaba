import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/kaba_background.dart';

class AmbassadorSignupPage extends StatefulWidget {
  const AmbassadorSignupPage({super.key});

  @override
  State<AmbassadorSignupPage> createState() => _AmbassadorSignupPageState();
}

class _AmbassadorSignupPageState extends State<AmbassadorSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+228 ');
  final _promoCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  String _generatePromoCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  void _handleGenerateCode() {
    final code = _generatePromoCode();
    _promoCodeController.text = code;
    ToastHelper.showInfo('Code promo généré : $code');
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);
      ToastHelper.showSuccess(
        'Demande envoyée ! Nous vous contacterons bientôt.',
      );

      // Retourner à l'accueil
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Inscription Ambassadeur', style: AppTextStyles.h3),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary(context),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: KabaBackground(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Text(
                  'Complétez votre inscription',
                  style: AppTextStyles.h2,
                ).animate().fadeIn().slideX(begin: -0.1),
                const SizedBox(height: 8),
                Text(
                  'Ces informations nous permettront de créer votre compte ambassadeur.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                const SizedBox(height: 32),
                KabaCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      KabaInput(
                        label: 'Nom complet',
                        hintText: 'Ex: John Doe',
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                      const SizedBox(height: 16),
                      KabaInput(
                        label: 'Adresse email (optionnel)',
                        hintText: 'Ex: john@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                      const SizedBox(height: 16),
                      KabaInput(
                        label: 'Numéro de téléphone',
                        hintText: 'Ex: 90 00 00 00',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone_iphone_rounded),
                              const SizedBox(width: 8),
                              Text(
                                '+228',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 20,
                                color: AppColors.greyLight,
                              ),
                            ],
                          ),
                        ),
                        maxLength: 12,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre numéro';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
                      const SizedBox(height: 16),
                      KabaInput(
                        label: 'Code promo personnalisé',
                        hintText: 'Ex: JOHND20',
                        controller: _promoCodeController,
                        keyboardType: TextInputType.text,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.autorenew_rounded),
                          onPressed: _handleGenerateCode,
                          tooltip: 'Générer un code',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez choisir un code promo';
                          }
                          if (value.length < 4) {
                            return 'Le code doit contenir au moins 4 caractères';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 32),
                KabaButton(
                  text: 'Envoyer ma demande',
                  onPressed: _handleSignup,
                  isLoading: _isLoading,
                ).animate().fadeIn(delay: 1200.ms).scale(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
