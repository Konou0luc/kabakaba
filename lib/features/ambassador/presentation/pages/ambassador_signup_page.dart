import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'ambassador_application_pages.dart';
import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/phone_e164.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_input.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class AmbassadorSignupPage extends ConsumerStatefulWidget {
  const AmbassadorSignupPage({super.key});

  @override
  ConsumerState<AmbassadorSignupPage> createState() =>
      _AmbassadorSignupPageState();
}

class _AmbassadorSignupPageState extends ConsumerState<AmbassadorSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _promoCodeController = TextEditingController();
  FacultyModel? _selectedFaculty;
  XFile? _studentIdPhoto;
  String? _schoolCardUrl;
  bool _isLoading = false;
  bool _uploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(meProvider).valueOrNull ?? ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = [
        user.firstName,
        user.lastName,
      ].where((part) => part != null && part.isNotEmpty).join(' ');
      final phone = user.phone?.trim();
      _phoneController.text =
          (phone == null || phone.isEmpty) ? '' : formatTogoDisplay(phone);
      _emailController.text = user.email ?? '';
    }
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
        _uploading = true;
      });
      try {
        final url = await ref
            .read(ambassadorRepositoryProvider)
            .uploadSchoolCard(photo.path);
        if (!mounted) return;
        setState(() => _schoolCardUrl = url);
      } catch (error) {
        if (mounted) {
          ToastHelper.showError(apiErrorMessage(error));
          setState(() {
            _studentIdPhoto = null;
            _schoolCardUrl = null;
          });
        }
      } finally {
        if (mounted) setState(() => _uploading = false);
      }
    }
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      if (toTogoLocalDigits(_phoneController.text).length < 8) {
        ToastHelper.showError('Veuillez entrer un numéro valide');
        return;
      }
      // Check if photo is selected
      if (_schoolCardUrl == null || _schoolCardUrl!.isEmpty) {
        ToastHelper.showError(
          'Veuillez ajouter une photo de votre carte scolaire',
        );
        return;
      }
      final user =
          ref.read(meProvider).valueOrNull ?? ref.read(currentUserProvider);
      final campus = (ref.read(campusesListProvider).valueOrNull ?? const [])
          .where((item) => item.id == user?.campusId)
          .firstOrNull;
      if (_selectedFaculty == null) {
        ToastHelper.showError('Choisis ta faculté dans la liste du campus.');
        return;
      }

      final draft = AmbassadorApplicationData(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: toTogoE164(_phoneController.text),
        school: campus?.institution ?? campus?.name ?? 'Campus',
        faculty: _selectedFaculty!.name,
        facultyId: _selectedFaculty!.id,
        schoolCardUrl: _schoolCardUrl,
        promoCode: _promoCodeController.text.trim().toUpperCase(),
      );
      context.push('/ambassador/code', extra: draft.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return LightPageScaffold(
      title: 'Inscription ambassadeur',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(
              'Complétez votre inscription',
              style: AppTextStyles.h2.copyWith(color: onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Ces informations nous permettront de créer votre compte ambassadeur.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            KabaCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      ),
                      const SizedBox(height: 16),
                      KabaInput(
                        label: 'Adresse email (optionnel)',
                        hintText: 'Ex: john@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      KabaPhoneField(
                        label: 'Numéro de téléphone',
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (context) {
                          final user = ref.watch(meProvider).valueOrNull ??
                              ref.watch(currentUserProvider);
                          final campusId = user?.campusId;
                          final campuses =
                              ref.watch(campusesListProvider).valueOrNull ??
                                  const [];
                          final campus = campuses
                              .where((item) => item.id == campusId)
                              .firstOrNull;
                          final faculties = campusId == null
                              ? const <FacultyModel>[]
                              : ref.watch(facultiesProvider(campusId)).valueOrNull ??
                                  const <FacultyModel>[];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Campus',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                campus?.institution ??
                                    campus?.name ??
                                    'Aucun campus associé à ton compte',
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Faculté / Institut',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  visualDensity: VisualDensity.compact,
                                  inputDecorationTheme:
                                      const InputDecorationTheme(
                                    filled: false,
                                    isDense: true,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.field
                                        : const Color(0xFFF0F3FA),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.line
                                          : const Color(0x1A1B2A6B),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: DropdownButtonFormField<FacultyModel>(
                                    initialValue: _selectedFaculty,
                                    hint: Text(
                                      'Choisis ta faculté',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: onSurface.withValues(alpha: 0.45),
                                      ),
                                    ),
                                    isExpanded: true,
                                    isDense: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: onSurface.withValues(alpha: 0.55),
                                    ),
                                    dropdownColor:
                                        Theme.of(context).cardColor,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: onSurface,
                                    ),
                                    decoration: const InputDecoration(
                                      filled: false,
                                      isDense: true,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    items: faculties
                                        .map(
                                          (faculty) => DropdownMenuItem(
                                            value: faculty,
                                            child: Text(faculty.name),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) => setState(
                                      () => _selectedFaculty = value,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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
                              child: _uploading
                                  ? const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    )
                                  : _studentIdPhoto == null
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
                      ),
                      const SizedBox(height: 16),
                      KabaInput(
                        label: 'Code promo personnalisé',
                        hintText: 'Ex: JOHND20',
                        controller: _promoCodeController,
                        keyboardType: TextInputType.text,
                        suffixIcon: GestureDetector(
                          onTap: _handleGenerateCode,
                          child: const Icon(Icons.autorenew_rounded, size: 20),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                KabaButton(
                  text: 'Envoyer ma demande',
                  onPressed: _handleSignup,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }
}
