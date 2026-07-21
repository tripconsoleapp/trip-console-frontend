import 'package:flutter/material.dart';

import '../models/itinerary_stop.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// One destination row in the Destinations & Route step — stop name,
/// nights, region, and ETA from the previous stop.
class ItineraryStopCard extends StatelessWidget {
  const ItineraryStopCard({super.key, required this.index, required this.stop, this.onEdit, this.onDelete});

  final int index;
  final ItineraryStop stop;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: AppColors.accentOrange, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$index. ${stop.name}',
                  style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  stop.nights == 1 ? '1 Night' : '${stop.nights} Nights',
                  style: AppTextStyles.labelCaps().copyWith(fontSize: 10),
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textGrey),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(left: 8),
                ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(left: 4),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(stop.region, style: AppTextStyles.bodySm()),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.directions_car_rounded, size: 14, color: AppColors.accentOrange),
              const SizedBox(width: 4),
              Text(
                'ETA ${stop.etaFromPrevious}',
                style: AppTextStyles.bodySm(color: AppColors.accentOrange).copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
