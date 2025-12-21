// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HamletsInfoModel {
  final String hamletId;
  final String? hamletName;
  final int? population; // ✅ CHANGED: int for calculations
  final String? subcenterId; // ✅ ADDED: Links this hamlet to a Subcenter
  final String? assignedAshaId;
  
  HamletsInfoModel({
    required this.hamletId,
    this.hamletName,
    this.population,
    this.subcenterId,
    this.assignedAshaId,
  });

  HamletsInfoModel copyWith({
    String? hamletId,
    String? hamletName,
    int? population,
    String? subcenterId,
    String? assignedAshaId,
  }) {
    return HamletsInfoModel(
      hamletId: hamletId ?? this.hamletId,
      hamletName: hamletName ?? this.hamletName,
      population: population ?? this.population,
      subcenterId: subcenterId ?? this.subcenterId,
      assignedAshaId: assignedAshaId ?? this.assignedAshaId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hamletId': hamletId,
      'hamletName': hamletName,
      'population': population,
      'subcenterId': subcenterId,
      'assignedAshaId': assignedAshaId,
    };
  }

  factory HamletsInfoModel.fromMap(Map<String, dynamic> map) {
    return HamletsInfoModel(
      hamletId: map['hamletId'] as String,
      hamletName: map['hamletName'] != null ? map['hamletName'] as String : null,
      population: map['population'] != null ? map['population'] as int : null,
      subcenterId: map['subcenterId'] != null ? map['subcenterId'] as String : null,
      assignedAshaId: map['assignedAshaId'] != null ? map['assignedAshaId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HamletsInfoModel.fromJson(String source) => HamletsInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HamletsInfoModel(hamletId: $hamletId, hamletName: $hamletName, population: $population, subcenterId: $subcenterId, assignedAshaId: $assignedAshaId)';
  }

  @override
  bool operator ==(covariant HamletsInfoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.hamletId == hamletId &&
      other.hamletName == hamletName &&
      other.population == population &&
      other.subcenterId == subcenterId &&
      other.assignedAshaId == assignedAshaId;
  }

  @override
  int get hashCode {
    return hamletId.hashCode ^
      hamletName.hashCode ^
      population.hashCode ^
      subcenterId.hashCode ^
      assignedAshaId.hashCode;
  }
}
