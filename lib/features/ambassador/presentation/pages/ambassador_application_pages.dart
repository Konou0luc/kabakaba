import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../features/auth/data/auth_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../shared/widgets/kaba_background.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_input.dart';

class AmbassadorApplicationData {
  final String fullName;
  final String? email;
  final String phone;
  final String school;
  final String faculty;
  final String facultyId;
  final String? schoolCardUrl;
  final String? promoCode;

  const AmbassadorApplicationData({
    this.fullName = '',
    this.email,
    this.phone = '',
    this.school = '',
    this.faculty = '',
    this.facultyId = '',
    this.schoolCardUrl,
    this.promoCode,
  });

  const AmbassadorApplicationData.empty()
    : fullName = '',
      email = null,
      phone = '',
      school = '',
      faculty = '',
      facultyId = '',
      schoolCardUrl = null,
      promoCode = null;

  AmbassadorApplicationData copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? school,
    String? faculty,
    String? facultyId,
    String? schoolCardUrl,
    String? promoCode,
  }) {
    return AmbassadorApplicationData(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      school: school ?? this.school,
      faculty: faculty ?? this.faculty,
      facultyId: facultyId ?? this.facultyId,
      schoolCardUrl: schoolCardUrl ?? this.schoolCardUrl,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email ?? '',
    'phone': phone,
    'school': school,
    'faculty': faculty,
    'facultyId': facultyId,
    'schoolCardUrl': schoolCardUrl ?? '',
    'promoCode': promoCode ?? '',
  };

  factory AmbassadorApplicationData.fromMap(Map<String, dynamic>? map) {
    final payload = map ?? const {};
    return AmbassadorApplicationData(
      fullName: (payload['fullName'] as String?) ?? '',
      email: payload['email'] as String?,
      phone: (payload['phone'] as String?) ?? '',
      school: (payload['school'] as String?) ?? '',
      faculty: (payload['faculty'] as String?) ?? '',
      facultyId: (payload['facultyId'] as String?) ?? '',
      schoolCardUrl: payload['schoolCardUrl'] as String?,
      promoCode: payload['promoCode'] as String?,
    );
  }
}

class AmbassadorConditionsPage extends StatefulWidget {
  const AmbassadorConditionsPage({super.key});

  @override
  State<AmbassadorConditionsPage> createState() =>
      _AmbassadorConditionsPageState();
}

class _AmbassadorConditionsPageState extends State<AmbassadorConditionsPage> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return _AmbassadorScaffold(
      title: 'Devenir ambassadeur',
      step: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FlowHeading(
            icon: Icons.workspace_premium_rounded,
            title: 'Prêt à représenter kabakaba ?',
            subtitle:
                'Partage ton code avec tes amis et gagne des commissions sur leurs recharges.',
          ),
          const SizedBox(height: 24),
          KabaCard(
            padding: const EdgeInsets.all(18),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BenefitLine(
                  Icons.verified_user_outlined,
                  'Une carte scolaire valide est requise.',
                ),
                SizedBox(height: 14),
                _BenefitLine(
                  Icons.schedule_outlined,
                  'La demande est vérifiée par un administrateur.',
                ),
                SizedBox(height: 14),
                _BenefitLine(
                  Icons.lock_outline_rounded,
                  'Le code promo ne peut plus être modifié après validation.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            value: _accepted,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.accent,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              'J\'ai lu et j\'accepte les conditions du programme ambassadeur.',
              style: AppTextStyles.bodySmall,
            ),
            onChanged: (value) => setState(() => _accepted = value ?? false),
          ),
          const SizedBox(height: 18),
          KabaButton(
            text: 'Continuer',
            icon: Icons.arrow_forward_rounded,
            onPressed: _accepted
                ? () => context.push('/ambassador-signup')
                : null,
          ),
        ],
      ),
    );
  }
}

class AmbassadorPromoCodePage extends StatefulWidget {
  final AmbassadorApplicationData applicationData;

  const AmbassadorPromoCodePage({
    super.key,
    this.applicationData = const AmbassadorApplicationData.empty(),
  });

  @override
  State<AmbassadorPromoCodePage> createState() =>
      _AmbassadorPromoCodePageState();
}

class _AmbassadorPromoCodePageState extends State<AmbassadorPromoCodePage> {
  final _controller = TextEditingController();
  bool? _isAvailable;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkCode() {
    final code = _controller.text.trim().toUpperCase();
    if (code.length < 4) {
      ToastHelper.showError('Le code doit comporter au moins 4 caractères.');
      return;
    }
    setState(() => _isAvailable = code.length >= 4);
  }

