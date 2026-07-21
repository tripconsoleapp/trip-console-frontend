import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/payment_args.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Brief spinner shown while a payment "processes", then hands off to the
/// success result screen.
class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key, required this.args});

  final PaymentArgs args;

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) context.go(AppRouter.paymentResult, extra: widget.args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.lock_outline_rounded, size: 32, color: AppColors.accentOrange),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(strokeWidth: 3, color: AppColors.accentOrange),
                const SizedBox(height: 20),
                Text(PaymentProcessingStrings.title, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(PaymentProcessingStrings.body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(PaymentProcessingStrings.securityNote, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
