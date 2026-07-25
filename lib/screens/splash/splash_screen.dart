import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/widgets/wave_painter.dart';
import 'package:go_router/go_router.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:worksync_ai/services/local_storage_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (!mounted) return;

      final isCompleted =
      await LocalStorageService.isOnboardingCompleted();

      if (!mounted) return;

      if (!isCompleted) {
        context.go(AppRoutes.onboarding);
        return;
      }

      final currentUser = ref.read(authRepositoryProvider).currentUser;
      if (currentUser != null) {
        context.go(AppRoutes.dashboard);
      } else {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---------- LAYER 1: Wavy background ----------
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: screenHeight * 0.28,
                width: double.infinity,
                child: CustomPaint(painter: WavePainter()),
              ),
            ),
          ),

          // ---------- LAYER 2: Logo + Tagline (center) ----------
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/logo_light.png',
                        width: 210,
                        height: 210,
                      ),
                      const SizedBox(height: 20),
                      const _Tagline(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ---------- LAYER 3: Loading indicator (bottom) ----------
          Positioned(
            left: 0,
            right: 0,
            bottom: 95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1055DC)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
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

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 5,
      color: Color(0xFF2D3142),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('PLAN', style: style),
        _dot(const Color(0xFF0C4FD4)),
        const Text('TRACK', style: style),
        _dot(const Color(0xFF13CD82)),
        const Text('ACHIEVE', style: style),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}