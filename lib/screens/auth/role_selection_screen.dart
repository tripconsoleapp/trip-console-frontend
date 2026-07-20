import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/user_role.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/role_card.dart';

/// Step 2 of 3 in onboarding — pick Organizer, Operator, or Field
/// Coordinator. Only Organizer's downstream screens exist today; the
/// other two route to a placeholder until their designs arrive.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selected = UserRole.organizer;

  void _continue() {
    context.push(AppRouter.verifyEmail, extra: _selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(RoleSelectionStrings.stepLabel, style: AppTextStyles.labelCaps().copyWith(fontSize: 10)),
              const SizedBox(height: 20),
              const Icon(Icons.edit_calendar_rounded, color: AppColors.accentOrange, size: 40),
              const SizedBox(height: 16),
              Text(RoleSelectionStrings.title, style: AppTextStyles.h2(color: AppColors.textDark)),
              const SizedBox(height: 8),
              Text(RoleSelectionStrings.subtitle, style: AppTextStyles.bodyLg(color: AppColors.textGrey)),
              const SizedBox(height: 24),
              for (final role in UserRole.values) ...[
                RoleCard(role: role, selected: _selected == role, onTap: () => setState(() => _selected = role)),
                const SizedBox(height: 12),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continue,
                  child: Text('${RoleSelectionStrings.continueAsPrefix}${_selected.label}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
