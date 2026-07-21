import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/vendor_option.dart';
import '../../providers/new_trip_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Confirmation step between picking a vehicle off a listing and it
/// actually being written into the trip draft — operator info, trip
/// summary, reviews, and a transparent pricing breakdown. Confirming here
/// runs a capacity check; an undersized vehicle bounces to
/// [VehicleCapacityMismatchScreen] instead of confirming.
class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({super.key, required this.option});

  final VendorOption option;

  void _confirm(BuildContext context) {
    final draft = context.read<NewTripProvider>();
    if (option.seatCapacity != null && option.seatCapacity! < draft.totalParticipants) {
      context.push(AppRouter.vehicleCapacityMismatch, extra: option);
      return;
    }
    draft.setVehicle(option);
    context.go(AppRouter.tripServices);
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<NewTripProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(option.name, style: AppTextStyles.h3(color: AppColors.textDark)),
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
                onPressed: () => _confirm(context),
                child: Text(VehicleDetailStrings.confirmSelection, style: AppTextStyles.button()),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.accentOrange.withValues(alpha: 0.1),
                child: Text(
                  option.name.substring(0, option.name.length < 2 ? option.name.length : 2).toUpperCase(),
                  style: AppTextStyles.h3(color: AppColors.accentOrange),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.name, style: AppTextStyles.h3(color: AppColors.textDark)),
                    if (option.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.accentOrange),
                          Text('${option.rating} · ${option.tripsCount} trips', style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: const [
              _VerifiedBadge(label: 'GST Registered'),
              _VerifiedBadge(label: 'Insurance Verified'),
              _VerifiedBadge(label: '24/7 Support'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (option.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(option.badge!, style: AppTextStyles.labelCaps(color: AppColors.primaryGreen).copyWith(fontSize: 9)),
                      ),
                    Text('₹${option.price}/trip', style: AppTextStyles.h3(color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(option.subtitle, style: AppTextStyles.bodySm()),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                  onPressed: () => _showPricingDetails(context, option),
                  child: Text(
                    '${VehicleDetailStrings.viewPricingDetails} →',
                    style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(VehicleDetailStrings.operatorInfo, style: AppTextStyles.labelCaps()),
          const SizedBox(height: 8),
          _InfoRow(label: VehicleDetailStrings.fleetSize, value: '12 Vehicles'),
          _InfoRow(label: VehicleDetailStrings.baseLocation, value: 'Kochi, Kerala'),
          const SizedBox(height: 8),
          Text(VehicleDetailStrings.contactNote, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
          const SizedBox(height: 20),
          Text(VehicleDetailStrings.tripSummary, style: AppTextStyles.labelCaps()),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Route',
            value: draft.stops.isEmpty ? draft.startingLocationName : '${draft.startingLocationName} → ${draft.stops.first.name}',
          ),
          _InfoRow(label: 'Est. Time', value: draft.stops.isEmpty ? '—' : draft.stops.first.etaFromPrevious),
          _InfoRow(label: 'Passengers', value: '${draft.totalParticipants}'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(VehicleDetailStrings.reviews, style: AppTextStyles.h3(color: AppColors.textDark)),
              TextButton(
                onPressed: () {},
                child: Text(VehicleDetailStrings.viewAll, style: AppTextStyles.bodySm(color: AppColors.accentOrange)),
              ),
            ],
          ),
          if (option.rating != null) ...[
            Row(
              children: [
                Text('${option.rating}', style: AppTextStyles.h2(color: AppColors.textDark)),
                const SizedBox(width: 8),
                const Icon(Icons.star_rounded, color: AppColors.accentOrange),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const _ReviewTile(name: 'Rahul M.', timeAgo: '2 weeks ago', body: 'Clean and professional driver. The route was handled very safely and we reached Munnar on time. Highly recommended.'),
          const _ReviewTile(name: 'Sneha P.', timeAgo: '1 month ago', body: 'Great experience. The air conditioning was working perfectly and the driver was helpful with the luggage.'),
        ],
      ),
    );
  }
}

void _showPricingDetails(BuildContext context, VendorOption option) {
  final baseFare = (option.price * 0.7).round();
  final driverAllowance = (option.price * 0.2).round();
  final nightHalt = option.price - baseFare - driverAllowance;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E2E2), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text(VehicleDetailStrings.pricingDetailsTitle, style: AppTextStyles.h3(color: AppColors.textDark)),
          const SizedBox(height: 16),
          _PricingRow(label: VehicleDetailStrings.baseFare, value: '₹$baseFare'),
          _PricingRow(label: VehicleDetailStrings.driverAllowance, value: '₹$driverAllowance'),
          _PricingRow(label: VehicleDetailStrings.nightHaltCharge, value: '₹$nightHalt'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(VehicleDetailStrings.tollParking, style: AppTextStyles.bodySm(color: AppColors.textDark)),
                Text('Excluded', style: AppTextStyles.bodySm(color: AppColors.textGrey)),
              ],
            ),
          ),
          Text(VehicleDetailStrings.tollParkingNote, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
          const Divider(color: Color(0xFFE2E2E2), height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(VehicleDetailStrings.total, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700)),
              Text('₹${option.price}', style: AppTextStyles.h3(color: AppColors.accentOrange)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(VehicleDetailStrings.close),
            ),
          ),
        ],
      ),
    ),
  );
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.primaryGreen),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.bodySm(color: AppColors.primaryGreen).copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm()),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm(color: AppColors.textDark)),
          Text(value, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.name, required this.timeAgo, required this.body});

  final String name;
  final String timeAgo;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: AppColors.mintGreen.withValues(alpha: 0.4), child: Text(name[0], style: AppTextStyles.bodySm(color: AppColors.primaryGreen))),
              const SizedBox(width: 8),
              Text(name, style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              Text(timeAgo, style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Text(body, style: AppTextStyles.bodySm()),
        ],
      ),
    );
  }
}
