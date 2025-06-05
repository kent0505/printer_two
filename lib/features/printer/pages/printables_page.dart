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
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              Row(
                children: [
                  Expanded(
                    child: _Photo(asset: Assets.card1),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _Photo(asset: Assets.card2),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _Photo(asset: Assets.card3),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _Photo(asset: Assets.card4),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _Photo(asset: Assets.card5),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _Photo(asset: Assets.card6),
                  ),
                ],
              ),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              _Photo(asset: Assets.calendar1),
              _Photo(asset: Assets.calendar2),
              _Photo(asset: Assets.calendar3),
              _Photo(asset: Assets.calendar4),
              _Photo(asset: Assets.calendar5),
              _Photo(asset: Assets.calendar6),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              _Photo(asset: Assets.planner1),
              _Photo(asset: Assets.planner2),
              _Photo(asset: Assets.planner3),
              _Photo(asset: Assets.planner4),
              _Photo(asset: Assets.planner5),
              _Photo(asset: Assets.planner6),
            ],
          ),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.asset});

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
          cacheWidth: 500,
        ),
      ),
    );
  }
}
