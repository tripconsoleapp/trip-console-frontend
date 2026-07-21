import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// A caps-label above a rounded, filled text field — the standard form
/// field pattern used throughout the app. Set [obscurable] for password
/// fields: input starts hidden and a suffix eye icon toggles visibility.
class LabeledTextField extends StatefulWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.trailing,
    this.keyboardType,
    this.obscurable = false,
    this.prefixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final bool obscurable;
  final IconData? prefixIcon;

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late bool _obscured = widget.obscurable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: AppTextStyles.labelCaps()),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscured,
          style: AppTextStyles.bodyLg(color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
            filled: true,
            fillColor: const Color(0xFFF5F3F3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20, color: AppColors.textGrey)
                : null,
            suffixIcon: widget.obscurable
                ? IconButton(
                    icon: Icon(
                      _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
