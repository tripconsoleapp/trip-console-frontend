import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/vendor_option.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Vehicle listing for classes too small to seat the whole group in one
/// unit (Tempo Traveller, Mini Bus) — instead of a single "Select", each
/// card gets "+ Add" and the footer tracks seats covered vs. needed until
/// Continue is enabled.
class MultiVehicleListingScreen extends StatefulWidget {
  const MultiVehicleListingScreen({super.key, required this.title, required this.options});

  final String title;
  final List<VendorOption> options;

  @override
  State<MultiVehicleListingScreen> createState() => _MultiVehicleListingScreenState();
}

class _MultiVehicleListingScreenState extends State<MultiVehicleListingScreen> {
  final Set<VendorOption> _selected = {};

  int get _seatsCovered => _selected.fold(0, (sum, v) => sum + (v.seatCapacity ?? 0));

  void _confirm(NewTripProvider draft) {
    final combined = VendorOption(
      name: _selected.map((v) => v.name).join(' + '),
      subtitle: '${_selected.length} vehicle${_selected.length == 1 ? '' : 's'} combined · $_seatsCovered seats',
      price: _selected.fold(0, (sum, v) => sum + v.price),
      seatCapacity: _seatsCovered,
    );
    draft.setVehicle(combined);
    context.go(AppRouter.tripServices);
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();
    final needed = draft.totalParticipants;
    final covered = _seatsCovered;
    final canContinue = covered >= needed && _selected.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(widget.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      bottomNavigationBar: Material(
        color: AppColors.backgroundWhite,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_selected.length} ${MultiVehicleStrings.vehiclesSelected}', style: AppTextStyles.bodySm()),
                    Text(
                      '$covered/$needed ${MultiVehicleStrings.seatsCovered}',
                      style: AppTextStyles.bodySm(color: canContinue ? AppColors.primaryGreen : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: canContinue ? () => _confirm(draft) : null,
                    child: Text(MultiVehicleStrings.continueLabel, style: AppTextStyles.button()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.accentOrange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(MultiVehicleStrings.combineNotice, style: AppTextStyles.bodySm())),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final selected = _selected.contains(option);
                  final insufficientEvenCombined = (option.seatCapacity ?? 0) == 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.accentOrange.withValues(alpha: 0.06) : AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(option.name, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                              if (option.rating != null)
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, size: 12, color: AppColors.accentOrange),
                                    Text('${option.rating} (${option.tripsCount} trips)', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                                  ],
                                ),
                              Text(
                                covered < needed && !selected
                                    ? 'ONLY ${option.seatCapacity} ${MultiVehicleStrings.needSuffix} $needed'
                                    : '${option.seatCapacity}-seater',
                                style: AppTextStyles.bodySm(color: insufficientEvenCombined ? AppColors.error : AppColors.textGrey).copyWith(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text('₹${option.price}/trip', style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: selected ? AppColors.accentOrange : const Color(0xFFE2E2E2)),
                            backgroundColor: selected ? AppColors.accentOrange : null,
                          ),
                          onPressed: () => setState(() => selected ? _selected.remove(option) : _selected.add(option)),
                          child: Text(
                            selected ? '✓' : '+ Add',
                            style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
