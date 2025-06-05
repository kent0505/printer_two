import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  static const routePath = '/EmailPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Email'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Title(
            title: '1. Open Your Email',
            description: 'Find an email with a file you’d like to print',
          ),
          const Row(
            children: [
              ImageWidget(
                Assets.email1,
                height: 64,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _Title(
            title: '2. Find Doc & Tap',
            description:
                'Scroll down the email and tap the attached document to open it',
          ),
          const ImageWidget(Assets.email2),
          const SizedBox(height: 16),
          const _Title(
            title: '3. Share Your Doc',
            description: 'Tap the icon to open the sharing menu',
          ),
          const ImageWidget(Assets.email3),
          const SizedBox(height: 16),
          const _Title(
            title: '4. Send & Print',
            description:
                'Select “Copy to Smart Printer” to open your file in the app and print it',
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: const SvgWidget(Assets.logo),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Smart Printer',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontFamily: AppFonts.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                height: 34,
                width: 246,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 16),
                    Text(
                      'Copy to “Smart Printer”',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    Spacer(),
                    SvgWidget(
                      Assets.copy2,
                      height: 20,
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: AppFonts.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xff96A0A9),
            fontSize: 14,
            fontFamily: AppFonts.w500,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
