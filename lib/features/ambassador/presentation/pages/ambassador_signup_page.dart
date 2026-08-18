import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
  final _schoolController = TextEditingController();
  final _facultyController = TextEditingController();
  XFile? _studentIdPhoto;
  bool _isLoading = false;

  // Example list of schools (we can make this dynamic later)
  static const List<String> _schools = [
    'Université de Lomé',
    'Université de Kara',
    'École Supérieure Polytechnique de Lomé',
    'Institut National de Formation des Maîtres',
    'École Nationale d\'Administration et de Magistrature',
    'Autre',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _promoCodeController.dispose();
    _schoolController.dispose();
    _facultyController.dispose();
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

  Future<void> _pickStudentIdPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() {
        _studentIdPhoto = photo;
      });
    }
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      // Check if photo is selected
      if (_studentIdPhoto == null) {
        ToastHelper.showError(
          'Veuillez ajouter une photo de votre carte scolaire',
        );
        return;
      }
      if (_schoolController.text.isEmpty) {
        ToastHelper.showError('Veuillez sélectionner votre école');
        return;
      }
      if (_facultyController.text.isEmpty) {
        ToastHelper.showError('Veuillez renseigner votre faculté/institut');
        return;
      }

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Inscription Ambassadeur'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                      // School selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'École / Université',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : AppColors.greyLight,
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _schoolController.text.isEmpty
                                    ? null
                                    : _schoolController.text,
                                hint: Text(
                                  'Sélectionnez votre école',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                                isExpanded: true,
                                items: _schools.map((school) {
                                  return DropdownMenuItem(
                                    value: school,
                                    child: Text(
                                      school,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _schoolController.text = value ?? '';
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.1),
                      const SizedBox(height: 16),
                      KabaInput(
                        label: 'Faculté / Institut',
                        hintText: 'Ex: Faculté des Sciences',
                        controller: _facultyController,
                        keyboardType: TextInputType.text,
                      ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1),
                      const SizedBox(height: 16),
                      // Student ID photo
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carte scolaire (photo)',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _pickStudentIdPhoto,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : AppColors.greyLight,
                                  width: 1,
                                ),
                              ),
                              child: _studentIdPhoto == null
                                  ? Column(
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_rounded,
                                          size: 48,
                                          color: AppColors.grey,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Ajouter une photo ou importer depuis la galerie',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(color: AppColors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 48,
                                          color: AppColors.success,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Photo ajoutée !',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.success,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          _studentIdPhoto!.name,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(color: AppColors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.1),
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
                      ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.1),
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
