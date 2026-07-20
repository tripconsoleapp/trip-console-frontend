import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/full_bleed_photo_background.dart';
import '../../widgets/page_indicator_dots.dart';

/// Two-slide onboarding carousel shown after the splash screen.
///
/// Note: the source Figma file's page-indicator dots were designed for a
/// 3-slide carousel, but only 2 slides ("Plan Your Escape" and "Book Your
/// Journey") exist in the file — the first slide was never designed. This
/// screen is built as an honest 2-page carousel (dots reflect the real page
/// count) rather than fabricating a third slide.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _pageCount = 2;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    context.go(AppRouter.getStarted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _PlanYourEscapeSlide(
            currentPage: _currentPage,
            pageCount: _pageCount,
            onNext: () => _goToPage(1),
            onSkip: _finishOnboarding,
          ),
          _BookYourJourneySlide(
            currentPage: _currentPage,
            pageCount: _pageCount,
            onGetStarted: _finishOnboarding,
          ),
        ],
      ),
    );
  }
}

class _PlanYourEscapeSlide extends StatelessWidget {
  const _PlanYourEscapeSlide({
    required this.currentPage,
    required this.pageCount,
    required this.onNext,
    required this.onSkip,
  });

  final int currentPage;
  final int pageCount;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const FullBleedPhotoBackground(
          imageAsset: 'assets/images/onboarding_mountain.png',
          gradientColors: [
            Color(0x33000000),
            Color(0x00000000),
            Color(0x99000000),
          ],
          gradientStops: [0, 0.5, 1],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _GlassBackButton(
                    onTap: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    OnboardingStrings.slide1Headline,
                    style: AppTextStyles.h1(color: AppColors.backgroundWhite),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  OnboardingStrings.slide1Body,
                  style: AppTextStyles.bodyLg(
                    color: AppColors.backgroundWhite.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PageIndicatorDots(
                    count: pageCount,
                    activeIndex: currentPage,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onNext,
                    child: const Text(OnboardingStrings.next),
                  ),
                ),
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    OnboardingStrings.skip,
                    style: AppTextStyles.bodyLg(
                      color: AppColors.backgroundWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BookYourJourneySlide extends StatelessWidget {
  const _BookYourJourneySlide({
    required this.currentPage,
    required this.pageCount,
    required this.onGetStarted,
  });

  final int currentPage;
  final int pageCount;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const FullBleedPhotoBackground(
          imageAsset: 'assets/images/onboarding_adventure.png',
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          gradientColors: [
            Color(0x1A1B1C1C),
            Color(0x661B1C1C),
            Color(0xF21B1C1C),
          ],
          gradientStops: [0, 0.4, 1],
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              width: 6,
              height: 128,
              decoration: BoxDecoration(
                color: AppColors.accentOrangeDark.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(9999)),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  SplashStrings.appName,
                  style: AppTextStyles.h3(color: AppColors.backgroundWhite),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrangeDark,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    OnboardingStrings.slide2Badge,
                    style: AppTextStyles.labelCaps(color: AppColors.backgroundWhite),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  OnboardingStrings.slide2Headline,
                  style: AppTextStyles.h1(color: AppColors.backgroundWhite).copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 320,
                  child: Text(
                    OnboardingStrings.slide2Body,
                    style: AppTextStyles.bodyLg(
                      color: AppColors.backgroundWhite.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const _AvatarStack(),
                    const SizedBox(width: 20),
                    Text(
                      OnboardingStrings.socialProof,
                      style: AppTextStyles.bodySm(color: AppColors.backgroundWhite)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: onGetStarted,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(OnboardingStrings.getStarted, style: AppTextStyles.button(color: AppColors.textDark)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textDark),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageIndicatorDots(
                      count: pageCount,
                      activeIndex: currentPage,
                      dotSize: 8,
                      activeWidth: 32,
                    ),
                    Text(
                      OnboardingStrings.aboutUs,
                      style: AppTextStyles.labelCaps(
                        color: AppColors.backgroundWhite.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  static const _assets = [
    'assets/images/avatar1.jpg',
    'assets/images/avatar2.jpg',
    'assets/images/avatar3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40 + (_assets.length - 1) * 28,
      height: 40,
      child: Stack(
        children: [
          for (var i = 0; i < _assets.length; i++)
            Positioned(
              left: i * 28,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.backgroundWhite, width: 2),
                  image: DecorationImage(image: AssetImage(_assets[i]), fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: AppColors.backgroundWhite.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.backgroundWhite.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.backgroundWhite, size: 18),
          ),
        ),
      ),
    );
  }
}
