import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_background.dart';

class PromoCodePage extends ConsumerWidget {
  const PromoCodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambassador = ref.watch(myAmbassadorProvider).valueOrNull;
    final code = ambassador?.promoCode.trim() ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Mon code promo'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: KabaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Text('Partage ton code', style: AppTextStyles.h2),
                const SizedBox(height: 32),
                KabaCard(
                  padding: const EdgeInsets.all(32),
                  color: AppColors.primary,
                  child: Column(
                    children: [
                      Text(
                        'TON CODE',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        code.isEmpty ? '—' : code,
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  code.isEmpty
                      ? 'Ton code apparaîtra ici une fois ta candidature validée.'
                      : 'Tes filleuls l’utilisent à l’inscription. Les commissions s’affichent dans ton tableau de bord.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const Spacer(),
                KabaButton(
                  text: 'Copier le code',
                  onPressed: code.isEmpty
                      ? null
                      : () async {
                          await Clipboard.setData(ClipboardData(text: code));
                          if (context.mounted) {
                            showKabaSnack(context, 'Code copié');
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
