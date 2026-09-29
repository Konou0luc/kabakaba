import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/repositories.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../shared/models/api_models.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  int _filter = 0;
  final _filters = const ['Tout', 'Commandes', 'Promos', 'Système'];

  List<NotificationModel> _applyFilter(List<NotificationModel> items) {
    if (_filter == 0) return items;
    return items.where((item) {
      if (_filter == 1) return item.type == NotificationType.ORDER;
      if (_filter == 2) {
        return item.type == NotificationType.PROMOTION ||
            item.type == NotificationType.AMBASSADOR;
      }
      return item.type == NotificationType.SYSTEM ||
          item.type == NotificationType.PAYMENT;
    }).toList();
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'À l’instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    if (diff.inDays == 1) return 'Hier';
    return 'Il y a ${diff.inDays} j';
  }

  (IconData, Color, Color) _styleOf(NotificationType type) {
    return switch (type) {
      NotificationType.ORDER => (
          Icons.restaurant_rounded,
          LightPageColors.indigo,
          LightPageColors.indigoLight,
        ),
      NotificationType.PAYMENT => (
          Icons.account_balance_wallet_rounded,
          LightPageColors.green,
          LightPageColors.greenLight,
        ),
      NotificationType.PROMOTION => (
          Icons.local_offer_rounded,
          LightPageColors.orange,
          LightPageColors.orangeLight,
        ),
      NotificationType.AMBASSADOR => (
          Icons.emoji_events_rounded,
          LightPageColors.warning,
          LightPageColors.warningLight,
        ),
      NotificationType.SYSTEM => (
          Icons.notifications_rounded,
          LightPageColors.indigo,
          LightPageColors.indigoLight,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(myNotificationsProvider);
    final items = async.valueOrNull ?? const <NotificationModel>[];
    final filtered = _applyFilter(items);
    final unreadCount = items.where((n) => !n.isRead).length;

    return LightPageScaffold(
      title: 'Notifications',
      actions: [
        if (unreadCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(notificationRepositoryProvider)
                      .markAllRead(items);
                  ref.invalidate(myNotificationsProvider);
                } catch (error) {
                  if (context.mounted) {
                    showKabaSnack(context, apiErrorMessage(error), error: true);
                  }
                }
              },
              child: const Text('Tout lu'),
            ),
          ),
      ],
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => RefreshIndicator(
          color: LightPageColors.orange,
          onRefresh: () => refreshStudentSession(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Text(apiErrorMessage(error), textAlign: TextAlign.center),
            ],
          ),
        ),
        data: (_) {
          return RefreshIndicator(
            color: LightPageColors.orange,
            onRefresh: () => refreshStudentSession(ref),
            child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Text(
                unreadCount > 0
                    ? 'Tu as $unreadCount notification(s) non lue(s)'
                    : 'Tout est à jour',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final sel = _filter == i;
                    return InkWell(
                      onTap: () => setState(() => _filter = i),
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: sel ? LightPageColors.orange : LightPageColors.white,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: LightPageColors.border),
                        ),
                        child: Text(
                          _filters[i],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: sel ? Colors.white : LightPageColors.text2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'Aucune notification ici.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: LightPageColors.muted,
                    ),
                  ),
                )
              else
                ...filtered.map((item) {
                  final style = _styleOf(item.type);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LightCard(
                      padding: const EdgeInsets.all(12),
                      onTap: () async {
                        if (item.isRead) return;
                        await ref
                            .read(notificationRepositoryProvider)
                            .updateNotification(id: item.id, isRead: true);
                        ref.invalidate(myNotificationsProvider);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: style.$3,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(style.$1, color: style.$2, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.body,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: LightPageColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _timeAgo(item.createdAt),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: LightPageColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!item.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: LightPageColors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
            ),
          );
        },
      ),
    );
  }
}
