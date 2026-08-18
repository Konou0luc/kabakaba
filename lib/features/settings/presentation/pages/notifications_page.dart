import 'package:flutter/material.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _filter = 0;
  final _filters = const ['Tout', 'Commandes', 'Promos', 'Système'];

  final List<Map<String, dynamic>> _items = [
    {
      'type': 'order',
      'icon': Icons.check_circle_rounded,
      'color': LightPageColors.green,
      'bgColor': LightPageColors.greenLight,
      'title': 'Commande confirmée !',
      'desc': 'Ta commande #KB-87242 est prête chez Chez Mama Afi.',
      'time': 'Il y a 2 min',
      'unread': true,
    },
    {
      'type': 'promo',
      'icon': Icons.local_offer_rounded,
      'color': LightPageColors.orange,
      'bgColor': LightPageColors.orangeLight,
      'title': '-30% sur ton prochain plat !',
      'desc': 'Profite de WELCOME30 valable jusqu\'à dimanche minuit.',
      'time': 'Il y a 15 min',
      'unread': true,
    },
    {
      'type': 'order',
      'icon': Icons.delivery_dining_rounded,
      'color': LightPageColors.indigo,
      'bgColor': LightPageColors.indigoLight,
      'title': 'Livreur en route',
      'desc': 'Kossi arrive dans 5-8 min avec ton plat Attiéké.',
      'time': 'Il y a 1h',
      'unread': false,
    },
    {
      'type': 'system',
      'icon': Icons.verified_user_rounded,
      'color': LightPageColors.indigo,
      'bgColor': LightPageColors.indigoLight,
      'title': 'Compte vérifié',
      'desc': 'Ton téléphone a été vérifié avec succès. Bienvenue !',
      'time': 'Il y a 3h',
      'unread': false,
    },
    {
      'type': 'promo',
      'icon': Icons.emoji_events_rounded,
      'color': LightPageColors.warning,
      'bgColor': LightPageColors.warningLight,
      'title': 'Défi ambassadeur : +500 tickets',
      'desc': 'Parraine 3 amis cette semaine et gagne 500 tickets bonus !',
      'time': 'Hier',
      'unread': false,
    },
    {
      'type': 'order',
      'icon': Icons.restaurant_menu_rounded,
      'color': LightPageColors.red,
      'bgColor': LightPageColors.redLight,
      'title': 'Nouveau restaurant : Le Sahel',
      'desc': 'Découvre les plats sénégalais maintenant disponibles sur le campus.',
      'time': 'Hier',
      'unread': false,
    },
    {
      'type': 'system',
      'icon': Icons.account_balance_wallet_rounded,
      'color': LightPageColors.green,
      'bgColor': LightPageColors.greenLight,
      'title': 'Recharge réussie',
      'desc': '5 000 FCFA ont été ajoutés à ton portefeuille.',
      'time': '2 jours',
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 0
        ? _items
        : _items.where((n) {
            final type = n['type'] as String;
            if (_filter == 1) return type == 'order';
            if (_filter == 2) return type == 'promo';
            return type == 'system';
          }).toList();
    final unreadCount = _items.where((n) => n['unread'] as bool).length;

    return LightPageScaffold(
      title: 'Notifications',
      actions: [
        if (unreadCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() {
                  for (var n in _items) {
                    n['unread'] = false;
                  }
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: LightPageColors.indigoLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.done_all_rounded,
                        size: 12,
                        color: LightPageColors.indigo,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tout lu',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildSummary(unreadCount),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 14),
          if (filtered.isEmpty)
            _buildEmpty()
          else
            ...List.generate(filtered.length, (i) {
              final n = filtered[i];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i == filtered.length - 1 ? 0 : 10,
                ),
                child: _buildNotifCard(n),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSummary(int unread) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: unread > 0
              ? const [Color(0xFF1B2A6B), Color(0xFF3D4A8E), Color(0xFF6366F1)]
              : const [Color(0xFF475569), Color(0xFF64748B), Color(0xFF94A3B8)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (unread > 0 ? LightPageColors.indigo : LightPageColors.muted)
                .withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                if (unread > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: LightPageColors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF3D4A8E),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$unread',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unread > 0
                      ? 'Tu as $unread nouvelle(s) notification(s)'
                      : 'Toutes tes notifications sont lues',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  unread > 0
                      ? 'N\'hésite pas à les consulter'
                      : 'Tu es à jour sur tout 👌',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final sel = _filter == i;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onTap: () => setState(() => _filter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: sel ? LightPageColors.indigo : LightPageColors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: sel
                        ? LightPageColors.indigo
                        : LightPageColors.border,
                    width: 1.2,
                  ),
                  boxShadow: sel
                      ? [
                          BoxShadow(
                            color: LightPageColors.indigo.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  _filters[i],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: sel ? Colors.white : LightPageColors.text2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotifCard(Map<String, dynamic> n) {
    final unread = n['unread'] as bool;
    return LightCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 15,
      onTap: () => setState(() => n['unread'] = false),
      border: unread
          ? Border.all(
              color: LightPageColors.orange.withValues(alpha: 0.35), width: 1.3)
          : null,
      color: unread ? LightPageColors.orange.withValues(alpha: 0.025) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: n['bgColor'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              n['icon'] as IconData,
              size: 20,
              color: n['color'] as Color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        n['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: LightPageColors.text,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: LightPageColors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  n['desc'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: LightPageColors.muted,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 11,
                      color: LightPageColors.muted,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      n['time'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: LightPageColors.muted,
                      ),
                    ),
                    const Spacer(),
                    if ((n['type'] as String) == 'promo')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: LightPageColors.orangeLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'UTILISER',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: LightPageColors.orange,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: LightPageColors.indigoLight,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.notifications_off_rounded,
              size: 36,
              color: LightPageColors.indigo,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification ici',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: LightPageColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tu seras prévenu dès qu\'il y aura du nouveau.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: LightPageColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
