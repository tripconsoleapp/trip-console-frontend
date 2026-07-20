import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/trip_type.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/wizard_header.dart';
import '../../widgets/wizard_step_indicator.dart';
import '../../widgets/wizard_bottom_bar.dart';
import '../../widgets/labeled_text_field.dart';
import '../../widgets/selectable_chip.dart';

/// Step 1 of the trip-creation wizard — trip name, type, optional
/// companion, and emergency contact.
class TripBasicsScreen extends StatefulWidget {
  const TripBasicsScreen({super.key});

  @override
  State<TripBasicsScreen> createState() => _TripBasicsScreenState();
}

class _TripBasicsScreenState extends State<TripBasicsScreen> {
  late final TextEditingController _tripNameController;
  late final TextEditingController _companionNameController;
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;

  static const _maxTripNameLength = 60;

  @override
  void initState() {
    super.initState();
    final draft = context.read<NewTripProvider>();
    _tripNameController = TextEditingController(text: draft.tripName)
      ..addListener(() => draft.setTripName(_tripNameController.text));
    _companionNameController = TextEditingController(text: draft.companionName)
      ..addListener(() => draft.setCompanionName(_companionNameController.text));
    _emergencyNameController = TextEditingController(text: draft.emergencyContactName)
      ..addListener(() => draft.setEmergencyContactName(_emergencyNameController.text));
    _emergencyPhoneController = TextEditingController(text: draft.emergencyContactPhone)
      ..addListener(() => draft.setEmergencyContactPhone(_emergencyPhoneController.text));
  }

  @override
  void dispose() {
    _tripNameController.dispose();
    _companionNameController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const WizardHeader(),
      bottomNavigationBar: WizardBottomBar(
        stepNumber: 1,
        totalSteps: 5,
        stepTitle: 'Trip Basics',
        nextLabel: TripBasicsStrings.nextDestinations,
        onNext: () => context.push(AppRouter.tripDestinations),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardStepIndicator(currentStep: 1, labels: WizardStrings.stepLabels),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Trip ID: ${draft.tripId.isEmpty ? "TC-DRAFT" : draft.tripId} · Version v1 · Status: Draft',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            LabeledTextField(
              label: TripBasicsStrings.tripName,
              controller: _tripNameController,
              hintText: TripBasicsStrings.tripNameHint,
              trailing: Text(
                '${_tripNameController.text.length}/$_maxTripNameLength',
                style: AppTextStyles.labelCaps(),
              ),
            ),
            const SizedBox(height: 20),
            Text(TripBasicsStrings.tripType, style: AppTextStyles.labelCaps()),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.6,
              children: TripType.values.map((type) {
                return SelectableChip(
                  label: type.label,
                  selected: draft.tripType == type,
                  onTap: () => draft.setTripType(type),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE2E2E2)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TripBasicsStrings.travelingWithCompanion,
                  style: AppTextStyles.bodyLg(color: AppColors.textDark),
                ),
                Switch(
                  value: draft.travelingWithCompanion,
                  activeThumbColor: AppColors.accentOrange,
                  onChanged: draft.setTravelingWithCompanion,
                ),
              ],
            ),
            if (draft.travelingWithCompanion) ...[
              const SizedBox(height: 12),
              LabeledTextField(
                label: TripBasicsStrings.companionName,
                controller: _companionNameController,
                hintText: TripBasicsStrings.companionNameHint,
              ),
            ],
            const SizedBox(height: 20),
            Text(
              TripBasicsStrings.emergencyContact,
              style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            LabeledTextField(
              label: TripBasicsStrings.name,
              controller: _emergencyNameController,
              hintText: TripBasicsStrings.contactNameHint,
            ),
            const SizedBox(height: 12),
            LabeledTextField(
              label: TripBasicsStrings.phoneNumber,
              controller: _emergencyPhoneController,
              hintText: TripBasicsStrings.phoneHint,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/onboarding_mountain.png',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text(
                      TripBasicsStrings.inspirationCaption,
                      style: AppTextStyles.bodySm(color: AppColors.backgroundWhite).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
