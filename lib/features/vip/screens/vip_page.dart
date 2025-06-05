import 'package:flutter/material.dart';

import 'vip_sheet.dart';

class VipPage extends StatelessWidget {
  const VipPage({super.key, required this.identifier});

  static const routePath = '/VipPage';

  final String identifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VipSheet(identifier: identifier),
    );
  }
}