  @override
  Widget build(BuildContext context) {
    return _AmbassadorScaffold(
      title: 'Code promo',
      step: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FlowHeading(
            icon: Icons.local_offer_outlined,
            title: 'Choisis ton code promo',
            subtitle:
                'Il doit être unique, mémorisable et contenir entre 4 et 12 caractères.',
          ),
          const SizedBox(height: 26),
          KabaCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                KabaInput(
                  label: 'Code promo',
                  hintText: 'Ex. KOFFI26',
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 12,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                  ],
                  onChanged: (_) => setState(() => _isAvailable = null),
                  suffixIcon: TextButton(
                    onPressed: _checkCode,
                    child: const Text('Vérifier'),
                  ),
                ),
                if (_isAvailable != null) ...[
                  const SizedBox(height: 10),
                  _StatusMessage(
                    success: _isAvailable!,
                    text: _isAvailable!
                        ? 'Ce code est disponible.'
                        : 'Ce code est déjà pris. Essaie un autre.',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          KabaButton(
            text: 'Utiliser ce code',
            icon: Icons.arrow_forward_rounded,
            onPressed: _isAvailable == true
                ? () {
                    final nextData = widget.applicationData.copyWith(
                      promoCode: _controller.text.trim().toUpperCase(),
                    );
                    context.push('/ambassador/recap', extra: nextData.toMap());
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class AmbassadorRecapPage extends ConsumerStatefulWidget {
  final AmbassadorApplicationData applicationData;

  const AmbassadorRecapPage({
    super.key,
    this.applicationData = const AmbassadorApplicationData.empty(),
  });

  @override
  ConsumerState<AmbassadorRecapPage> createState() =>
      _AmbassadorRecapPageState();
}

class _AmbassadorRecapPageState extends ConsumerState<AmbassadorRecapPage> {
  bool _isSubmitting = false;

  Future<void> _submitApplication() async {
    final loggerUserId = ref.read(authRepositoryProvider).getCurrentUserId();
    if (loggerUserId == null || loggerUserId.isEmpty) {
      ToastHelper.showError(
        'Vous devez être connecté pour envoyer une candidature.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(ambassadorRepositoryProvider).submitApplication(
            institution: widget.applicationData.school,
            facultyId: widget.applicationData.facultyId,
            schoolCardUrl: widget.applicationData.schoolCardUrl ?? '',
            promoCode: widget.applicationData.promoCode,
          );
      ref.invalidate(myAmbassadorProvider);

      if (!mounted) return;
      context.go(
        '/ambassador/pending',
        extra: widget.applicationData.promoCode ?? '',
      );
    } catch (error) {
      ToastHelper.showError(apiErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final promoCode = widget.applicationData.promoCode ?? '—';

    return _AmbassadorScaffold(
      title: 'Récapitulatif',
      step: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FlowHeading(
            icon: Icons.fact_check_outlined,
            title: 'Vérifie ta demande',
            subtitle: 'Tu pourras être contacté si une information manque.',
          ),
          const SizedBox(height: 26),
          KabaCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _RecapRow('Nom', widget.applicationData.fullName),
                const Divider(height: 24),
                _RecapRow(
                  'Email',
                  widget.applicationData.email ?? 'Non renseigné',
                ),
                const Divider(height: 24),
                _RecapRow('Téléphone', widget.applicationData.phone),
                const Divider(height: 24),
                _RecapRow('Établissement', widget.applicationData.school),
                const Divider(height: 24),
                _RecapRow('Faculté', widget.applicationData.faculty),
                const Divider(height: 24),
                _RecapRow(
                  'Carte scolaire',
                  widget.applicationData.schoolCardUrl != null &&
                          widget.applicationData.schoolCardUrl!.isNotEmpty
                      ? 'Ajoutée'
                      : 'Non ajoutée',
                ),
                const Divider(height: 24),
                _RecapRow('Code promo', promoCode, emphasize: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          KabaButton(
            text: 'Envoyer ma demande',
            icon: Icons.send_rounded,
            isLoading: _isSubmitting,
            onPressed: _submitApplication,
          ),
        ],
      ),
    );
  }
}

class AmbassadorPendingPage extends StatelessWidget {
  final String promoCode;

  const AmbassadorPendingPage({super.key, required this.promoCode});

  @override
  Widget build(BuildContext context) {
    return _AmbassadorScaffold(
      title: 'Demande envoyée',
      step: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const Icon(
            Icons.mark_email_read_rounded,
            size: 74,
            color: AppColors.success,
          ).animate().scale(curve: Curves.easeOutBack),
          const SizedBox(height: 22),
          Text(
            'Demande envoyée !',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 10),
          Text(
            'Ton code $promoCode sera activé uniquement après acceptation de ta demande.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 30),
          KabaCard(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(Icons.schedule_rounded, color: AppColors.accent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Nous te notifierons dès que la demande sera traitée.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          KabaButton(
            text: 'Retour à l’accueil',
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}

class _AmbassadorScaffold extends StatelessWidget {
  final String title;
  final int step;
  final Widget child;

  const _AmbassadorScaffold({
    required this.title,
    required this.step,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent),
      body: KabaBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            children: [
              Text('Étape $step/5', style: AppTextStyles.bodySmall),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: step / 5,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 32),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowHeading extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FlowHeading({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: AppColors.accent, size: 46),
      const SizedBox(height: 14),
      Text(title, textAlign: TextAlign.center, style: AppTextStyles.h2),
      const SizedBox(height: 8),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
      ),
    ],
  );
}

class _BenefitLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BenefitLine(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: AppColors.accent, size: 20),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
    ],
  );
}

class _StatusMessage extends StatelessWidget {
  final bool success;
  final String text;
  const _StatusMessage({required this.success, required this.text});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: (success ? AppColors.success : AppColors.error).withValues(
        alpha: 0.12,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(
          success ? Icons.check_circle : Icons.error_outline,
          color: success ? AppColors.success : AppColors.error,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
      ],
    ),
  );
}

class _RecapRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  const _RecapRow(this.label, this.value, {this.emphasize = false});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: emphasize ? AppColors.accent : null,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}
