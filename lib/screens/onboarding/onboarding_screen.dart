import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';
import 'package:worksync_ai/core/routes/app_routes.dart';
import 'package:worksync_ai/services/local_storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _slides = const [
    OnboardingPage(
      image: "assets/images/onboarding1.png",
      title: "Manage Projects Easily",
      description: "Organize all your projects at one place.",
    ),
    OnboardingPage(
      image: "assets/images/onboarding2.png",
      title: "Track Every Task",
      description:
      "Stay organized by tracking every task, setting priorities and monitoring progress.",
    ),
    OnboardingPage(
      image: "assets/images/onboarding3.png",
      title: "AI Powered Workspace",
      description:
      "Boost your productivity with AI assistance and smart project management.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage == _slides.length - 1) {
      _finishOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    // Save onboarding completed
    await LocalStorageService.setOnboardingCompleted();

    if (!mounted) return;

    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Skip button (top-right) ----------
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('Skip', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),

            // ---------- Swipeable slides ----------
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: _slides,
              ),
            ),

            // ---------- Dots indicator ----------
            PageIndicator(pageCount: _slides.length, currentPage: _currentPage),

            const SizedBox(height: 24),

            // ---------- Next / Get Started button ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1055DC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _goToNextPage,
                  child: Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}