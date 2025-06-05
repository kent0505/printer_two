import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../data/onboard_repository.dart';
import 'printer_model_page.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  static const routePath = '/OnboardPage';

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  int index = 0;

  final pageController = PageController();

  void onNext() async {
    if (index == 2) {
      await context.read<OnboardRepository>().removeOnboard();
      if (mounted) {
        context.go(
          PrinterModelPage.routePath,
          extra: true,
        );
      }
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        index++;
      });
    }
  }

  void onPageChanged(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SmoothPageIndicator(
                    effect: const SwapEffect(
                      dotHeight: 6,
                      dotWidth: 80,
                      spacing: 12,
                      dotColor: Color(0xffD5D5D5),
                      activeDotColor: Color(0xff095EF1),
                    ),
                    controller: pageController,
                    count: 3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: const [
                _Phone(asset: Assets.onboard2),
                _Phone(asset: Assets.onboard3),
                Stack(
                  children: [
                    _Phone(asset: Assets.onboard4),
                    Positioned(
                      top: 10,
                      left: 0,
                      child: SvgWidget(Assets.format1),
                    ),
                    Positioned(
                      top: 100,
                      right: 0,
                      child: SvgWidget(Assets.format2),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 20,
                      child: SvgWidget(Assets.format3),
                    ),
                    Positioned(
                      left: 0,
                      bottom: -20,
                      child: SvgWidget(Assets.format4),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 254,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color(0xffF2F5F8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  index == 0
                      ? 'Print Documents in Seconds'
                      : index == 1
                          ? 'Fast & Easy Document Scanner'
                          : 'Quick and Easy PDF Printing',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: AppFonts.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  index == 0
                      ? 'Easily print documents to any printer that supports AirPrint'
                      : index == 1
                          ? 'Easily scan documents using your iPhone or iPad'
                          : 'Manage and Organize Your PDFs with Ease',
                  style: const TextStyle(
                    color: Color(0xff96A0A9),
                    fontSize: 14,
                    fontFamily: AppFonts.w500,
                  ),
                ),
                const Spacer(),
                MainButton(
                  title: 'Continue',
                  onPressed: onNext,
                ),
                const SizedBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 270,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: ImageWidget(Assets.onboard1),
            ),
            Positioned(
              top: 108,
              left: 10,
              right: 10,
              child: Center(
                child: ImageWidget(asset),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
