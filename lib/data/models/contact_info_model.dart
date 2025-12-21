// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContactInfo {
  final String name;
  final String? phone;
  final String? email;
  
  ContactInfo({
    required this.name,
    this.phone,
    this.email,
  });

  ContactInfo copyWith({
    String? name,
    String? phone,
    String? email,
  }) {
    return ContactInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      name: map['name'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactInfo.fromJson(String source) => ContactInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ContactInfo(name: $name, phone: $phone, email: $email)';

  @override
  bool operator ==(covariant ContactInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.phone == phone &&
      other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ phone.hashCode ^ email.hashCode;
}
