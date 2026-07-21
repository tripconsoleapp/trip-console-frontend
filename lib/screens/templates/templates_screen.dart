import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/itinerary_day.dart';
import '../../models/pricing_line.dart';
import '../../models/trip_package.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_router.dart';
import '../../widgets/template_card.dart';
import '../../widgets/filter_templates_sheet.dart';

/// Reference-package browse grid — search, filter chips, and a masonry-ish
/// 2-column grid of [TripPackage]s. Tapping a card opens the shared
/// Package/Template Detail screen.
class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  // Shared mock catalog — also referenced by Home's "Recommended for You"
  // and My Trips' empty-state "Browse reference templates" flows.
  static const List<TripPackage> mockTemplates = [
    TripPackage(
      id: 'western-ghats-explorer',
      title: 'Western Ghats Explorer',
      imageAsset: 'assets/images/onboarding_mountain.png',
      badgeLabel: '3D/2N · SCHOOL TRIP',
      priceRange: '₹2,500–3,500',
      priceUnit: '/student',
      category: 'Nature',
      rating: 4.7,
      about: 'A scenic 3-day trail through the Western Ghats, built for school nature-study trips — waterfalls, tea estates and a guided forest walk.',
      route: ['Kochi', 'Munnar', 'Thekkady', 'Kochi'],
      includedServices: ['Transport', 'Accommodation', 'Meals', 'Guide'],
      itinerary: [
        ItineraryDay(dayNumber: 1, title: 'Kochi → Munnar', description: 'Depart early, scenic drive through tea estates, check-in and evening nature walk.'),
        ItineraryDay(dayNumber: 2, title: 'Munnar → Thekkady', description: 'Eravikulam National Park visit, drive to Thekkady, boat ride on Periyar Lake.'),
        ItineraryDay(dayNumber: 3, title: 'Thekkady → Kochi', description: 'Spice plantation tour, return drive to Kochi, drop-off by evening.'),
      ],
      whatsIncluded: ['AC coach transport', 'Twin-sharing accommodation', 'All meals', 'Entry tickets', 'First-aid coordinator'],
      pricingBreakdown: [
        PricingLine(label: 'Transport', amount: '₹900'),
        PricingLine(label: 'Accommodation', amount: '₹1,200'),
        PricingLine(label: 'Meals & Activities', amount: '₹700'),
      ],
      totalPrice: '₹2,800 /student',
    ),
    TripPackage(
      id: 'munnar-hill-station',
      title: 'Munnar Hill Station',
      imageAsset: 'assets/images/onboarding_adventure.png',
      badgeLabel: '10D · SCHOOL TRIP',
      priceRange: '₹800–1,200',
      priceUnit: '/student',
      category: 'Nature',
      rating: 4.5,
      about: 'A relaxed hill-station package covering Munnar\'s tea gardens, viewpoints and a short trek — priced for large school groups.',
      route: ['Kochi', 'Munnar'],
      includedServices: ['Transport', 'Meals', 'Guide'],
      itinerary: [
        ItineraryDay(dayNumber: 1, title: 'Kochi → Munnar', description: 'Drive to Munnar, check-in, evening at Tata Tea Museum.'),
        ItineraryDay(dayNumber: 2, title: 'Munnar sightseeing', description: 'Eravikulam National Park, Mattupetty Dam, Echo Point, return to Kochi.'),
      ],
      whatsIncluded: ['Non-AC coach transport', 'Breakfast & lunch', 'Entry tickets'],
      pricingBreakdown: [
        PricingLine(label: 'Transport', amount: '₹500'),
        PricingLine(label: 'Meals & Activities', amount: '₹400'),
      ],
      totalPrice: '₹900 /student',
    ),
    TripPackage(
      id: 'maldives-escape',
      title: 'Maldives Escape',
      imageAsset: 'assets/images/onboarding_mountain.png',
      badgeLabel: '5D/4N · GROUP TRIP',
      priceRange: '₹45,000–60,000',
      priceUnit: '/person',
      category: 'Adventure',
      rating: 4.9,
      about: 'An overwater-villa getaway with snorkeling, a sunset cruise and a private island day — for small premium groups.',
      route: ['Malé', 'Overwater Resort', 'Malé'],
      includedServices: ['Flights', 'Resort Stay', 'Meals', 'Snorkeling'],
      itinerary: [
        ItineraryDay(dayNumber: 1, title: 'Arrival', description: 'Malé arrival, speedboat transfer to resort, welcome dinner.'),
        ItineraryDay(dayNumber: 2, title: 'Snorkeling excursion', description: 'Guided reef snorkeling, free afternoon, sunset cruise.'),
        ItineraryDay(dayNumber: 3, title: 'Island day', description: 'Private sandbank picnic, water sports.'),
      ],
      whatsIncluded: ['Return flights', 'Overwater villa', 'All meals', 'Snorkeling gear'],
      pricingBreakdown: [
        PricingLine(label: 'Flights', amount: '₹18,000'),
        PricingLine(label: 'Resort Stay', amount: '₹28,000'),
        PricingLine(label: 'Meals & Activities', amount: '₹6,000'),
      ],
      totalPrice: '₹52,000 /person',
    ),
    TripPackage(
      id: 'tokyo-neon-nights',
      title: 'Tokyo Neon Nights',
      imageAsset: 'assets/images/onboarding_adventure.png',
      badgeLabel: '6D/5N · GROUP TRIP',
      priceRange: '₹85,000–1,10,000',
      priceUnit: '/person',
      category: 'Heritage',
      rating: 4.8,
      about: 'City-lights and culture in equal measure — Shibuya crossing, a temple morning, and a bullet-train day trip to Kyoto.',
      route: ['Tokyo', 'Kyoto', 'Tokyo'],
      includedServices: ['Flights', 'Hotel Stay', 'Meals', 'Rail Pass'],
      itinerary: [
        ItineraryDay(dayNumber: 1, title: 'Arrival in Tokyo', description: 'Shinjuku hotel check-in, evening at Shibuya Crossing.'),
        ItineraryDay(dayNumber: 2, title: 'Tokyo temples & markets', description: 'Senso-ji Temple, Tsukiji Outer Market, Akihabara evening.'),
        ItineraryDay(dayNumber: 3, title: 'Day trip to Kyoto', description: 'Bullet train to Kyoto, Fushimi Inari Shrine, return by evening.'),
      ],
      whatsIncluded: ['Return flights', 'Hotel stay', 'Breakfast daily', 'JR rail pass'],
      pricingBreakdown: [
        PricingLine(label: 'Flights', amount: '₹42,000'),
        PricingLine(label: 'Hotel Stay', amount: '₹38,000'),
        PricingLine(label: 'Rail & Activities', amount: '₹15,000'),
      ],
      totalPrice: '₹95,000 /person',
    ),
    TripPackage(
      id: 'classic-home-discovery',
      title: 'Classic Home Discovery',
      imageAsset: 'assets/images/onboarding_mountain.png',
      badgeLabel: '2D/1N · COLLEGE TRIP',
      priceRange: '₹1,800–2,400',
      priceUnit: '/student',
      category: 'Heritage',
      rating: 4.3,
      about: 'A short heritage-focused weekend covering local forts, museums and a craft market — built for college history clubs.',
      route: ['Kochi', 'Fort Kochi'],
      includedServices: ['Transport', 'Guide'],
      itinerary: [
        ItineraryDay(dayNumber: 1, title: 'Fort Kochi walk', description: 'Chinese fishing nets, Dutch Palace, St. Francis Church, sunset at the beach.'),
        ItineraryDay(dayNumber: 2, title: 'Museum & market', description: 'Museum of Kerala History, local craft market, return by afternoon.'),
      ],
      whatsIncluded: ['Non-AC coach transport', 'Local guide', 'Entry tickets'],
      pricingBreakdown: [
        PricingLine(label: 'Transport', amount: '₹800'),
        PricingLine(label: 'Guide & Tickets', amount: '₹600'),
      ],
      totalPrice: '₹1,900 /student',
    ),
    TripPackage(
      id: 'norway-fjord-cabin',
      title: 'Norway Fjord Cabin',
      imageAsset: 'assets/images/onboarding_adventure.png',
      badgeLabel: '7D/6N · GROUP TRIP',
      priceRange: '₹1,20,000–1,50,000',
      priceUnit: '/person',
      category: 'Adventure',
      rating: 4.9,
      about: 'A cabin-stay retreat among the fjords — hiking, a glacier day-trip and a scenic railway ride.',
      route: ['Bergen', 'Fjord Cabin', 'Flåm', 'Bergen'],
      includedServices: ['Flights', 'Cabin Stay', 'Meals', 'Rail Pass'],
      itinerary: [
        ItineraryDay(dayNumber: 1, title: 'Arrival in Bergen', description: 'City walk, funicular to Mount Fløyen for sunset views.'),
        ItineraryDay(dayNumber: 2, title: 'Fjord cabin transfer', description: 'Scenic drive to the fjord cabin, evening hike.'),
        ItineraryDay(dayNumber: 3, title: 'Flåm railway', description: 'Ride the Flåm Railway, glacier viewpoint stop, return to cabin.'),
      ],
      whatsIncluded: ['Return flights', 'Cabin stay', 'Breakfast & dinner', 'Flåm Railway tickets'],
      pricingBreakdown: [
        PricingLine(label: 'Flights', amount: '₹55,000'),
        PricingLine(label: 'Cabin Stay', amount: '₹48,000'),
        PricingLine(label: 'Rail & Meals', amount: '₹22,000'),
      ],
      totalPrice: '₹1,35,000 /person',
    ),
  ];

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String? _categoryFilter;

  static const _categories = ['Nature', 'Adventure', 'Heritage', 'Pilgrimage'];

  List<TripPackage> get _filtered => _categoryFilter == null
      ? TemplatesScreen.mockTemplates
      : TemplatesScreen.mockTemplates.where((t) => t.category == _categoryFilter).toList();

  @override
  Widget build(BuildContext context) {
    final templates = _filtered;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(TemplatesStrings.title, style: AppTextStyles.h3(color: AppColors.textDark)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: AppTextStyles.bodyLg(color: AppColors.textDark),
                      decoration: InputDecoration(
                        hintText: TemplatesStrings.searchHint,
                        hintStyle: AppTextStyles.bodyLg(color: AppColors.textGrey),
                        filled: true,
                        fillColor: const Color(0xFFF5F3F3),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => FilterTemplatesSheet.show(context),
                    style: IconButton.styleFrom(backgroundColor: const Color(0xFFF5F3F3)),
                    icon: const Icon(Icons.tune_rounded, color: AppColors.textDark),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  _CategoryChip(label: 'All', selected: _categoryFilter == null, onTap: () => setState(() => _categoryFilter = null)),
                  for (final category in _categories) ...[
                    const SizedBox(width: 8),
                    _CategoryChip(label: category, selected: _categoryFilter == category, onTap: () => setState(() => _categoryFilter = category)),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('${templates.length} ${TemplatesStrings.templatesFoundSuffix}', style: AppTextStyles.labelCaps()),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: templates.length,
                itemBuilder: (context, index) => TemplateCard(
                  package: templates[index],
                  onTap: () => context.push(AppRouter.packageDetail, extra: (package: templates[index], isTemplate: true)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentOrange : const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodySm(color: selected ? AppColors.backgroundWhite : AppColors.textDark).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
