import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/vendor_option.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import 'multi_vehicle_listing_screen.dart';

/// Second step of the vehicle-selection sub-flow — pick a vehicle class,
/// then browse private operators offering that class. Classes whose
/// largest unit can't seat the whole group (Tempo Traveller, Mini Bus)
/// route to [MultiVehicleListingScreen]'s combine-multiple-vehicles flow
/// instead of a single-select listing.
class SelectVehicleTypeScreen extends StatelessWidget {
  const SelectVehicleTypeScreen({super.key});

  static const _types = [
    (
      icon: Icons.airline_seat_flat_rounded,
      title: VehicleTypeStrings.acSleeperBus,
      subtitle: VehicleTypeStrings.acSleeperBusSubtitle,
      multiSelect: false,
      options: [
        VendorOption(name: 'Kerala Travels Pvt Ltd', subtitle: 'AC Sleeper Bus · 52 seats', price: 45000, badge: 'BEST MATCH', rating: 4.8, tripsCount: 127, seatCapacity: 52),
        VendorOption(name: 'Volvo Comfort Lines', subtitle: 'AC Sleeper Bus · 52 seats', price: 48200, rating: 4.6, tripsCount: 98, seatCapacity: 52),
        VendorOption(name: 'Highway Kings Travels', subtitle: 'AC Sleeper Bus · 52 seats', price: 42500, rating: 4.5, tripsCount: 210, seatCapacity: 52),
        VendorOption(name: 'Southern Cross Coaches', subtitle: 'AC Sleeper Bus · 52 seats', price: 39000, rating: 4.3, tripsCount: 140, seatCapacity: 52),
        VendorOption(name: 'Green Meadows Transport', subtitle: 'AC Sleeper Bus · 52 seats', price: 46500, rating: 4.7, tripsCount: 152, seatCapacity: 52),
        VendorOption(name: 'Everest Travel Solutions', subtitle: 'AC Sleeper Bus · 52 seats', price: 44800, rating: 4.4, tripsCount: 77, seatCapacity: 52),
      ],
    ),
    (
      icon: Icons.directions_bus_rounded,
      title: VehicleTypeStrings.nonAcSleeperBus,
      subtitle: VehicleTypeStrings.nonAcSleeperBusSubtitle,
      multiSelect: false,
      options: [
        VendorOption(name: 'Budget Bus Co.', subtitle: 'Non-AC Sleeper Bus · 50 seats', price: 26000, rating: 4.2, tripsCount: 68, seatCapacity: 50),
        VendorOption(name: 'Southern Express Travels', subtitle: 'Non-AC Sleeper Bus · 55 seats', price: 27500, rating: 4.0, tripsCount: 140, seatCapacity: 55),
        VendorOption(name: 'Kerala Travels Pvt Ltd', subtitle: 'Non-AC Sleeper Bus · 48 seats', price: 28800, badge: 'BEST MATCH', rating: 4.5, tripsCount: 127, seatCapacity: 48),
        VendorOption(name: 'Coastal Line Travels', subtitle: 'Non-AC Sleeper Bus · 52 seats', price: 27000, rating: 4.3, tripsCount: 95, seatCapacity: 52),
      ],
    ),
    (
      icon: Icons.airport_shuttle_rounded,
      title: VehicleTypeStrings.tempoTraveller,
      subtitle: VehicleTypeStrings.tempoTravellerSubtitle,
      multiSelect: true,
      options: [
        VendorOption(name: 'Kerala Travels Pvt Ltd', subtitle: '12-seater', price: 18000, rating: 4.8, tripsCount: 127, seatCapacity: 12),
        VendorOption(name: 'City Comfort Tempo', subtitle: '17-seater', price: 22500, rating: 4.5, tripsCount: 74, seatCapacity: 17),
        VendorOption(name: 'Speedway Tempo Services', subtitle: '17-seater', price: 23000, rating: 4.6, tripsCount: 110, seatCapacity: 17),
        VendorOption(name: 'Highland Tourist Cabs', subtitle: '15-seater', price: 20500, rating: 4.3, tripsCount: 66, seatCapacity: 15),
        VendorOption(name: 'Royal Comfort Tempo', subtitle: '17-seater', price: 24000, rating: 4.7, tripsCount: 89, seatCapacity: 17),
      ],
    ),
    (
      icon: Icons.directions_bus_filled_outlined,
      title: VehicleTypeStrings.miniBus,
      subtitle: VehicleTypeStrings.miniBusSubtitle,
      multiSelect: true,
      options: [
        VendorOption(name: 'Kerala Travels Pvt Ltd', subtitle: '20-seater', price: 24500, badge: 'BEST MATCH', rating: 4.8, tripsCount: 127, seatCapacity: 20),
        VendorOption(name: 'Trinity Mini Coaches', subtitle: '30-seater', price: 22000, rating: 4.4, tripsCount: 66, seatCapacity: 30),
        VendorOption(name: 'Green Valley Travels', subtitle: '32-seater', price: 20500, rating: 4.6, tripsCount: 102, seatCapacity: 32),
        VendorOption(name: 'Metro Mini Transport', subtitle: '25-seater', price: 25000, rating: 4.2, tripsCount: 48, seatCapacity: 25),
        VendorOption(name: 'Sunrise Mini Coaches', subtitle: '28-seater', price: 18000, rating: 4.5, tripsCount: 80, seatCapacity: 28),
        VendorOption(name: 'Coastal Mini Travels', subtitle: '33-seater', price: 20000, rating: 4.3, tripsCount: 57, seatCapacity: 33),
      ],
    ),
    (
      icon: Icons.directions_car_rounded,
      title: VehicleTypeStrings.car,
      subtitle: VehicleTypeStrings.carSubtitle,
      multiSelect: false,
      options: [
        VendorOption(name: 'Kerala Travels Pvt Ltd', subtitle: 'Sedan, 4-seater · AC · GPS', price: 3500, badge: 'BEST MATCH', rating: 4.8, tripsCount: 127, seatCapacity: 4),
        VendorOption(name: 'City Cab Services', subtitle: 'Hatchback, 4-seater · AC', price: 2800, rating: 4.5, tripsCount: 95, seatCapacity: 4),
        VendorOption(name: 'Comfort Ride Kerala', subtitle: 'Sedan, 4-seater · AC · USB', price: 3200, rating: 4.4, tripsCount: 60, seatCapacity: 4),
        VendorOption(name: 'Highway Cabs', subtitle: 'Hatchback, 4-seater · AC', price: 2600, rating: 4.4, tripsCount: 40, seatCapacity: 4),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(VehicleTypeStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(VehicleTypeStrings.selectToView, style: AppTextStyles.bodySm()),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _types.length,
                itemBuilder: (context, index) {
                  final type = _types[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        if (type.multiSelect) {
                          context.push(AppRouter.multiVehicleListing, extra: (title: type.title, options: type.options));
                        } else {
                          context.push(
                            AppRouter.vendorListing,
                            extra: (
                              title: type.title,
                              options: type.options,
                              onSelect: (VendorOption option) => context.push(AppRouter.vehicleDetail, extra: option),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E2E2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: Icon(type.icon, color: AppColors.accentOrange),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(type.title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(type.subtitle, style: AppTextStyles.bodySm()),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
                          ],
                        ),
                      ),
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
