import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

enum KabaSnackKind { error, success, info, warning }

class _KabaSnackRequest {
  final String message;
  final KabaSnackKind kind;
  final Duration duration;

  const _KabaSnackRequest({
    required this.message,
    required this.kind,
    required this.duration,
  });
}

class KabaSnack {
  KabaSnack._();

  static final ValueNotifier<_KabaSnackRequest?> _queue =
      ValueNotifier<_KabaSnackRequest?>(null);

  static void show(
    String message, {
    KabaSnackKind kind = KabaSnackKind.info,
    Duration? duration,
  }) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    _queue.value = _KabaSnackRequest(
      message: trimmed,
      kind: kind,
      duration: duration ??
          (kind == KabaSnackKind.error
              ? const Duration(milliseconds: 4200)
              : const Duration(milliseconds: 3200)),
    );
  }

  static void error(String message) =>
      show(message, kind: KabaSnackKind.error);

  static void success(String message) =>
      show(message, kind: KabaSnackKind.success);

  static void info(String message) => show(message, kind: KabaSnackKind.info);

  static void warning(String message) =>
      show(message, kind: KabaSnackKind.warning);
}

void showKabaSnack(
  BuildContext context,
  String message, {
  bool error = false,
  KabaSnackKind? kind,
}) {
  KabaSnack.show(
    message,
    kind: kind ?? (error ? KabaSnackKind.error : KabaSnackKind.success),
  );
}

class KabaSnackHost extends StatelessWidget {
  final Widget child;

  const KabaSnackHost({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _KabaSnackOverlay(),
        ),
      ],
    );
  }
}

class _KabaSnackOverlay extends StatefulWidget {
  const _KabaSnackOverlay();

  @override
  State<_KabaSnackOverlay> createState() => _KabaSnackOverlayState();
}

class _KabaSnackOverlayState extends State<_KabaSnackOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  _KabaSnackRequest? _current;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 280),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    KabaSnack._queue.addListener(_onQueue);
  }

  @override
  void dispose() {
    KabaSnack._queue.removeListener(_onQueue);
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onQueue() async {
    final next = KabaSnack._queue.value;
    if (next == null) return;
    _hideTimer?.cancel();
    if (_current != null && _controller.isCompleted) {
      await _controller.reverse();
    }
    if (!mounted) return;
    setState(() => _current = next);
    await _controller.forward(from: 0);
    _hideTimer = Timer(next.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    _hideTimer?.cancel();
    if (_controller.isDismissed) return;
    await _controller.reverse();
    if (mounted) setState(() => _current = null);
  }

  @override
  Widget build(BuildContext context) {
    final request = _current;
    if (request == null) return const SizedBox.shrink();

    return SafeArea(
      bottom: false,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: _KabaSnackCard(
              request: request,
              onClose: _dismiss,
            ),
          ),
        ),
      ),
    );
  }
}

class _KabaSnackStyle {
  final Color accent;
  final Color wash;
  final Color ink;
  final IconData icon;
  final String label;

  const _KabaSnackStyle({
    required this.accent,
    required this.wash,
    required this.ink,
    required this.icon,
    required this.label,
  });
}

_KabaSnackStyle _styleFor(KabaSnackKind kind, bool dark) {
  switch (kind) {
    case KabaSnackKind.error:
      return const _KabaSnackStyle(
        accent: Color(0xFFE11D48),
        wash: Color(0xFFFFF1F2),
        ink: Color(0xFF9F1239),
        icon: Icons.error_outline_rounded,
        label: 'Erreur',
      );
    case KabaSnackKind.success:
      return const _KabaSnackStyle(
        accent: Color(0xFF059669),
        wash: Color(0xFFECFDF5),
        ink: Color(0xFF065F46),
        icon: Icons.check_circle_outline_rounded,
        label: 'Succès',
      );
    case KabaSnackKind.warning:
      return const _KabaSnackStyle(
        accent: Color(0xFFD97706),
        wash: Color(0xFFFFFBEB),
        ink: Color(0xFF92400E),
        icon: Icons.warning_amber_rounded,
        label: 'Attention',
      );
    case KabaSnackKind.info:
      return _KabaSnackStyle(
        accent: AppColors.accent,
        wash: dark ? const Color(0xFF152056) : const Color(0xFFEEF1FA),
        ink: dark ? Colors.white : AppColors.indigoDark,
        icon: Icons.info_outline_rounded,
        label: 'Info',
      );
  }
}

class _KabaSnackCard extends StatelessWidget {
  final _KabaSnackRequest request;
  final VoidCallback onClose;

  const _KabaSnackCard({required this.request, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = _styleFor(request.kind, dark);
    final surface = dark ? const Color(0xFF111A45) : Colors.white;
    final titleColor = dark ? Colors.white : style.ink;
    final bodyColor = dark
        ? Colors.white.withValues(alpha: 0.72)
        : const Color(0xFF3D4A6B);

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onClose,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: style.accent.withValues(alpha: dark ? 0.28 : 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.indigoDark.withValues(alpha: dark ? 0.45 : 0.10),
                blurRadius: 28,
                offset: const Offset(0, 12),
                spreadRadius: -8,
              ),
              BoxShadow(
                color: style.accent.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 5, color: style.accent),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: dark
                                  ? style.accent.withValues(alpha: 0.18)
                                  : style.wash,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(style.icon, color: style.accent, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  style.label,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                    color: style.accent,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  request.message,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                    color: titleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onClose,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 32,
                              height: 32,
                            ),
                            icon: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: bodyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
