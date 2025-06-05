import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/txt_field.dart';
import '../../home/pages/home_page.dart';
import '../data/onboard_repository.dart';

class PrinterModelPage extends StatefulWidget {
  const PrinterModelPage({super.key, required this.onboard});

  final bool onboard;

  static const routePath = '/PrinterModelPage';

  @override
  State<PrinterModelPage> createState() => _PrinterModelPageState();
}

class _PrinterModelPageState extends State<PrinterModelPage> {
  final controller = TextEditingController();
  String model = '';

  List<String> models = [
    'HP Envy',
    'HP LaserJet',
    'HP DeskJet',
    'HP OfficeJetPro',
    'Canon MAXIFY',
    'Canon PIXMA',
    'Brother MFC',
    'Other',
  ];

  void onChanged(String value) {
    setState(() {});
  }

  void onModel(String value) {
    setState(() {
      model = value;
      if (value == 'Other') {
        controller.clear();
      } else {
        controller.text = value;
      }
    });
  }

  void onContinue() async {
    await context.read<OnboardRepository>().savePrinterModel(controller.text);
    if (mounted) {
      if (widget.onboard) {
        context.go(HomePage.routePath);
      } else {
        context.pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final value = context.read<OnboardRepository>().getPrinterModel();
    if (models.contains(value)) {
      model = value;
    } else {
      controller.text = value;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.onboard ? null : Appbar(title: 'Printer Model'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 44),
            const Expanded(
              child: Center(
                child: FittedBox(
                  child: SvgWidget(Assets.printer1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Printer Model',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontFamily: AppFonts.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enter your printer model to continue',
              style: TextStyle(
                color: Color(0xff707883),
                fontSize: 14,
                fontFamily: AppFonts.w500,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: List.generate(
                models.length,
                (index) {
                  return _Model(
                    title: models[index],
                    current: model,
                    onPressed: onModel,
                  );
                },
              ),
            ),
            if (model == 'Other') ...[
              const SizedBox(height: 8),
              TxtField(
                controller: controller,
                hintText: 'Type in Your Printer Model',
                onChanged: onChanged,
                onClear: () {
                  controller.clear();
                  onChanged('');
                },
              ),
            ],
            const SizedBox(height: 24),
            MainButton(
              title: 'Continue',
              active: model == 'Other'
                  ? controller.text.isNotEmpty
                  : model.isNotEmpty,
              onPressed: onContinue,
            ),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }
}

class _Model extends StatelessWidget {
  const _Model({
    required this.title,
    required this.current,
    required this.onPressed,
  });

  final String title;
  final String current;
  final void Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    final active = title == current;

    return Button(
      onPressed: active
          ? null
          : () {
              onPressed(title);
            },
      minSize: 40,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: active ? const Color(0xff095EF1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: active ? const Color(0xffF2F5F8) : Colors.black,
                fontSize: 16,
                fontFamily: AppFonts.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
