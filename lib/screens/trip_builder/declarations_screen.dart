import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Final gate before submission — three declarations the organizer must
/// check off. "Submit Trip" stays disabled until all three are confirmed,
/// then opens the last confirmation dialog.
class DeclarationsScreen extends StatefulWidget {
  const DeclarationsScreen({super.key});

  @override
  State<DeclarationsScreen> createState() => _DeclarationsScreenState();
}

class _DeclarationsScreenState extends State<DeclarationsScreen> {
  bool _infoAccuracy = false;
  bool _institutionalApproval = false;
  bool _costReview = false;

  bool get _allConfirmed => _infoAccuracy && _institutionalApproval && _costReview;

  void _showSubmitConfirmation(NewTripProvider draft) {
    showDialog(
      context: context,
      builder: (dialogContext) => _SubmitConfirmationDialog(draft: draft),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(DeclarationsStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_allConfirmed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(DeclarationsStrings.confirmAllPrompt, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        child: Text(DeclarationsStrings.backToEdit),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _allConfirmed ? () => _showSubmitConfirmation(draft) : null,
                        child: Text(DeclarationsStrings.submitTrip, style: AppTextStyles.button()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(DeclarationsStrings.beforeYouSubmit, style: AppTextStyles.h2(color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(DeclarationsStrings.subtitle, style: AppTextStyles.bodySm()),
            const SizedBox(height: 20),
            _DeclarationCard(
              index: 1,
              title: DeclarationsStrings.infoAccuracyTitle,
              body: DeclarationsStrings.infoAccuracyBody,
              value: _infoAccuracy,
              onChanged: (v) => setState(() => _infoAccuracy = v),
            ),
            const SizedBox(height: 12),
            _DeclarationCard(
              index: 2,
              title: DeclarationsStrings.institutionalApprovalTitle,
              body: DeclarationsStrings.institutionalApprovalBody,
              value: _institutionalApproval,
              onChanged: (v) => setState(() => _institutionalApproval = v),
            ),
            const SizedBox(height: 12),
            _DeclarationCard(
              index: 3,
              title: DeclarationsStrings.costReviewTitle,
              body: '${DeclarationsStrings.costReviewBodyPrefix}₹${draft.servicesGrandTotal}${DeclarationsStrings.costReviewBodySuffix}',
              value: _costReview,
              onChanged: (v) => setState(() => _costReview = v),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeclarationCard extends StatelessWidget {
  const _DeclarationCard({required this.index, required this.title, required this.body, required this.value, required this.onChanged});

  final int index;
  final String title;
  final String body;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value ? AppColors.primaryGreen.withValues(alpha: 0.06) : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: value ? AppColors.primaryGreen : const Color(0xFFE2E2E2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? AppColors.primaryGreen : const Color(0xFFE2E2E2),
              ),
              child: value
                  ? const Icon(Icons.check_rounded, size: 14, color: AppColors.backgroundWhite)
                  : Text('$index', style: AppTextStyles.labelCaps(color: AppColors.textGrey).copyWith(fontSize: 11)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(body, style: AppTextStyles.bodySm()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitConfirmationDialog extends StatelessWidget {
  const _SubmitConfirmationDialog({required this.draft});

  final NewTripProvider draft;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 36, color: AppColors.accentOrange),
            const SizedBox(height: 12),
            Text(SubmitConfirmationStrings.title, style: AppTextStyles.h3(color: AppColors.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(SubmitConfirmationStrings.body, style: AppTextStyles.bodySm(), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          draft.tripName.isEmpty ? '(untitled trip)' : draft.tripName,
                          style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(SubmitConfirmationStrings.totalCost, style: AppTextStyles.labelCaps().copyWith(fontSize: 9)),
                          Text('₹${draft.servicesGrandTotal}', style: AppTextStyles.bodyLg(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${draft.totalNights + 1} Days · ${draft.stops.length} destinations', style: AppTextStyles.bodySm()),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _ChecklistRow(label: SubmitConfirmationStrings.budgetAuthenticated),
            const _ChecklistRow(label: SubmitConfirmationStrings.timelineConfirmed),
            const _ChecklistRow(label: SubmitConfirmationStrings.permitsVerified),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.go(AppRouter.submittingTrip),
                child: Text(SubmitConfirmationStrings.yesSubmit, style: AppTextStyles.button()),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(SubmitConfirmationStrings.goBack, style: AppTextStyles.bodySm(color: AppColors.textGrey)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.info_rounded, size: 16, color: AppColors.accentOrange),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark))),
        ],
      ),
    );
  }
}
