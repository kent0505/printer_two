import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import 'button.dart';
import 'svg_widget.dart';

class TxtField extends StatelessWidget {
  const TxtField({
    super.key,
    required this.controller,
    required this.hintText,
    this.number = false,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hintText;
  final bool number;
  final bool readOnly;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function() onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : null,
      readOnly: readOnly,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        if (number) FilteringTextInputFormatter.digitsOnly,
      ],
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: AppFonts.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: controller.text.isNotEmpty
            ? Button(
                onPressed: onClear,
                minSize: 24,
                child: const SvgWidget(Assets.close),
              )
            : null,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
