import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/tab_widget.dart';
import 'printable_page.dart';

class PrintablesPage extends StatelessWidget {
  const PrintablesPage({super.key});

  static const routePath = '/PrintablesPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Printables'),
      body: TabWidget(
        titles: const [
          'Gift cards',
          'Calendars',
          'Planners',
        ],
        pages: [
          Text('1'),
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              _Calendar(asset: Assets.calendar1),
              _Calendar(asset: Assets.calendar2),
              _Calendar(asset: Assets.calendar3),
              _Calendar(asset: Assets.calendar4),
              _Calendar(asset: Assets.calendar5),
              _Calendar(asset: Assets.calendar6),
            ],
          ),
          Text('3'),
        ],
      ),
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Button(
        onPressed: () {
          context.push(
            PrintablePage.routePath,
            extra: asset,
          );
        },
        child: ImageWidget(
          asset,
          cacheWidth: 1000,
        ),
      ),
    );
  }
}
