import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/pilgrimage_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/counter_field.dart';

/// Group headcount step — feeds into either the KSRTC Bus Search (KSRTC
/// Collaboration mode) or the generic Select Vehicle Type screen
/// (Self-Managed mode), both of which already exist.
class PilgrimageSeatCountScreen extends StatelessWidget {
  const PilgrimageSeatCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pilgrimage = context.watch<PilgrimageProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(PilgrimageSeatCountStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: pilgrimage.totalPilgrims == 0
                    ? null
                    : () => context.push(pilgrimage.isKsrtcCollaboration ? AppRouter.pilgrimageBusSearch : AppRouter.selectVehicleType),
                child: Text('${PilgrimageSeatCountStrings.continueLabel} →', style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(PilgrimageSeatCountStrings.heading, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text(PilgrimageSeatCountStrings.body, style: AppTextStyles.bodySm()),
            const SizedBox(height: 24),
            CounterField(
              label: PilgrimageSeatCountStrings.pilgrims,
              sublabel: '',
              value: pilgrimage.pilgrimCount,
              onChanged: pilgrimage.setPilgrimCount,
            ),
            const SizedBox(height: 12),
            CounterField(
              label: PilgrimageSeatCountStrings.staff,
              sublabel: '',
              value: pilgrimage.staffCount,
              onChanged: pilgrimage.setStaffCount,
            ),
          ],
        ),
      ),
    );
  }
}
