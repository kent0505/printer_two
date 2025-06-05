import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import 'button.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key, required this.title});

  final String title;

  static void show(
    BuildContext context, {
    required String title,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) {
        return DialogWidget(title: title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 270,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: AppFonts.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Button(
                    title: 'OK',
                    color: const Color(0xff095EF1),
                    fontFamily: AppFonts.w400,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.color,
    required this.fontFamily,
    required this.onPressed,
  });

  final String title;
  final Color color;
  final String fontFamily;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontFamily: fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
