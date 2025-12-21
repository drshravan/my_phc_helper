// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:my_phc_helper/data/models/address_info_model.dart';

class SubcenterInfoModel {
  final String subcenterId;
  final String? subcenterName;
  final Address? address;
  final String? phcId; // ✅ CHANGED: Store ID only (Foreign Key)
  
  SubcenterInfoModel({
    required this.subcenterId,
    this.subcenterName,
    this.address,
    this.phcId,
  });

  SubcenterInfoModel copyWith({
    String? subcenterId,
    String? subcenterName,
    Address? address,
    String? phcId,
  }) {
    return SubcenterInfoModel(
      subcenterId: subcenterId ?? this.subcenterId,
      subcenterName: subcenterName ?? this.subcenterName,
      address: address ?? this.address,
      phcId: phcId ?? this.phcId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subcenterId': subcenterId,
      'subcenterName': subcenterName,
      'address': address?.toMap(),
      'phcId': phcId,
    };
  }

  factory SubcenterInfoModel.fromMap(Map<String, dynamic> map) {
    return SubcenterInfoModel(
      subcenterId: map['subcenterId'] as String,
      subcenterName: map['subcenterName'] != null ? map['subcenterName'] as String : null,
      address: map['address'] != null ? Address.fromMap(map['address'] as Map<String,dynamic>) : null,
      phcId: map['phcId'] != null ? map['phcId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubcenterInfoModel.fromJson(String source) => SubcenterInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubcenterInfoModel(subcenterId: $subcenterId, subcenterName: $subcenterName, address: $address, phcId: $phcId)';
  }

  @override
  bool operator ==(covariant SubcenterInfoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.subcenterId == subcenterId &&
      other.subcenterName == subcenterName &&
      other.address == address &&
      other.phcId == phcId;
  }

  @override
  int get hashCode {
    return subcenterId.hashCode ^
      subcenterName.hashCode ^
      address.hashCode ^
      phcId.hashCode;
  }
}
