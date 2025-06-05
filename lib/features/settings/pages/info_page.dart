import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/svg_widget.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  static const routePath = '/InfoPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Stage(
            id: 1,
            title: 'Turn on the printer',
          ),
          SvgWidget(Assets.info1),
          SizedBox(height: 32),
          _Stage(
            id: 2,
            title:
                'Press and hold the Wi-Fi or WPS button on the printer for 3-5 seconds until the indicator starts blinking',
          ),
          SvgWidget(Assets.info2),
          SizedBox(height: 32),
          _Stage(
            id: 3,
            title:
                'Press the WPS buttton on the router within 2 minutes after step 2',
          ),
          SvgWidget(Assets.info3),
          SizedBox(height: 32),
          _Stage(
            id: 4,
            title:
                'Wait for the printer to connect (the indicator should stop blinking once connected)',
          ),
          SvgWidget(Assets.info4),
        ],
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: const Color(0xff095EF1),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Center(
            child: Text(
              '$id',
              style: const TextStyle(
                color: Color(0xffF2F5F8),
                fontSize: 16,
                fontFamily: AppFonts.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: AppFonts.w700,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
