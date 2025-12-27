import 'package:cloud_firestore/cloud_firestore.dart';

class AncRecordModel {
  // --- Metadata ---
  String? id; // Firestore Doc ID
  String status; // 'Pending', 'Delivered', 'Aborted'

  // --- Identifiers ---
  String? subCentre;
  String? ancId;
  
  // --- Demographics ---
  String? name;
  String? husbandName;
  int? age;
  String? contactNumber;
  String? village;
  String? district;
  String? phcName;

  // --- Pregnancy Details ---
  DateTime? lmp;
  DateTime? edd;
  int? gravida;
  String? highRiskCause;
  String? birthPlan;

  // --- History ---
  String? previousDeliveryMode;
  String? pastHospitalName;
  String? pastHospitalType;
  String? pastDistrict;
  String? pastAbortionPlace;
  int? pastAbortionWeeks;
  DateTime? pastEventDate;

  // --- Delivery / Outcome ---
  DateTime? deliveryDate;
  String? deliveryAddress;
  String? deliveryMode;
  String? deliveryHospitalType;
  String? babyGender;

  // --- Abortion Details (Current) ---
  DateTime? abortionDate;
  int? abortionWeeks;
  String? abortionPlace;

  // --- Support ---
  String? ashaName;
  String? ashaContact;
  DateTime? regDate;

  AncRecordModel({
    this.id,
    this.status = 'Pending',
    this.subCentre,
    this.ancId,
    this.name,
    this.husbandName,
    this.age,
    this.contactNumber,
    this.village,
    this.district,
    this.phcName,
    this.lmp,
    this.edd,
    this.gravida,
    this.highRiskCause,
    this.birthPlan,
    this.previousDeliveryMode,
    this.pastHospitalName,
    this.pastHospitalType,
    this.pastDistrict,
    this.pastAbortionPlace,
    this.pastAbortionWeeks,
    this.pastEventDate,
    this.deliveryDate,
    this.deliveryAddress,
    this.deliveryMode,
    this.deliveryHospitalType,
    this.babyGender,
    this.abortionDate,
    this.abortionWeeks,
    this.abortionPlace,
    this.ashaName,
    this.ashaContact,
    this.regDate,
  });

  factory AncRecordModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AncRecordModel(
      id: snapshot.id,
      status: data?['status'] ?? 'Pending',
      
      // Identifiers
      subCentre: data?['subCentre'],
      ancId: data?['ancId'],
      
      // Demographics
      name: data?['name'],
      husbandName: data?['husbandName'],
      age: data?['age'],
      contactNumber: data?['contactNumber'],
      village: data?['village'],
      district: data?['district'],
      phcName: data?['phcName'],

      // Pregnancy
      lmp: (data?['lmp'] as Timestamp?)?.toDate(),
      edd: (data?['edd'] as Timestamp?)?.toDate(),
      gravida: data?['gravida'],
      highRiskCause: data?['highRiskCause'],
      birthPlan: data?['birthPlan'],

      // History
      previousDeliveryMode: data?['previousDeliveryMode'],
      pastHospitalName: data?['pastHospitalName'],
      pastHospitalType: data?['pastHospitalType'],
      pastDistrict: data?['pastDistrict'],
      pastAbortionPlace: data?['pastAbortionPlace'],
      pastAbortionWeeks: data?['pastAbortionWeeks'],
      pastEventDate: (data?['pastEventDate'] as Timestamp?)?.toDate(),

      // Delivery
      deliveryDate: (data?['deliveryDate'] as Timestamp?)?.toDate(),
      deliveryAddress: data?['deliveryAddress'],
      deliveryMode: data?['deliveryMode'],
      deliveryHospitalType: data?['deliveryHospitalType'],
      babyGender: data?['babyGender'],

      // Abortion
      abortionDate: (data?['abortionDate'] as Timestamp?)?.toDate(),
      abortionWeeks: data?['abortionWeeks'],
      abortionPlace: data?['abortionPlace'],

      // Support
      ashaName: data?['ashaName'],
      ashaContact: data?['ashaContact'],
      regDate: (data?['regDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "status": status,
      if (subCentre != null) "subCentre": subCentre,
      if (ancId != null) "ancId": ancId,
      if (name != null) "name": name,
      if (husbandName != null) "husbandName": husbandName,
      if (age != null) "age": age,
      if (contactNumber != null) "contactNumber": contactNumber,
      if (village != null) "village": village,
      if (district != null) "district": district,
      if (phcName != null) "phcName": phcName,
      if (lmp != null) "lmp": Timestamp.fromDate(lmp!),
      if (edd != null) "edd": Timestamp.fromDate(edd!),
      if (gravida != null) "gravida": gravida,
      if (highRiskCause != null) "highRiskCause": highRiskCause,
      if (birthPlan != null) "birthPlan": birthPlan,
      if (previousDeliveryMode != null) "previousDeliveryMode": previousDeliveryMode,
      if (pastHospitalName != null) "pastHospitalName": pastHospitalName,
      if (pastHospitalType != null) "pastHospitalType": pastHospitalType,
      if (pastDistrict != null) "pastDistrict": pastDistrict,
      if (pastAbortionPlace != null) "pastAbortionPlace": pastAbortionPlace,
      if (pastAbortionWeeks != null) "pastAbortionWeeks": pastAbortionWeeks,
      if (pastEventDate != null) "pastEventDate": Timestamp.fromDate(pastEventDate!),
      if (deliveryDate != null) "deliveryDate": Timestamp.fromDate(deliveryDate!),
      if (deliveryAddress != null) "deliveryAddress": deliveryAddress,
      if (deliveryMode != null) "deliveryMode": deliveryMode,
      if (deliveryHospitalType != null) "deliveryHospitalType": deliveryHospitalType,
      if (babyGender != null) "babyGender": babyGender,
      if (abortionDate != null) "abortionDate": Timestamp.fromDate(abortionDate!),
      if (abortionWeeks != null) "abortionWeeks": abortionWeeks,
      if (abortionPlace != null) "abortionPlace": abortionPlace,
      if (ashaName != null) "ashaName": ashaName,
      if (ashaContact != null) "ashaContact": ashaContact,
      if (regDate != null) "regDate": Timestamp.fromDate(regDate!),
    };
  }
}
