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
import '../../widgets/counter_field.dart';
import '../../widgets/stat_tile.dart';

/// Step 3 of the trip-creation wizard — confirms headcount (reusing the
/// counts captured on Basics), then shows a live vehicle-capacity check,
/// student-to-staff ratio, and a preliminary cost estimate. The definitive
/// cost comes later, once real vendors are chosen on the Services step.
class TripParticipantsScreen extends StatefulWidget {
  const TripParticipantsScreen({super.key});

  @override
  State<TripParticipantsScreen> createState() => _TripParticipantsScreenState();
}

class _TripParticipantsScreenState extends State<TripParticipantsScreen> {
  bool _showValidation = false;

  // Mock baseline used only for the early cost preview shown here — the
  // real total is computed from actual vendor prices on the Services step.
  static const double _costPerNightPerHead = 742.75;

  int _recommendedCapacity(int total) {
    if (total <= 4) return 4;
    if (total <= 12) return 12;
    if (total <= 17) return 17;
    if (total <= 32) return 32;
    return 52;
  }

  void _handleNext(NewTripProvider draft) {
    if (draft.costBearingCount <= 0) {
      setState(() => _showValidation = true);
      return;
    }
    context.push(AppRouter.tripServices);
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final hasError = _showValidation && draft.costBearingCount <= 0;
    final capacity = _recommendedCapacity(draft.totalParticipants);
    final spare = capacity - draft.totalParticipants;
    final estPerHead = (_costPerNightPerHead * draft.totalNights).round();
    final estTotal = estPerHead * draft.costBearingCount;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const WizardHeader(),
      bottomNavigationBar: WizardBottomBar(
        stepNumber: 3,
        totalSteps: 5,
        stepTitle: 'Participants',
        nextLabel: ParticipantsStrings.nextServices,
        onNext: () => _handleNext(draft),
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardStepIndicator(currentStep: 3, labels: WizardStrings.stepLabels),
            const SizedBox(height: 20),
            if (hasError) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Please fix the errors below to continue', style: AppTextStyles.bodySm(color: AppColors.error))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(ParticipantsStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(ParticipantsStrings.subtitle, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            _ParticipantCounters(draft: draft, showError: hasError),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_bus_filled_rounded, size: 18, color: AppColors.primaryGreen),
                      const SizedBox(width: 8),
                      Text(ParticipantsStrings.vehicleCapacity, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Text('${draft.totalParticipants}/$capacity', style: AppTextStyles.h3(color: AppColors.textDark)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  spare >= 0 ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                  size: 16,
                  color: spare >= 0 ? AppColors.primaryGreen : AppColors.error,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    spare >= 0
                        ? '${ParticipantsStrings.fitsComfortably} ($spare ${ParticipantsStrings.seatsSpareSuffix})'
                        : ParticipantsStrings.overCapacity,
                    style: AppTextStyles.bodySm(color: spare >= 0 ? AppColors.primaryGreen : AppColors.error),
                  ),
                ),
              ],
            ),
            if (draft.tripType == TripType.college || draft.tripType == TripType.school) ...[
              const SizedBox(height: 20),
              _RatioCard(students: draft.studentsCount, staff: draft.staffCount),
            ],
            const SizedBox(height: 24),
            Text(ParticipantsStrings.summaryPreview, style: AppTextStyles.h3(color: AppColors.textDark)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatTile(label: ParticipantsStrings.totalHeads, value: '${draft.totalParticipants}'),
                      StatTile(label: ParticipantsStrings.estPerStudent, value: '₹$estPerHead'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2E2E2)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ParticipantsStrings.estimatedTotal, style: AppTextStyles.bodyLg(color: AppColors.textDark)),
                      Text('₹$estTotal', style: AppTextStyles.h3(color: AppColors.accentOrange)),
                    ],
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

class _RatioCard extends StatelessWidget {
  const _RatioCard({required this.students, required this.staff});

  final int students;
  final int staff;

  @override
  Widget build(BuildContext context) {
    final ratio = staff == 0 ? null : students / staff;
    final isOptimal = ratio != null && ratio <= 15;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isOptimal ? AppColors.primaryGreen : AppColors.accentOrange).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.balance_rounded, size: 18, color: isOptimal ? AppColors.primaryGreen : AppColors.accentOrange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${ParticipantsStrings.ratioLabel} ${ratio == null ? '—' : '1:${ratio.toStringAsFixed(1)}'}',
              style: AppTextStyles.bodySm(color: AppColors.textDark),
            ),
          ),
          if (ratio != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (isOptimal ? AppColors.primaryGreen : AppColors.accentOrange).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isOptimal ? ParticipantsStrings.ratioOptimal : ParticipantsStrings.ratioReview,
                style: AppTextStyles.labelCaps(color: isOptimal ? AppColors.primaryGreen : AppColors.accentOrange).copyWith(fontSize: 9),
              ),
            ),
        ],
      ),
    );
  }
}

/// The counter pair shown changes with trip type, but always writes back
/// into the same [NewTripProvider] fields Basics uses — Participants is a
/// confirmation step, not a second, divergent data entry point.
class _ParticipantCounters extends StatelessWidget {
  const _ParticipantCounters({required this.draft, required this.showError});

  final NewTripProvider draft;
  final bool showError;

  static const _quickPicks = [20, 30, 40, 60];

  @override
  Widget build(BuildContext context) {
    switch (draft.tripType) {
      case TripType.college:
      case TripType.school:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CounterField(
              label: '${TripBasicsStrings.students} · ${ParticipantsStrings.costApplicableYes}',
              sublabel: showError && draft.studentsCount == 0 ? ParticipantsStrings.minParticipantsError : TripBasicsStrings.studentsSublabel,
              value: draft.studentsCount,
              onChanged: draft.setStudentsCount,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final quickPick in _quickPicks)
                  ChoiceChip(
                    label: Text('$quickPick'),
                    selected: draft.studentsCount == quickPick,
                    onSelected: (_) => draft.setStudentsCount(quickPick),
                    selectedColor: AppColors.accentOrange.withValues(alpha: 0.15),
                    labelStyle: AppTextStyles.bodySm(
                      color: draft.studentsCount == quickPick ? AppColors.accentOrange : AppColors.textDark,
                    ).copyWith(fontWeight: FontWeight.w600),
                    backgroundColor: const Color(0xFFF5F3F3),
                    side: BorderSide(color: draft.studentsCount == quickPick ? AppColors.accentOrange : Colors.transparent),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            CounterField(
              label: '${TripBasicsStrings.staff} · ${ParticipantsStrings.costApplicableNo}',
              sublabel: TripBasicsStrings.staffSublabel,
              value: draft.staffCount,
              onChanged: draft.setStaffCount,
            ),
          ],
        );

      case TripType.group:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CounterField(
              label: '${TripBasicsStrings.members} · ${ParticipantsStrings.costApplicableYes}',
              sublabel: showError && draft.membersCount == 0 ? ParticipantsStrings.minParticipantsError : TripBasicsStrings.membersSublabel,
              value: draft.membersCount,
              onChanged: draft.setMembersCount,
            ),
            const SizedBox(height: 16),
            CounterField(
              label: '${TripBasicsStrings.companions} · ${ParticipantsStrings.costApplicableNo}',
              sublabel: TripBasicsStrings.companionsSublabel,
              value: draft.companionsCount,
              onChanged: draft.setCompanionsCount,
            ),
          ],
        );

      case TripType.individual:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.person_rounded, size: 18, color: AppColors.textDark),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  draft.travelingWithCompanion ? 'You + 1 companion' : 'Just you',
                  style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
    }
  }
}
