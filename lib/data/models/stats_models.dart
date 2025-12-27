class MonthStats {
  final int year;
  final int month;
  int total;
  int normal;
  int lscs;
  int abortion;
  int govt;
  int private;

  MonthStats({
    required this.year,
    required this.month,
    required this.total,
    required this.normal,
    required this.lscs,
    required this.abortion,
    required this.govt,
    required this.private,
  });
}


class SubCenterStats {
  final String subCenterName;
  int normal;
  int lscs;
  int abortion;
  int govt;
  int private;
  int totalDeliveries;
  int pendingDeliveryUpdates;
  int pendingDetails; // Count of beneficiaries with incomplete data
  int totalBeneficiaries; // For percentage calculation

  SubCenterStats({
    required this.subCenterName,
    required this.normal,
    required this.lscs,
    required this.abortion,
    required this.govt,
    required this.private,
    required this.totalDeliveries,
    required this.pendingDeliveryUpdates,
    required this.pendingDetails,
    required this.totalBeneficiaries,
  });

  double get dataCompletionPercentage {
    if (totalBeneficiaries == 0) return 0.0;
    return ((totalBeneficiaries - pendingDetails) / totalBeneficiaries) * 100;
  }
}
