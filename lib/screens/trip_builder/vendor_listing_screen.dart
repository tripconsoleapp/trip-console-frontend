import 'package:flutter/material.dart';

import '../../models/vendor_option.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/vendor_option_card.dart';

/// Generic vendor listing — reused for vehicle operators (by type), hotels,
/// restaurants, and activities. Tapping "Select" on a card runs [onSelect]
/// and the caller decides what happens next (write into the trip draft,
/// then usually navigate back to Services).
class VendorListingScreen extends StatelessWidget {
  const VendorListingScreen({super.key, required this.title, required this.options, required this.onSelect});

  final String title;
  final List<VendorOption> options;
  final void Function(VendorOption option) onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: options.length,
          itemBuilder: (context, index) => VendorOptionCard(
            option: options[index],
            onSelect: () => onSelect(options[index]),
          ),
        ),
      ),
    );
  }
}
