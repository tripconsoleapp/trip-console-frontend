import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

/// Top bar shared by every trip-creation wizard screen: close button,
/// "New Trip" title, and a "Save Draft" action.
class WizardHeader extends StatelessWidget implements PreferredSizeWidget {
  const WizardHeader({super.key, this.onClose, this.onSaveDraft});

  final VoidCallback? onClose;
  final VoidCallback? onSaveDraft;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.textDark),
        onPressed: onClose ?? () => Navigator.of(context).maybePop(),
      ),
      title: Text(WizardStrings.newTrip, style: AppTextStyles.h3(color: AppColors.textDark)),
      centerTitle: false,
      actions: [
        TextButton(
          onPressed: onSaveDraft,
          child: Text(
            WizardStrings.saveDraft,
            style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
