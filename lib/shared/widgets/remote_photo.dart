import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class RemotePhoto extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final double radius;
  final Widget fallback;
  final BoxFit fit;

  const RemotePhoto({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.radius = 0,
    required this.fallback,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final src = url?.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: src == null || src.isEmpty
            ? fallback
            : Image.network(
                src,
                fit: fit,
                width: width,
                height: height,
                errorBuilder: (_, _, _) => fallback,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return ColoredBox(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
