enum MemberPaymentStatus { paid, pending, notSent }

/// One participant's share of a pooled KSRTC bus-hire payment — mutable
/// since status changes as reminders are sent / payments are marked.
class KsrtcMemberEntry {
  KsrtcMemberEntry({
    required this.name,
    required this.share,
    this.status = MemberPaymentStatus.notSent,
    this.paidVia,
    this.lastActionLabel,
  });

  final String name;
  final int share;
  MemberPaymentStatus status;
  String? paidVia;
  String? lastActionLabel;
}
