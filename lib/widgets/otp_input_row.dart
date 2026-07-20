import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';

/// Row of individual single-digit boxes for OTP entry, with auto-advance
/// on input and auto-retreat on backspace. Reused wherever the design
/// calls for a code/PIN entry (OTP verification here; the same pattern
/// appears on other confirmation flows in the file).
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({
    super.key,
    required this.length,
    required this.onChanged,
    this.boxSize = 64,
    this.gap = 16,
  });

  final int length;
  final double boxSize;
  final double gap;
  final ValueChanged<String> onChanged;

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _emitChange() {
    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _emitChange();
  }

  void _onKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _emitChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index == widget.length - 1 ? 0 : widget.gap),
          child: KeyboardListener(
            focusNode: FocusNode(skipTraversal: true),
            onKeyEvent: (event) => _onKey(index, event),
            child: SizedBox(
              width: widget.boxSize,
              height: widget.boxSize,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                onChanged: (value) => _onDigitChanged(index, value),
                style: const TextStyle(fontSize: 16, color: AppColors.textDark),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2BFB3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2BFB3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.accentOrange, width: 2),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
