import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/kaba_card.dart';

import '../../../../shared/widgets/kaba_background.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: KabaBackground(
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _NotificationItem(index: index)
                  .animate()
                  .fadeIn(delay: (index * 50).ms)
                  .slideX();
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final int index;

  const _NotificationItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final isUnread = index < 2;
    return KabaCard(
      color: isUnread ? AppColors.surfaceSecondary(context) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (index % 2 == 0 ? AppColors.primary : AppColors.accent)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              index % 2 == 0
                  ? Icons.notifications_rounded
                  : Icons.delivery_dining_rounded,
              color: index % 2 == 0 ? AppColors.primary : AppColors.accent,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index % 2 == 0
                      ? 'Commande prête !'
                      : 'Nouveau restaurant ouvert',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  index % 2 == 0
                      ? 'Votre commande #1089 est prête à être récupérée.'
                      : 'Découvrez la nouvelle cantine sur le campus.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  index == 0
                      ? 'Il y a 10 minutes'
                      : 'Il y a ${index + 1} heures',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
