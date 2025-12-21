// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:my_phc_helper/data/models/address_info_model.dart';

class PhcInfoModel {
 // 🔹 Administrative Details
 
  final String phcId;
  final String? phcName;
  final Address? address;
  
  PhcInfoModel({
    required this.phcId,
    this.phcName,
    this.address,
  });

  PhcInfoModel copyWith({
    String? phcId,
    String? phcName,
    Address? address,
  }) {
    return PhcInfoModel(
      phcId: phcId ?? this.phcId,
      phcName: phcName ?? this.phcName,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phcId': phcId,
      'phcName': phcName,
      'address': address?.toMap(),
    };
  }

  factory PhcInfoModel.fromMap(Map<String, dynamic> map) {
    return PhcInfoModel(
      phcId: map['phcId'] as String,
      phcName: map['phcName'] != null ? map['phcName'] as String : null,
      address: map['address'] != null ? Address.fromMap(map['address'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhcInfoModel.fromJson(String source) => PhcInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PhcInfoModel(phcId: $phcId, phcName: $phcName, address: $address)';

  @override
  bool operator ==(covariant PhcInfoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.phcId == phcId &&
      other.phcName == phcName &&
      other.address == address;
  }

  @override
  int get hashCode => phcId.hashCode ^ phcName.hashCode ^ address.hashCode;
}
