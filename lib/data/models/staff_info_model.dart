// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:my_phc_helper/data/models/contact_info_model.dart';

/// ---------------- ENUM ----------------
enum StaffType {
  medicalOfficer,
  supervisory,
  udc,
  labTechnician,
  pharmacist,
  staffNurse,
  ncdStaffNurce,
  securityGuard,
  cleaner,
  mlhp,
  anm,
  asha,
}

/// Enum helpers (VERY IMPORTANT)
extension StaffTypeExtension on StaffType {
  String toValue() => name;

  static StaffType fromValue(String value) {
    return StaffType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StaffType.asha, // safe fallback
    );
  }
}

/// ---------------- MODEL ----------------
class Staff {
  final String id;
  final StaffType type;
  final ContactInfo contact;
  final String designation;
  final String? employeeCode;
  final DateTime? joiningDate;
  final bool isSubcenterStaff;
  final String workingPhcId;
  final String? workingSubcenterId;

  const Staff({
    required this.id,
    required this.type,
    required this.contact,
    required this.designation,
    this.employeeCode,
    this.joiningDate,
    required this.isSubcenterStaff,
    required this.workingPhcId,
    this.workingSubcenterId,
  });

  /// -------- COPY WITH --------
  Staff copyWith({
    String? id,
    StaffType? type,
    ContactInfo? contact,
    String? designation,
    String? employeeCode,
    DateTime? joiningDate,
    bool? isSubcenterStaff,
    String? workingPhcId,
    String? workingSubcenterId,
  }) {
    return Staff(
      id: id ?? this.id,
      type: type ?? this.type,
      contact: contact ?? this.contact,
      designation: designation ?? this.designation,
      employeeCode: employeeCode ?? this.employeeCode,
      joiningDate: joiningDate ?? this.joiningDate,
      isSubcenterStaff: isSubcenterStaff ?? this.isSubcenterStaff,
      workingPhcId: workingPhcId ?? this.workingPhcId,
      workingSubcenterId: workingSubcenterId ?? this.workingSubcenterId,
    );
  }

  /// -------- MAP --------
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.toValue(), // enum -> string
      'contact': contact.toMap(),
      'designation': designation,
      'employeeCode': employeeCode,
      'joiningDate': joiningDate?.millisecondsSinceEpoch,
      'isSubcenterStaff': isSubcenterStaff,
      'workingPhcId': workingPhcId,
      'workingSubcenterId': workingSubcenterId,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as String,
      type: StaffTypeExtension.fromValue(map['type'] as String),
      contact: ContactInfo.fromMap(map['contact'] as Map<String, dynamic>),
      designation: map['designation'] as String,
      employeeCode:
          map['employeeCode'] != null ? map['employeeCode'] as String : null,
      joiningDate: map['joiningDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['joiningDate'] as int)
          : null,
      isSubcenterStaff: map['isSubcenterStaff'] as bool,
      workingPhcId: map['workingPhcId'] as String,
      workingSubcenterId: map['workingSubcenterId'] != null
          ? map['workingSubcenterId'] as String
          : null,
    );
  }

  /// -------- JSON --------
  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) =>
      Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  /// -------- EQUALITY --------
  @override
  bool operator ==(covariant Staff other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.contact == contact &&
        other.designation == designation &&
        other.employeeCode == employeeCode &&
        other.joiningDate == joiningDate &&
        other.isSubcenterStaff == isSubcenterStaff &&
        other.workingPhcId == workingPhcId &&
        other.workingSubcenterId == workingSubcenterId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        contact.hashCode ^
        designation.hashCode ^
        employeeCode.hashCode ^
        joiningDate.hashCode ^
        isSubcenterStaff.hashCode ^
        workingPhcId.hashCode ^
        workingSubcenterId.hashCode;
  }

  @override
  String toString() {
    return 'Staff(id: $id, type: $type, designation: $designation, phc: $workingPhcId)';
  }
}
