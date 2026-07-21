import 'package:flutter/foundation.dart';

import '../models/ksrtc_bus.dart';
import '../models/ksrtc_member_entry.dart';

/// Drives the full KSRTC (Kerala State Road Transport Corporation) bus
/// booking pipeline — bus selection, admin verification, booking
/// confirmation, pooled member-payment collection, transfer to KSRTC, and
/// the e-ticket. Deliberately self-contained (own trip name/route/
/// passenger fields, settable) rather than reading [NewTripProvider]
/// directly, so it can be entered both from the main trip wizard's
/// Transport Selection step and from the standalone Pilgrimage Console.
class KsrtcBookingProvider extends ChangeNotifier {
  String tripName = 'Munnar School Excursion';
  String fromLocation = 'Kochi';
  String toLocation = 'Munnar';
  DateTime travelDate = DateTime.now().add(const Duration(days: 21));
  int totalPassengers = 46;

  static const int serviceFeeFlat = 600;

  KsrtcBusCategory category = KsrtcBusCategory.districtToDistrict;
  KsrtcBus? selectedBus;
  bool adminVerified = false;
  String? bookingReference;

  bool includeStaffInSplit = true;
  int splitMemberCount = 42;
  String collectionMethod = 'Share UPI Link';
  final List<KsrtcMemberEntry> members = [];
  bool transferComplete = false;
  String? transferTransactionId;

  static const _mockMemberNames = [
    'Rahul Menon', 'Aparna Nair', 'Vishnu K.', 'Meera Krishnan', 'Siddharth Das',
    'Anjali Pillai', 'Kiran Raj', 'Divya Suresh', 'Arjun Nambiar', 'Lakshmi Warrier',
  ];

  void reset() {
    category = KsrtcBusCategory.districtToDistrict;
    selectedBus = null;
    adminVerified = false;
    bookingReference = null;
    includeStaffInSplit = true;
    splitMemberCount = 42;
    collectionMethod = 'Share UPI Link';
    members.clear();
    transferComplete = false;
    transferTransactionId = null;
    notifyListeners();
  }

  void selectCategory(KsrtcBusCategory value) {
    category = value;
    notifyListeners();
  }

  void selectBus(KsrtcBus bus) {
    selectedBus = bus;
    notifyListeners();
  }

  void setAdminVerified(bool value) {
    adminVerified = value;
    notifyListeners();
  }

  void confirmBooking() {
    bookingReference = 'KSRTC-BK-${88000 + (tripName.length * 37) % 900}';
    notifyListeners();
  }

  void setIncludeStaffInSplit(bool value) {
    includeStaffInSplit = value;
    notifyListeners();
  }

  void setSplitMemberCount(int value) {
    splitMemberCount = value;
    notifyListeners();
  }

  void setCollectionMethod(String value) {
    collectionMethod = value;
    notifyListeners();
  }

  void startCollection() {
    members
      ..clear()
      ..addAll(List.generate(splitMemberCount, (i) {
        final name = i < _mockMemberNames.length ? _mockMemberNames[i] : 'Member ${i + 1}';
        final seedStatus = switch (i) {
          0 || 4 => MemberPaymentStatus.paid,
          1 || 3 => MemberPaymentStatus.pending,
          _ => MemberPaymentStatus.notSent,
        };
        return KsrtcMemberEntry(
          name: name,
          share: perPersonAmount,
          status: i < 5 ? seedStatus : MemberPaymentStatus.notSent,
          paidVia: seedStatus == MemberPaymentStatus.paid ? 'Paid via UPI' : null,
          lastActionLabel: seedStatus == MemberPaymentStatus.pending ? 'Sent 2 days ago' : null,
        );
      }));
    notifyListeners();
  }

  void markPaid(int index) {
    members[index].status = MemberPaymentStatus.paid;
    members[index].paidVia = 'Marked as Cash';
    notifyListeners();
  }

  void sendReminder(int index) {
    members[index].status = MemberPaymentStatus.pending;
    members[index].lastActionLabel = 'Sent just now';
    notifyListeners();
  }

  void sendAllReminders() {
    for (final member in members) {
      if (member.status != MemberPaymentStatus.paid) {
        member.status = MemberPaymentStatus.pending;
        member.lastActionLabel = 'Sent just now';
      }
    }
    notifyListeners();
  }

  void completeTransfer() {
    transferComplete = true;
    transferTransactionId = 'TXN${88200000 + (bookingReference?.length ?? 0) * 113}';
    notifyListeners();
  }

  int get baseFare => selectedBus?.estimatedFare ?? 0;

  int get costPerPerson => totalPassengers == 0 ? 0 : (baseFare / totalPassengers).round();

  int get totalToCollect => baseFare + serviceFeeFlat;

  int get perPersonAmount => splitMemberCount == 0 ? 0 : (totalToCollect / splitMemberCount).round();

  int get amountCollected => members.where((m) => m.status == MemberPaymentStatus.paid).fold(0, (sum, m) => sum + m.share);

  double get collectionProgress => totalToCollect == 0 ? 0 : (amountCollected / totalToCollect).clamp(0, 1);

  int get paidCount => members.where((m) => m.status == MemberPaymentStatus.paid).length;

  int get pendingCount => members.length - paidCount;

  bool get isFullyCollected => members.isNotEmpty && amountCollected >= totalToCollect;
}
