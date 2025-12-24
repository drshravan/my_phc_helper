// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AncRecordsTable extends AncRecords
    with TableInfo<$AncRecordsTable, AncRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AncRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<int> serialNumber = GeneratedColumn<int>(
    'serial_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subCentreMeta = const VerificationMeta(
    'subCentre',
  );
  @override
  late final GeneratedColumn<String> subCentre = GeneratedColumn<String>(
    'sub_centre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ancIdMeta = const VerificationMeta('ancId');
  @override
  late final GeneratedColumn<String> ancId = GeneratedColumn<String>(
    'anc_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactNumberMeta = const VerificationMeta(
    'contactNumber',
  );
  @override
  late final GeneratedColumn<String> contactNumber = GeneratedColumn<String>(
    'contact_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lmpMeta = const VerificationMeta('lmp');
  @override
  late final GeneratedColumn<DateTime> lmp = GeneratedColumn<DateTime>(
    'lmp',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eddMeta = const VerificationMeta('edd');
  @override
  late final GeneratedColumn<DateTime> edd = GeneratedColumn<DateTime>(
    'edd',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _husbandNameMeta = const VerificationMeta(
    'husbandName',
  );
  @override
  late final GeneratedColumn<String> husbandName = GeneratedColumn<String>(
    'husband_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _villageMeta = const VerificationMeta(
    'village',
  );
  @override
  late final GeneratedColumn<String> village = GeneratedColumn<String>(
    'village',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gravidaMeta = const VerificationMeta(
    'gravida',
  );
  @override
  late final GeneratedColumn<int> gravida = GeneratedColumn<int>(
    'gravida',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousDeliveryModeMeta =
      const VerificationMeta('previousDeliveryMode');
  @override
  late final GeneratedColumn<String> previousDeliveryMode =
      GeneratedColumn<String>(
        'previous_delivery_mode',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _highRiskCauseMeta = const VerificationMeta(
    'highRiskCause',
  );
  @override
  late final GeneratedColumn<String> highRiskCause = GeneratedColumn<String>(
    'high_risk_cause',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthPlanMeta = const VerificationMeta(
    'birthPlan',
  );
  @override
  late final GeneratedColumn<String> birthPlan = GeneratedColumn<String>(
    'birth_plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryDateMeta = const VerificationMeta(
    'deliveryDate',
  );
  @override
  late final GeneratedColumn<DateTime> deliveryDate = GeneratedColumn<DateTime>(
    'delivery_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryAddressMeta = const VerificationMeta(
    'deliveryAddress',
  );
  @override
  late final GeneratedColumn<String> deliveryAddress = GeneratedColumn<String>(
    'delivery_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryModeMeta = const VerificationMeta(
    'deliveryMode',
  );
  @override
  late final GeneratedColumn<String> deliveryMode = GeneratedColumn<String>(
    'delivery_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ashaNameMeta = const VerificationMeta(
    'ashaName',
  );
  @override
  late final GeneratedColumn<String> ashaName = GeneratedColumn<String>(
    'asha_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ashaContactMeta = const VerificationMeta(
    'ashaContact',
  );
  @override
  late final GeneratedColumn<String> ashaContact = GeneratedColumn<String>(
    'asha_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serialNumber,
    subCentre,
    ancId,
    name,
    contactNumber,
    lmp,
    edd,
    husbandName,
    village,
    age,
    gravida,
    previousDeliveryMode,
    highRiskCause,
    birthPlan,
    deliveryDate,
    deliveryAddress,
    deliveryMode,
    ashaName,
    ashaContact,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anc_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AncRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    }
    if (data.containsKey('sub_centre')) {
      context.handle(
        _subCentreMeta,
        subCentre.isAcceptableOrUnknown(data['sub_centre']!, _subCentreMeta),
      );
    }
    if (data.containsKey('anc_id')) {
      context.handle(
        _ancIdMeta,
        ancId.isAcceptableOrUnknown(data['anc_id']!, _ancIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('contact_number')) {
      context.handle(
        _contactNumberMeta,
        contactNumber.isAcceptableOrUnknown(
          data['contact_number']!,
          _contactNumberMeta,
        ),
      );
    }
    if (data.containsKey('lmp')) {
      context.handle(
        _lmpMeta,
        lmp.isAcceptableOrUnknown(data['lmp']!, _lmpMeta),
      );
    }
    if (data.containsKey('edd')) {
      context.handle(
        _eddMeta,
        edd.isAcceptableOrUnknown(data['edd']!, _eddMeta),
      );
    }
    if (data.containsKey('husband_name')) {
      context.handle(
        _husbandNameMeta,
        husbandName.isAcceptableOrUnknown(
          data['husband_name']!,
          _husbandNameMeta,
        ),
      );
    }
    if (data.containsKey('village')) {
      context.handle(
        _villageMeta,
        village.isAcceptableOrUnknown(data['village']!, _villageMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('gravida')) {
      context.handle(
        _gravidaMeta,
        gravida.isAcceptableOrUnknown(data['gravida']!, _gravidaMeta),
      );
    }
    if (data.containsKey('previous_delivery_mode')) {
      context.handle(
        _previousDeliveryModeMeta,
        previousDeliveryMode.isAcceptableOrUnknown(
          data['previous_delivery_mode']!,
          _previousDeliveryModeMeta,
        ),
      );
    }
    if (data.containsKey('high_risk_cause')) {
      context.handle(
        _highRiskCauseMeta,
        highRiskCause.isAcceptableOrUnknown(
          data['high_risk_cause']!,
          _highRiskCauseMeta,
        ),
      );
    }
    if (data.containsKey('birth_plan')) {
      context.handle(
        _birthPlanMeta,
        birthPlan.isAcceptableOrUnknown(data['birth_plan']!, _birthPlanMeta),
      );
    }
    if (data.containsKey('delivery_date')) {
      context.handle(
        _deliveryDateMeta,
        deliveryDate.isAcceptableOrUnknown(
          data['delivery_date']!,
          _deliveryDateMeta,
        ),
      );
    }
    if (data.containsKey('delivery_address')) {
      context.handle(
        _deliveryAddressMeta,
        deliveryAddress.isAcceptableOrUnknown(
          data['delivery_address']!,
          _deliveryAddressMeta,
        ),
      );
    }
    if (data.containsKey('delivery_mode')) {
      context.handle(
        _deliveryModeMeta,
        deliveryMode.isAcceptableOrUnknown(
          data['delivery_mode']!,
          _deliveryModeMeta,
        ),
      );
    }
    if (data.containsKey('asha_name')) {
      context.handle(
        _ashaNameMeta,
        ashaName.isAcceptableOrUnknown(data['asha_name']!, _ashaNameMeta),
      );
    }
    if (data.containsKey('asha_contact')) {
      context.handle(
        _ashaContactMeta,
        ashaContact.isAcceptableOrUnknown(
          data['asha_contact']!,
          _ashaContactMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AncRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AncRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial_number'],
      ),
      subCentre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_centre'],
      ),
      ancId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anc_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      contactNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_number'],
      ),
      lmp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lmp'],
      ),
      edd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}edd'],
      ),
      husbandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}husband_name'],
      ),
      village: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}village'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      gravida: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gravida'],
      ),
      previousDeliveryMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_delivery_mode'],
      ),
      highRiskCause: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}high_risk_cause'],
      ),
      birthPlan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_plan'],
      ),
      deliveryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivery_date'],
      ),
      deliveryAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_address'],
      ),
      deliveryMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_mode'],
      ),
      ashaName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asha_name'],
      ),
      ashaContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asha_contact'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $AncRecordsTable createAlias(String alias) {
    return $AncRecordsTable(attachedDatabase, alias);
  }
}

