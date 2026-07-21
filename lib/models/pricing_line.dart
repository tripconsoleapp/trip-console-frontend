/// One line of a package's cost breakdown (e.g. "Transport — ₹1,200").
class PricingLine {
  const PricingLine({required this.label, required this.amount});

  final String label;
  final String amount;
}
