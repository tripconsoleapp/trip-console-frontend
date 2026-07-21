import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/ksrtc_bus.dart';
import '../../providers/ksrtc_booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Browsable KSRTC fleet listing — District-to-District vs Interstate tabs,
/// each with its own bus-class taxonomy. Selecting a bus starts the admin
/// verification layer before the trip can continue.
class KsrtcBusListScreen extends StatefulWidget {
  const KsrtcBusListScreen({super.key});

  static const _buses = [
    KsrtcBus(name: 'Super Fast Premium', category: KsrtcBusCategory.districtToDistrict, busType: 'Non-AC · Seater', estimatedFare: 14200),
    KsrtcBus(name: 'Minnal Super Deluxe Air Bus', category: KsrtcBusCategory.districtToDistrict, busType: 'AC · Seater', estimatedFare: 18900, badge: 'POPULAR'),
    KsrtcBus(name: 'Super Deluxe Air Bus', category: KsrtcBusCategory.districtToDistrict, busType: 'AC · Seater', estimatedFare: 17400),
    KsrtcBus(name: 'Super Fast', category: KsrtcBusCategory.districtToDistrict, busType: 'Non-AC · Seater', estimatedFare: 12800),
    KsrtcBus(name: 'Lower Floor AC', category: KsrtcBusCategory.districtToDistrict, busType: 'AC · Low Floor', estimatedFare: 16500),
    KsrtcBus(name: 'Fast Passenger', category: KsrtcBusCategory.districtToDistrict, busType: 'Non-AC · Seater', estimatedFare: 10900),
    KsrtcBus(name: 'AC Seater Cum Sleeper', category: KsrtcBusCategory.interstate, busType: 'AC · Seater cum Sleeper', estimatedFare: 32000),
    KsrtcBus(name: 'AC Seater', category: KsrtcBusCategory.interstate, busType: 'AC · Seater', estimatedFare: 24500),
    KsrtcBus(name: 'AC Seater — Standard', category: KsrtcBusCategory.interstate, busType: 'AC · Seater · Standard', estimatedFare: 21800),
    KsrtcBus(name: 'Swift-Hybrid AC Seater Cum Sleeper', category: KsrtcBusCategory.interstate, busType: 'AC · Seater cum Sleeper', estimatedFare: 35500, badge: 'POPULAR'),
    KsrtcBus(name: 'Super Deluxe Air Bus (Swift-Hybrid)', category: KsrtcBusCategory.interstate, busType: 'AC · Seater cum Sleeper', estimatedFare: 34200),
    KsrtcBus(name: 'AC Seater Volvo Multi Axle', category: KsrtcBusCategory.interstate, busType: 'AC · Seater · Multi Axle', estimatedFare: 41000),
    KsrtcBus(name: 'AC Sleeper Multi Axle Volvo SLX', category: KsrtcBusCategory.interstate, busType: 'AC · Sleeper · Multi Axle', estimatedFare: 48500),
  ];

  @override
  State<KsrtcBusListScreen> createState() => _KsrtcBusListScreenState();
}

class _KsrtcBusListScreenState extends State<KsrtcBusListScreen> {
  @override
  Widget build(BuildContext context) {
    final booking = context.watch<KsrtcBookingProvider>();
    final buses = KsrtcBusListScreen._buses.where((b) => b.category == booking.category).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(KsrtcBusListStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_alt_rounded, size: 14, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text('${booking.totalPassengers} ${KsrtcBusListStrings.passengersSuffix}', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(8)),
                    child: Text('${booking.fromLocation} → ${booking.toLocation}', style: AppTextStyles.bodySm().copyWith(fontSize: 11)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: _CategoryTab(
                        label: KsrtcBusListStrings.districtToDistrict,
                        selected: booking.category == KsrtcBusCategory.districtToDistrict,
                        onTap: () => booking.selectCategory(KsrtcBusCategory.districtToDistrict),
                      ),
                    ),
                    Expanded(
                      child: _CategoryTab(
                        label: KsrtcBusListStrings.interstate,
                        selected: booking.category == KsrtcBusCategory.interstate,
                        onTap: () => booking.selectCategory(KsrtcBusCategory.interstate),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: buses.length,
                itemBuilder: (context, index) => _BusTile(
                  bus: buses[index],
                  onTap: () {
                    booking.selectBus(buses[index]);
                    context.push(AppRouter.bookingSubmitted);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: selected ? AppColors.accentOrange : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _BusTile extends StatelessWidget {
  const _BusTile({required this.bus, required this.onTap});

  final KsrtcBus bus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E2E2))),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.directions_bus_filled_rounded, size: 20, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(bus.name.toUpperCase(), style: AppTextStyles.bodySm(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w700, fontSize: 12))),
                      if (bus.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text(bus.badge!, style: AppTextStyles.labelCaps(color: AppColors.accentOrange).copyWith(fontSize: 8)),
                        ),
                    ],
                  ),
                  Text(bus.busType, style: AppTextStyles.bodySm().copyWith(fontSize: 12)),
                  const SizedBox(height: 2),
                  Text('₹${bus.estimatedFare} est.', style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }
}
