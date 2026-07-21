import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';

/// Entry-point chooser for creating a new listing — from scratch, from a
/// reference template, a pilgrimage program, or a standalone service.
class AddNewListingScreen extends StatelessWidget {
  const AddNewListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AddNewListingStrings.title, style: AppTextStyles.h2(color: AppColors.textDark)),
              const SizedBox(height: 24),
              _ListingOptionCard(
                icon: Icons.edit_note_rounded,
                title: AddNewListingStrings.scratchTitle,
                body: AddNewListingStrings.scratchBody,
                onTap: () => context.push(AppRouter.tripBasics),
              ),
              const SizedBox(height: 12),
              _ListingOptionCard(
                icon: Icons.map_rounded,
                title: AddNewListingStrings.templateTitle,
                body: AddNewListingStrings.templateBody,
                onTap: () => context.push(AppRouter.templates),
              ),
              const SizedBox(height: 12),
              _ListingOptionCard(
                icon: Icons.groups_rounded,
                title: AddNewListingStrings.pilgrimageTitle,
                body: AddNewListingStrings.pilgrimageBody,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _ListingOptionCard(
                icon: Icons.room_service_rounded,
                title: AddNewListingStrings.singleServiceTitle,
                body: AddNewListingStrings.singleServiceBody,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListingOptionCard extends StatelessWidget {
  const _ListingOptionCard({required this.icon, required this.title, required this.body, required this.onTap});

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E2E2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.accentOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.accentOrange),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLg(color: AppColors.textDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(body, style: AppTextStyles.bodySm()),
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
