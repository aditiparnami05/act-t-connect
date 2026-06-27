import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Minimal splash screen — centered logo with Mobile + Desktop badges.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateNext());
  }

  Future<void> _navigateNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    if (ref.read(authProvider).isAuthenticated) return;

    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'app_logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Symbols.hub,
                    size: 96,
                    color: AppColors.primary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1, 1),
                    duration: 700.ms,
                    curve: Curves.easeOutBack,
                  ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _PlatformBadge(
                    label: 'Mobile',
                    icon: Symbols.smartphone,
                    isMobile: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const _PlatformBadge(
                    label: 'Desktop',
                    icon: Symbols.laptop_mac,
                    isMobile: false,
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.15, end: 0, delay: 400.ms, duration: 600.ms),
            ),
          ],
        ),
      ),
    );
  }
}

/// Isometric-style platform icon with label.
class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({
    required this.label,
    required this.icon,
    required this.isMobile,
  });

  final String label;
  final IconData icon;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: CustomPaint(
            painter: _PedestalPainter(),
            child: Center(
              child: Transform.translate(
                offset: Offset(0, isMobile ? -6 : -4),
                child: Icon(
                  icon,
                  size: isMobile ? 30 : 28,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary.withValues(alpha: 0.85),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

/// Soft isometric pedestal under platform icons.
class _PedestalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 8);
    final topFace = Path()
      ..moveTo(center.dx - 22, center.dy - 10)
      ..lineTo(center.dx + 22, center.dy - 10)
      ..lineTo(center.dx + 28, center.dy - 4)
      ..lineTo(center.dx - 16, center.dy - 4)
      ..close();

    final leftFace = Path()
      ..moveTo(center.dx - 22, center.dy - 10)
      ..lineTo(center.dx - 16, center.dy - 4)
      ..lineTo(center.dx - 16, center.dy + 10)
      ..lineTo(center.dx - 22, center.dy + 4)
      ..close();

    final rightFace = Path()
      ..moveTo(center.dx + 22, center.dy - 10)
      ..lineTo(center.dx + 28, center.dy - 4)
      ..lineTo(center.dx + 28, center.dy + 10)
      ..lineTo(center.dx + 22, center.dy + 4)
      ..close();

    canvas.drawPath(topFace, Paint()..color = const Color(0xFFF0F4F8));
    canvas.drawPath(leftFace, Paint()..color = const Color(0xFFE2E8F0));
    canvas.drawPath(rightFace, Paint()..color = const Color(0xFFCBD5E1));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
