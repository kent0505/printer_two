import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../onboard/pages/printer_model_page.dart';
import 'info_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Unlock(),
        const SizedBox(height: 12),
        const _VipStatus(),
        const SizedBox(height: 12),
        const _PrinterModel(),
        const SizedBox(height: 12),
        _BG(
          children: [
            _Tile(
              title: 'Share App',
              asset: Assets.s3,
              onPressed: () {},
            ),
            const _Divider(),
            _Tile(
              title: 'Contact Us',
              asset: Assets.s4,
              onPressed: () {},
            ),
            const _Divider(),
            _Tile(
              title: 'FAQ',
              asset: Assets.s5,
              onPressed: () {},
            ),
            const _Divider(),
            _Tile(
              title: 'How to connect a printer? ',
              asset: Assets.s6,
              onPressed: () {
                context.push(InfoPage.routePath);
              },
            ),
            const _Divider(),
            _Tile(
              title: 'Manage Subscription',
              asset: Assets.s7,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        _BG(
          children: [
            _Tile(
              title: 'Terms of Use',
              asset: Assets.s8,
              onPressed: () {},
            ),
            const _Divider(),
            _Tile(
              title: 'Privacy Policy',
              asset: Assets.s9,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _BG extends StatelessWidget {
  const _BG({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xffD5D5D5),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    required this.asset,
    required this.onPressed,
  });

  final String title;
  final String asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            SvgWidget(asset),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: AppFonts.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const SvgWidget(Assets.right),
          ],
        ),
      ),
    );
  }
}

class _Unlock extends StatelessWidget {
  const _Unlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xff013BA1),
            Color(0xff095EF1),
          ],
        ),
      ),
      child: Button(
        onPressed: () {},
        child: const Row(
          children: [
            SvgWidget(Assets.s1),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unlock All Features',
                    style: TextStyle(
                      color: Color(0xffF2F5F8),
                      fontSize: 16,
                      fontFamily: AppFonts.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Print web pages, calendars, photos, and more — effortlessly',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xffF8FCFF),
                      fontSize: 14,
                      fontFamily: AppFonts.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            SvgWidget(
              Assets.right,
              color: Color(0xffF2F5F8),
            ),
          ],
        ),
      ),
    );
  }
}

class _VipStatus extends StatelessWidget {
  const _VipStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          SvgWidget(Assets.s2),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Subscription',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: AppFonts.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Free',
            style: TextStyle(
              color: Color(0xff095EF1),
              fontSize: 16,
              fontFamily: AppFonts.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrinterModel extends StatelessWidget {
  const _PrinterModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Button(
        onPressed: () {
          context.push(
            PrinterModelPage.routePath,
            extra: false,
          );
        },
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: const Color(0xff095EF1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: SvgWidget(
                  Assets.tab1,
                  color: Color(0xffF2F5F8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Printer Model',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: AppFonts.w500,
                ),
              ),
            ),
            const SvgWidget(Assets.right),
          ],
        ),
      ),
    );
  }
}
