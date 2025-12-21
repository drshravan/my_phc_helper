// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Address {
  final String? village;
  final String? mandal;
  final String? district;
  final String? state;
  final String? pincode;
  Address({
    this.village,
    this.mandal,
    this.district,
    this.state,
    this.pincode,
  });

  Address copyWith({
    String? village,
    String? mandal,
    String? district,
    String? state,
    String? pincode,
  }) {
    return Address(
      village: village ?? this.village,
      mandal: mandal ?? this.mandal,
      district: district ?? this.district,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'village': village,
      'mandal': mandal,
      'district': district,
      'state': state,
      'pincode': pincode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      village: map['village'] != null ? map['village'] as String : null,
      mandal: map['mandal'] != null ? map['mandal'] as String : null,
      district: map['district'] != null ? map['district'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Address(village: $village, mandal: $mandal, district: $district, state: $state, pincode: $pincode)';
  }

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;
  
    return 
      other.village == village &&
      other.mandal == mandal &&
      other.district == district &&
      other.state == state &&
      other.pincode == pincode;
  }

  @override
  int get hashCode {
    return village.hashCode ^
      mandal.hashCode ^
      district.hashCode ^
      state.hashCode ^
      pincode.hashCode;
  }
}
