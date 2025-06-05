import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../home/pages/home_page.dart';
import '../data/onboard_repository.dart';
import 'onboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // context.read<FirebaseBloc>().add(GetFirebaseData());

    Future.delayed(
      const Duration(seconds: 3),
      () {
        _controller.stop();
        if (mounted) {
          if (context.read<OnboardRepository>().isOnboard()) {
            context.go(OnboardPage.routePath);
          } else {
            context.go(HomePage.routePath);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const SvgWidget(Assets.icon),
        ),
      ),
    );
  }
}