class AncRecord extends DataClass implements Insertable<AncRecord> {
  final int id;
  final int? serialNumber;
  final String? subCentre;
  final String? ancId;
  final String? name;
  final String? contactNumber;
  final DateTime? lmp;
  final DateTime? edd;
  final String? husbandName;
  final String? village;
  final int? age;
  final int? gravida;
  final String? previousDeliveryMode;
  final String? highRiskCause;
  final String? birthPlan;
  final DateTime? deliveryDate;
  final String? deliveryAddress;
  final String? deliveryMode;
  final String? ashaName;
  final String? ashaContact;
  final String status;
  const AncRecord({
    required this.id,
    this.serialNumber,
    this.subCentre,
    this.ancId,
    this.name,
    this.contactNumber,
    this.lmp,
    this.edd,
    this.husbandName,
    this.village,
    this.age,
    this.gravida,
    this.previousDeliveryMode,
    this.highRiskCause,
    this.birthPlan,
    this.deliveryDate,
    this.deliveryAddress,
    this.deliveryMode,
    this.ashaName,
    this.ashaContact,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<int>(serialNumber);
    }
    if (!nullToAbsent || subCentre != null) {
      map['sub_centre'] = Variable<String>(subCentre);
    }
    if (!nullToAbsent || ancId != null) {
      map['anc_id'] = Variable<String>(ancId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || contactNumber != null) {
      map['contact_number'] = Variable<String>(contactNumber);
    }
    if (!nullToAbsent || lmp != null) {
      map['lmp'] = Variable<DateTime>(lmp);
    }
    if (!nullToAbsent || edd != null) {
      map['edd'] = Variable<DateTime>(edd);
    }
    if (!nullToAbsent || husbandName != null) {
      map['husband_name'] = Variable<String>(husbandName);
    }
    if (!nullToAbsent || village != null) {
      map['village'] = Variable<String>(village);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || gravida != null) {
      map['gravida'] = Variable<int>(gravida);
    }
    if (!nullToAbsent || previousDeliveryMode != null) {
      map['previous_delivery_mode'] = Variable<String>(previousDeliveryMode);
    }
    if (!nullToAbsent || highRiskCause != null) {
      map['high_risk_cause'] = Variable<String>(highRiskCause);
    }
    if (!nullToAbsent || birthPlan != null) {
      map['birth_plan'] = Variable<String>(birthPlan);
    }
    if (!nullToAbsent || deliveryDate != null) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate);
    }
    if (!nullToAbsent || deliveryAddress != null) {
      map['delivery_address'] = Variable<String>(deliveryAddress);
    }
    if (!nullToAbsent || deliveryMode != null) {
      map['delivery_mode'] = Variable<String>(deliveryMode);
    }
    if (!nullToAbsent || ashaName != null) {
      map['asha_name'] = Variable<String>(ashaName);
    }
    if (!nullToAbsent || ashaContact != null) {
      map['asha_contact'] = Variable<String>(ashaContact);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  AncRecordsCompanion toCompanion(bool nullToAbsent) {
    return AncRecordsCompanion(
      id: Value(id),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      subCentre: subCentre == null && nullToAbsent
          ? const Value.absent()
          : Value(subCentre),
      ancId: ancId == null && nullToAbsent
          ? const Value.absent()
          : Value(ancId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      contactNumber: contactNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(contactNumber),
      lmp: lmp == null && nullToAbsent ? const Value.absent() : Value(lmp),
      edd: edd == null && nullToAbsent ? const Value.absent() : Value(edd),
      husbandName: husbandName == null && nullToAbsent
          ? const Value.absent()
          : Value(husbandName),
      village: village == null && nullToAbsent
          ? const Value.absent()
          : Value(village),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      gravida: gravida == null && nullToAbsent
          ? const Value.absent()
          : Value(gravida),
      previousDeliveryMode: previousDeliveryMode == null && nullToAbsent
          ? const Value.absent()
          : Value(previousDeliveryMode),
      highRiskCause: highRiskCause == null && nullToAbsent
          ? const Value.absent()
          : Value(highRiskCause),
      birthPlan: birthPlan == null && nullToAbsent
          ? const Value.absent()
          : Value(birthPlan),
      deliveryDate: deliveryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryDate),
      deliveryAddress: deliveryAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryAddress),
      deliveryMode: deliveryMode == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryMode),
      ashaName: ashaName == null && nullToAbsent
          ? const Value.absent()
          : Value(ashaName),
      ashaContact: ashaContact == null && nullToAbsent
          ? const Value.absent()
          : Value(ashaContact),
      status: Value(status),
    );
  }

  factory AncRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AncRecord(
      id: serializer.fromJson<int>(json['id']),
      serialNumber: serializer.fromJson<int?>(json['serialNumber']),
      subCentre: serializer.fromJson<String?>(json['subCentre']),
      ancId: serializer.fromJson<String?>(json['ancId']),
      name: serializer.fromJson<String?>(json['name']),
      contactNumber: serializer.fromJson<String?>(json['contactNumber']),
      lmp: serializer.fromJson<DateTime?>(json['lmp']),
      edd: serializer.fromJson<DateTime?>(json['edd']),
      husbandName: serializer.fromJson<String?>(json['husbandName']),
      village: serializer.fromJson<String?>(json['village']),
      age: serializer.fromJson<int?>(json['age']),
      gravida: serializer.fromJson<int?>(json['gravida']),
      previousDeliveryMode: serializer.fromJson<String?>(
        json['previousDeliveryMode'],
      ),
      highRiskCause: serializer.fromJson<String?>(json['highRiskCause']),
      birthPlan: serializer.fromJson<String?>(json['birthPlan']),
      deliveryDate: serializer.fromJson<DateTime?>(json['deliveryDate']),
      deliveryAddress: serializer.fromJson<String?>(json['deliveryAddress']),
      deliveryMode: serializer.fromJson<String?>(json['deliveryMode']),
      ashaName: serializer.fromJson<String?>(json['ashaName']),
      ashaContact: serializer.fromJson<String?>(json['ashaContact']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serialNumber': serializer.toJson<int?>(serialNumber),
      'subCentre': serializer.toJson<String?>(subCentre),
      'ancId': serializer.toJson<String?>(ancId),
      'name': serializer.toJson<String?>(name),
      'contactNumber': serializer.toJson<String?>(contactNumber),
      'lmp': serializer.toJson<DateTime?>(lmp),
      'edd': serializer.toJson<DateTime?>(edd),
      'husbandName': serializer.toJson<String?>(husbandName),
      'village': serializer.toJson<String?>(village),
      'age': serializer.toJson<int?>(age),
      'gravida': serializer.toJson<int?>(gravida),
      'previousDeliveryMode': serializer.toJson<String?>(previousDeliveryMode),
      'highRiskCause': serializer.toJson<String?>(highRiskCause),
      'birthPlan': serializer.toJson<String?>(birthPlan),
      'deliveryDate': serializer.toJson<DateTime?>(deliveryDate),
      'deliveryAddress': serializer.toJson<String?>(deliveryAddress),
      'deliveryMode': serializer.toJson<String?>(deliveryMode),
      'ashaName': serializer.toJson<String?>(ashaName),
      'ashaContact': serializer.toJson<String?>(ashaContact),
      'status': serializer.toJson<String>(status),
    };
  }

  AncRecord copyWith({
    int? id,
    Value<int?> serialNumber = const Value.absent(),
    Value<String?> subCentre = const Value.absent(),
    Value<String?> ancId = const Value.absent(),
    Value<String?> name = const Value.absent(),
    Value<String?> contactNumber = const Value.absent(),
    Value<DateTime?> lmp = const Value.absent(),
    Value<DateTime?> edd = const Value.absent(),
    Value<String?> husbandName = const Value.absent(),
    Value<String?> village = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<int?> gravida = const Value.absent(),
    Value<String?> previousDeliveryMode = const Value.absent(),
    Value<String?> highRiskCause = const Value.absent(),
    Value<String?> birthPlan = const Value.absent(),
    Value<DateTime?> deliveryDate = const Value.absent(),
    Value<String?> deliveryAddress = const Value.absent(),
    Value<String?> deliveryMode = const Value.absent(),
    Value<String?> ashaName = const Value.absent(),
    Value<String?> ashaContact = const Value.absent(),
    String? status,
  }) => AncRecord(
    id: id ?? this.id,
    serialNumber: serialNumber.present ? serialNumber.value : this.serialNumber,
    subCentre: subCentre.present ? subCentre.value : this.subCentre,
    ancId: ancId.present ? ancId.value : this.ancId,
    name: name.present ? name.value : this.name,
    contactNumber: contactNumber.present
        ? contactNumber.value
        : this.contactNumber,
    lmp: lmp.present ? lmp.value : this.lmp,
    edd: edd.present ? edd.value : this.edd,
    husbandName: husbandName.present ? husbandName.value : this.husbandName,
    village: village.present ? village.value : this.village,
    age: age.present ? age.value : this.age,
    gravida: gravida.present ? gravida.value : this.gravida,
    previousDeliveryMode: previousDeliveryMode.present
        ? previousDeliveryMode.value
        : this.previousDeliveryMode,
    highRiskCause: highRiskCause.present
        ? highRiskCause.value
        : this.highRiskCause,
    birthPlan: birthPlan.present ? birthPlan.value : this.birthPlan,
    deliveryDate: deliveryDate.present ? deliveryDate.value : this.deliveryDate,
    deliveryAddress: deliveryAddress.present
        ? deliveryAddress.value
        : this.deliveryAddress,
    deliveryMode: deliveryMode.present ? deliveryMode.value : this.deliveryMode,
    ashaName: ashaName.present ? ashaName.value : this.ashaName,
    ashaContact: ashaContact.present ? ashaContact.value : this.ashaContact,
    status: status ?? this.status,
  );
  AncRecord copyWithCompanion(AncRecordsCompanion data) {
    return AncRecord(
      id: data.id.present ? data.id.value : this.id,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      subCentre: data.subCentre.present ? data.subCentre.value : this.subCentre,
      ancId: data.ancId.present ? data.ancId.value : this.ancId,
      name: data.name.present ? data.name.value : this.name,
      contactNumber: data.contactNumber.present
          ? data.contactNumber.value
          : this.contactNumber,
      lmp: data.lmp.present ? data.lmp.value : this.lmp,
      edd: data.edd.present ? data.edd.value : this.edd,
      husbandName: data.husbandName.present
          ? data.husbandName.value
          : this.husbandName,
      village: data.village.present ? data.village.value : this.village,
      age: data.age.present ? data.age.value : this.age,
      gravida: data.gravida.present ? data.gravida.value : this.gravida,
      previousDeliveryMode: data.previousDeliveryMode.present
          ? data.previousDeliveryMode.value
          : this.previousDeliveryMode,
      highRiskCause: data.highRiskCause.present
          ? data.highRiskCause.value
          : this.highRiskCause,
      birthPlan: data.birthPlan.present ? data.birthPlan.value : this.birthPlan,
      deliveryDate: data.deliveryDate.present
          ? data.deliveryDate.value
          : this.deliveryDate,
      deliveryAddress: data.deliveryAddress.present
          ? data.deliveryAddress.value
          : this.deliveryAddress,
      deliveryMode: data.deliveryMode.present
          ? data.deliveryMode.value
          : this.deliveryMode,
      ashaName: data.ashaName.present ? data.ashaName.value : this.ashaName,
      ashaContact: data.ashaContact.present
          ? data.ashaContact.value
          : this.ashaContact,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AncRecord(')
          ..write('id: $id, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('subCentre: $subCentre, ')
          ..write('ancId: $ancId, ')
          ..write('name: $name, ')
          ..write('contactNumber: $contactNumber, ')
          ..write('lmp: $lmp, ')
          ..write('edd: $edd, ')
          ..write('husbandName: $husbandName, ')
          ..write('village: $village, ')
          ..write('age: $age, ')
          ..write('gravida: $gravida, ')
          ..write('previousDeliveryMode: $previousDeliveryMode, ')
          ..write('highRiskCause: $highRiskCause, ')
          ..write('birthPlan: $birthPlan, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('deliveryMode: $deliveryMode, ')
          ..write('ashaName: $ashaName, ')
          ..write('ashaContact: $ashaContact, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serialNumber,
    subCentre,
    ancId,
    name,
    contactNumber,
    lmp,
    edd,
    husbandName,
    village,
    age,
    gravida,
    previousDeliveryMode,
    highRiskCause,
    birthPlan,
    deliveryDate,
    deliveryAddress,
    deliveryMode,
    ashaName,
    ashaContact,
    status,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AncRecord &&
          other.id == this.id &&
          other.serialNumber == this.serialNumber &&
          other.subCentre == this.subCentre &&
          other.ancId == this.ancId &&
          other.name == this.name &&
          other.contactNumber == this.contactNumber &&
          other.lmp == this.lmp &&
          other.edd == this.edd &&
          other.husbandName == this.husbandName &&
          other.village == this.village &&
          other.age == this.age &&
          other.gravida == this.gravida &&
          other.previousDeliveryMode == this.previousDeliveryMode &&
          other.highRiskCause == this.highRiskCause &&
          other.birthPlan == this.birthPlan &&
          other.deliveryDate == this.deliveryDate &&
          other.deliveryAddress == this.deliveryAddress &&
          other.deliveryMode == this.deliveryMode &&
          other.ashaName == this.ashaName &&
          other.ashaContact == this.ashaContact &&
          other.status == this.status);
}

class AncRecordsCompanion extends UpdateCompanion<AncRecord> {
  final Value<int> id;
  final Value<int?> serialNumber;
  final Value<String?> subCentre;
  final Value<String?> ancId;
  final Value<String?> name;
  final Value<String?> contactNumber;
  final Value<DateTime?> lmp;
  final Value<DateTime?> edd;
  final Value<String?> husbandName;
  final Value<String?> village;
  final Value<int?> age;
  final Value<int?> gravida;
  final Value<String?> previousDeliveryMode;
  final Value<String?> highRiskCause;
  final Value<String?> birthPlan;
  final Value<DateTime?> deliveryDate;
  final Value<String?> deliveryAddress;
  final Value<String?> deliveryMode;
  final Value<String?> ashaName;
  final Value<String?> ashaContact;
  final Value<String> status;
  const AncRecordsCompanion({
    this.id = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.subCentre = const Value.absent(),
    this.ancId = const Value.absent(),
    this.name = const Value.absent(),
    this.contactNumber = const Value.absent(),
    this.lmp = const Value.absent(),
    this.edd = const Value.absent(),
    this.husbandName = const Value.absent(),
    this.village = const Value.absent(),
    this.age = const Value.absent(),
    this.gravida = const Value.absent(),
    this.previousDeliveryMode = const Value.absent(),
    this.highRiskCause = const Value.absent(),
    this.birthPlan = const Value.absent(),
    this.deliveryDate = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.deliveryMode = const Value.absent(),
    this.ashaName = const Value.absent(),
    this.ashaContact = const Value.absent(),
    this.status = const Value.absent(),
  });
  AncRecordsCompanion.insert({
    this.id = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.subCentre = const Value.absent(),
    this.ancId = const Value.absent(),
    this.name = const Value.absent(),
    this.contactNumber = const Value.absent(),
    this.lmp = const Value.absent(),
    this.edd = const Value.absent(),
    this.husbandName = const Value.absent(),
    this.village = const Value.absent(),
    this.age = const Value.absent(),
    this.gravida = const Value.absent(),
    this.previousDeliveryMode = const Value.absent(),
    this.highRiskCause = const Value.absent(),
    this.birthPlan = const Value.absent(),
    this.deliveryDate = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.deliveryMode = const Value.absent(),
    this.ashaName = const Value.absent(),
    this.ashaContact = const Value.absent(),
    this.status = const Value.absent(),
  });
  static Insertable<AncRecord> custom({
    Expression<int>? id,
    Expression<int>? serialNumber,
    Expression<String>? subCentre,
    Expression<String>? ancId,
    Expression<String>? name,
    Expression<String>? contactNumber,
    Expression<DateTime>? lmp,
    Expression<DateTime>? edd,
    Expression<String>? husbandName,
    Expression<String>? village,
    Expression<int>? age,
    Expression<int>? gravida,
    Expression<String>? previousDeliveryMode,
    Expression<String>? highRiskCause,
    Expression<String>? birthPlan,
    Expression<DateTime>? deliveryDate,
    Expression<String>? deliveryAddress,
    Expression<String>? deliveryMode,
    Expression<String>? ashaName,
    Expression<String>? ashaContact,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (subCentre != null) 'sub_centre': subCentre,
      if (ancId != null) 'anc_id': ancId,
      if (name != null) 'name': name,
      if (contactNumber != null) 'contact_number': contactNumber,
      if (lmp != null) 'lmp': lmp,
      if (edd != null) 'edd': edd,
      if (husbandName != null) 'husband_name': husbandName,
      if (village != null) 'village': village,
      if (age != null) 'age': age,
      if (gravida != null) 'gravida': gravida,
      if (previousDeliveryMode != null)
        'previous_delivery_mode': previousDeliveryMode,
      if (highRiskCause != null) 'high_risk_cause': highRiskCause,
      if (birthPlan != null) 'birth_plan': birthPlan,
      if (deliveryDate != null) 'delivery_date': deliveryDate,
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (deliveryMode != null) 'delivery_mode': deliveryMode,
      if (ashaName != null) 'asha_name': ashaName,
      if (ashaContact != null) 'asha_contact': ashaContact,
      if (status != null) 'status': status,
    });
  }

  AncRecordsCompanion copyWith({
    Value<int>? id,
    Value<int?>? serialNumber,
    Value<String?>? subCentre,
    Value<String?>? ancId,
    Value<String?>? name,
    Value<String?>? contactNumber,
    Value<DateTime?>? lmp,
    Value<DateTime?>? edd,
    Value<String?>? husbandName,
    Value<String?>? village,
    Value<int?>? age,
    Value<int?>? gravida,
    Value<String?>? previousDeliveryMode,
    Value<String?>? highRiskCause,
    Value<String?>? birthPlan,
    Value<DateTime?>? deliveryDate,
    Value<String?>? deliveryAddress,
    Value<String?>? deliveryMode,
    Value<String?>? ashaName,
    Value<String?>? ashaContact,
    Value<String>? status,
  }) {
    return AncRecordsCompanion(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      subCentre: subCentre ?? this.subCentre,
      ancId: ancId ?? this.ancId,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      lmp: lmp ?? this.lmp,
      edd: edd ?? this.edd,
      husbandName: husbandName ?? this.husbandName,
      village: village ?? this.village,
      age: age ?? this.age,
      gravida: gravida ?? this.gravida,
      previousDeliveryMode: previousDeliveryMode ?? this.previousDeliveryMode,
      highRiskCause: highRiskCause ?? this.highRiskCause,
      birthPlan: birthPlan ?? this.birthPlan,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      ashaName: ashaName ?? this.ashaName,
      ashaContact: ashaContact ?? this.ashaContact,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<int>(serialNumber.value);
    }
    if (subCentre.present) {
      map['sub_centre'] = Variable<String>(subCentre.value);
    }
    if (ancId.present) {
      map['anc_id'] = Variable<String>(ancId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contactNumber.present) {
      map['contact_number'] = Variable<String>(contactNumber.value);
    }
    if (lmp.present) {
      map['lmp'] = Variable<DateTime>(lmp.value);
    }
    if (edd.present) {
      map['edd'] = Variable<DateTime>(edd.value);
    }
    if (husbandName.present) {
      map['husband_name'] = Variable<String>(husbandName.value);
    }
    if (village.present) {
      map['village'] = Variable<String>(village.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gravida.present) {
      map['gravida'] = Variable<int>(gravida.value);
    }
    if (previousDeliveryMode.present) {
      map['previous_delivery_mode'] = Variable<String>(
        previousDeliveryMode.value,
      );
    }
    if (highRiskCause.present) {
      map['high_risk_cause'] = Variable<String>(highRiskCause.value);
    }
    if (birthPlan.present) {
      map['birth_plan'] = Variable<String>(birthPlan.value);
    }
    if (deliveryDate.present) {
      map['delivery_date'] = Variable<DateTime>(deliveryDate.value);
    }
    if (deliveryAddress.present) {
      map['delivery_address'] = Variable<String>(deliveryAddress.value);
    }
    if (deliveryMode.present) {
      map['delivery_mode'] = Variable<String>(deliveryMode.value);
    }
    if (ashaName.present) {
      map['asha_name'] = Variable<String>(ashaName.value);
    }
    if (ashaContact.present) {
      map['asha_contact'] = Variable<String>(ashaContact.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AncRecordsCompanion(')
          ..write('id: $id, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('subCentre: $subCentre, ')
          ..write('ancId: $ancId, ')
          ..write('name: $name, ')
          ..write('contactNumber: $contactNumber, ')
          ..write('lmp: $lmp, ')
          ..write('edd: $edd, ')
          ..write('husbandName: $husbandName, ')
          ..write('village: $village, ')
          ..write('age: $age, ')
          ..write('gravida: $gravida, ')
          ..write('previousDeliveryMode: $previousDeliveryMode, ')
          ..write('highRiskCause: $highRiskCause, ')
          ..write('birthPlan: $birthPlan, ')
          ..write('deliveryDate: $deliveryDate, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('deliveryMode: $deliveryMode, ')
          ..write('ashaName: $ashaName, ')
          ..write('ashaContact: $ashaContact, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AncRecordsTable ancRecords = $AncRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [ancRecords];
}

typedef $$AncRecordsTableCreateCompanionBuilder =
    AncRecordsCompanion Function({
      Value<int> id,
      Value<int?> serialNumber,
      Value<String?> subCentre,
      Value<String?> ancId,
      Value<String?> name,
      Value<String?> contactNumber,
      Value<DateTime?> lmp,
      Value<DateTime?> edd,
      Value<String?> husbandName,
      Value<String?> village,
      Value<int?> age,
      Value<int?> gravida,
      Value<String?> previousDeliveryMode,
      Value<String?> highRiskCause,
      Value<String?> birthPlan,
      Value<DateTime?> deliveryDate,
      Value<String?> deliveryAddress,
      Value<String?> deliveryMode,
      Value<String?> ashaName,
      Value<String?> ashaContact,
      Value<String> status,
    });
typedef $$AncRecordsTableUpdateCompanionBuilder =
    AncRecordsCompanion Function({
      Value<int> id,
      Value<int?> serialNumber,
      Value<String?> subCentre,
      Value<String?> ancId,
      Value<String?> name,
      Value<String?> contactNumber,
      Value<DateTime?> lmp,
      Value<DateTime?> edd,
      Value<String?> husbandName,
      Value<String?> village,
      Value<int?> age,
      Value<int?> gravida,
      Value<String?> previousDeliveryMode,
      Value<String?> highRiskCause,
      Value<String?> birthPlan,
      Value<DateTime?> deliveryDate,
      Value<String?> deliveryAddress,
      Value<String?> deliveryMode,
      Value<String?> ashaName,
      Value<String?> ashaContact,
      Value<String> status,
    });

class $$AncRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AncRecordsTable> {
  $$AncRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subCentre => $composableBuilder(
    column: $table.subCentre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ancId => $composableBuilder(
    column: $table.ancId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactNumber => $composableBuilder(
    column: $table.contactNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lmp => $composableBuilder(
    column: $table.lmp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get edd => $composableBuilder(
    column: $table.edd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get husbandName => $composableBuilder(
    column: $table.husbandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gravida => $composableBuilder(
    column: $table.gravida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousDeliveryMode => $composableBuilder(
    column: $table.previousDeliveryMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get highRiskCause => $composableBuilder(
    column: $table.highRiskCause,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthPlan => $composableBuilder(
    column: $table.birthPlan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryMode => $composableBuilder(
    column: $table.deliveryMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ashaName => $composableBuilder(
    column: $table.ashaName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ashaContact => $composableBuilder(
    column: $table.ashaContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AncRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AncRecordsTable> {
  $$AncRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subCentre => $composableBuilder(
    column: $table.subCentre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ancId => $composableBuilder(
    column: $table.ancId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactNumber => $composableBuilder(
    column: $table.contactNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lmp => $composableBuilder(
    column: $table.lmp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get edd => $composableBuilder(
    column: $table.edd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get husbandName => $composableBuilder(
    column: $table.husbandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gravida => $composableBuilder(
    column: $table.gravida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousDeliveryMode => $composableBuilder(
    column: $table.previousDeliveryMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get highRiskCause => $composableBuilder(
    column: $table.highRiskCause,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthPlan => $composableBuilder(
    column: $table.birthPlan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryMode => $composableBuilder(
    column: $table.deliveryMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ashaName => $composableBuilder(
    column: $table.ashaName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ashaContact => $composableBuilder(
    column: $table.ashaContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AncRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AncRecordsTable> {
  $$AncRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subCentre =>
      $composableBuilder(column: $table.subCentre, builder: (column) => column);

  GeneratedColumn<String> get ancId =>
      $composableBuilder(column: $table.ancId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactNumber => $composableBuilder(
    column: $table.contactNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lmp =>
      $composableBuilder(column: $table.lmp, builder: (column) => column);

  GeneratedColumn<DateTime> get edd =>
      $composableBuilder(column: $table.edd, builder: (column) => column);

  GeneratedColumn<String> get husbandName => $composableBuilder(
    column: $table.husbandName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get village =>
      $composableBuilder(column: $table.village, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get gravida =>
      $composableBuilder(column: $table.gravida, builder: (column) => column);

  GeneratedColumn<String> get previousDeliveryMode => $composableBuilder(
    column: $table.previousDeliveryMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get highRiskCause => $composableBuilder(
    column: $table.highRiskCause,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birthPlan =>
      $composableBuilder(column: $table.birthPlan, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveryDate => $composableBuilder(
    column: $table.deliveryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryAddress => $composableBuilder(
    column: $table.deliveryAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryMode => $composableBuilder(
    column: $table.deliveryMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ashaName =>
      $composableBuilder(column: $table.ashaName, builder: (column) => column);

  GeneratedColumn<String> get ashaContact => $composableBuilder(
    column: $table.ashaContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$AncRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AncRecordsTable,
          AncRecord,
          $$AncRecordsTableFilterComposer,
          $$AncRecordsTableOrderingComposer,
          $$AncRecordsTableAnnotationComposer,
          $$AncRecordsTableCreateCompanionBuilder,
          $$AncRecordsTableUpdateCompanionBuilder,
          (
            AncRecord,
            BaseReferences<_$AppDatabase, $AncRecordsTable, AncRecord>,
          ),
          AncRecord,
          PrefetchHooks Function()
        > {
  $$AncRecordsTableTableManager(_$AppDatabase db, $AncRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AncRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AncRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AncRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serialNumber = const Value.absent(),
                Value<String?> subCentre = const Value.absent(),
                Value<String?> ancId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> contactNumber = const Value.absent(),
                Value<DateTime?> lmp = const Value.absent(),
                Value<DateTime?> edd = const Value.absent(),
                Value<String?> husbandName = const Value.absent(),
                Value<String?> village = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<int?> gravida = const Value.absent(),
                Value<String?> previousDeliveryMode = const Value.absent(),
                Value<String?> highRiskCause = const Value.absent(),
                Value<String?> birthPlan = const Value.absent(),
                Value<DateTime?> deliveryDate = const Value.absent(),
                Value<String?> deliveryAddress = const Value.absent(),
                Value<String?> deliveryMode = const Value.absent(),
                Value<String?> ashaName = const Value.absent(),
                Value<String?> ashaContact = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => AncRecordsCompanion(
                id: id,
                serialNumber: serialNumber,
                subCentre: subCentre,
                ancId: ancId,
                name: name,
                contactNumber: contactNumber,
                lmp: lmp,
                edd: edd,
                husbandName: husbandName,
                village: village,
                age: age,
                gravida: gravida,
                previousDeliveryMode: previousDeliveryMode,
                highRiskCause: highRiskCause,
                birthPlan: birthPlan,
                deliveryDate: deliveryDate,
                deliveryAddress: deliveryAddress,
                deliveryMode: deliveryMode,
                ashaName: ashaName,
                ashaContact: ashaContact,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serialNumber = const Value.absent(),
                Value<String?> subCentre = const Value.absent(),
                Value<String?> ancId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> contactNumber = const Value.absent(),
                Value<DateTime?> lmp = const Value.absent(),
                Value<DateTime?> edd = const Value.absent(),
                Value<String?> husbandName = const Value.absent(),
                Value<String?> village = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<int?> gravida = const Value.absent(),
                Value<String?> previousDeliveryMode = const Value.absent(),
                Value<String?> highRiskCause = const Value.absent(),
                Value<String?> birthPlan = const Value.absent(),
                Value<DateTime?> deliveryDate = const Value.absent(),
                Value<String?> deliveryAddress = const Value.absent(),
                Value<String?> deliveryMode = const Value.absent(),
                Value<String?> ashaName = const Value.absent(),
                Value<String?> ashaContact = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => AncRecordsCompanion.insert(
                id: id,
                serialNumber: serialNumber,
                subCentre: subCentre,
                ancId: ancId,
                name: name,
                contactNumber: contactNumber,
                lmp: lmp,
                edd: edd,
                husbandName: husbandName,
                village: village,
                age: age,
                gravida: gravida,
                previousDeliveryMode: previousDeliveryMode,
                highRiskCause: highRiskCause,
                birthPlan: birthPlan,
                deliveryDate: deliveryDate,
                deliveryAddress: deliveryAddress,
                deliveryMode: deliveryMode,
                ashaName: ashaName,
                ashaContact: ashaContact,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AncRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AncRecordsTable,
      AncRecord,
      $$AncRecordsTableFilterComposer,
      $$AncRecordsTableOrderingComposer,
      $$AncRecordsTableAnnotationComposer,
      $$AncRecordsTableCreateCompanionBuilder,
      $$AncRecordsTableUpdateCompanionBuilder,
      (AncRecord, BaseReferences<_$AppDatabase, $AncRecordsTable, AncRecord>),
      AncRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AncRecordsTableTableManager get ancRecords =>
      $$AncRecordsTableTableManager(_db, _db.ancRecords);
}
