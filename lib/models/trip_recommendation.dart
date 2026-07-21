/// A suggested trip package shown in the Home dashboard's "Recommended for
/// You" carousel.
class TripRecommendation {
  const TripRecommendation({
    required this.imageAsset,
    required this.badgeLabel,
    required this.title,
    required this.priceRange,
    required this.priceUnit,
    required this.templateId,
  });

  final String imageAsset;
  final String badgeLabel;
  final String title;
  final String priceRange;
  final String priceUnit;

  /// Matches a [TripPackage.id] in [TemplatesScreen.mockTemplates] so this
  /// card can open the full Package Detail screen.
  final String templateId;
}
