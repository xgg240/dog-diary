// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PetsTable extends Pets with TableInfo<$PetsTable, Pet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
      'breed', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthdayMeta =
      const VerificationMeta('birthday');
  @override
  late final GeneratedColumn<DateTime> birthday = GeneratedColumn<DateTime>(
      'birthday', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _neuteredMeta =
      const VerificationMeta('neutered');
  @override
  late final GeneratedColumn<bool> neutered = GeneratedColumn<bool>(
      'neutered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("neutered" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, breed, birthday, gender, neutered, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pets';
  @override
  VerificationContext validateIntegrity(Insertable<Pet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('breed')) {
      context.handle(
          _breedMeta, breed.isAcceptableOrUnknown(data['breed']!, _breedMeta));
    }
    if (data.containsKey('birthday')) {
      context.handle(_birthdayMeta,
          birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('neutered')) {
      context.handle(_neuteredMeta,
          neutered.isAcceptableOrUnknown(data['neutered']!, _neuteredMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      breed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breed']),
      birthday: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birthday']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      neutered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}neutered'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PetsTable createAlias(String alias) {
    return $PetsTable(attachedDatabase, alias);
  }
}

class Pet extends DataClass implements Insertable<Pet> {
  final int id;
  final String name;
  final String? breed;
  final DateTime? birthday;
  final String gender;
  final bool neutered;
  final String? notes;
  final DateTime createdAt;
  const Pet(
      {required this.id,
      required this.name,
      this.breed,
      this.birthday,
      required this.gender,
      required this.neutered,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || breed != null) {
      map['breed'] = Variable<String>(breed);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    map['gender'] = Variable<String>(gender);
    map['neutered'] = Variable<bool>(neutered);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PetsCompanion toCompanion(bool nullToAbsent) {
    return PetsCompanion(
      id: Value(id),
      name: Value(name),
      breed:
          breed == null && nullToAbsent ? const Value.absent() : Value(breed),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      gender: Value(gender),
      neutered: Value(neutered),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pet(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      breed: serializer.fromJson<String?>(json['breed']),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
      gender: serializer.fromJson<String>(json['gender']),
      neutered: serializer.fromJson<bool>(json['neutered']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'breed': serializer.toJson<String?>(breed),
      'birthday': serializer.toJson<DateTime?>(birthday),
      'gender': serializer.toJson<String>(gender),
      'neutered': serializer.toJson<bool>(neutered),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Pet copyWith(
          {int? id,
          String? name,
          Value<String?> breed = const Value.absent(),
          Value<DateTime?> birthday = const Value.absent(),
          String? gender,
          bool? neutered,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Pet(
        id: id ?? this.id,
        name: name ?? this.name,
        breed: breed.present ? breed.value : this.breed,
        birthday: birthday.present ? birthday.value : this.birthday,
        gender: gender ?? this.gender,
        neutered: neutered ?? this.neutered,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Pet copyWithCompanion(PetsCompanion data) {
    return Pet(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      breed: data.breed.present ? data.breed.value : this.breed,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      gender: data.gender.present ? data.gender.value : this.gender,
      neutered: data.neutered.present ? data.neutered.value : this.neutered,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('birthday: $birthday, ')
          ..write('gender: $gender, ')
          ..write('neutered: $neutered, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, breed, birthday, gender, neutered, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pet &&
          other.id == this.id &&
          other.name == this.name &&
          other.breed == this.breed &&
          other.birthday == this.birthday &&
          other.gender == this.gender &&
          other.neutered == this.neutered &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PetsCompanion extends UpdateCompanion<Pet> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> breed;
  final Value<DateTime?> birthday;
  final Value<String> gender;
  final Value<bool> neutered;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const PetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.breed = const Value.absent(),
    this.birthday = const Value.absent(),
    this.gender = const Value.absent(),
    this.neutered = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.breed = const Value.absent(),
    this.birthday = const Value.absent(),
    required String gender,
    this.neutered = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        gender = Value(gender);
  static Insertable<Pet> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? breed,
    Expression<DateTime>? birthday,
    Expression<String>? gender,
    Expression<bool>? neutered,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (breed != null) 'breed': breed,
      if (birthday != null) 'birthday': birthday,
      if (gender != null) 'gender': gender,
      if (neutered != null) 'neutered': neutered,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? breed,
      Value<DateTime?>? birthday,
      Value<String>? gender,
      Value<bool>? neutered,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return PetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      neutered: neutered ?? this.neutered,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (neutered.present) {
      map['neutered'] = Variable<bool>(neutered.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('birthday: $birthday, ')
          ..write('gender: $gender, ')
          ..write('neutered: $neutered, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WeightRecordsTable extends WeightRecords
    with TableInfo<$WeightRecordsTable, WeightRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _measuredAtMeta =
      const VerificationMeta('measuredAt');
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
      'measured_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, petId, measuredAt, weightKg, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_records';
  @override
  VerificationContext validateIntegrity(Insertable<WeightRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
          _measuredAtMeta,
          measuredAt.isAcceptableOrUnknown(
              data['measured_at']!, _measuredAtMeta));
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      measuredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}measured_at'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $WeightRecordsTable createAlias(String alias) {
    return $WeightRecordsTable(attachedDatabase, alias);
  }
}

class WeightRecord extends DataClass implements Insertable<WeightRecord> {
  final int id;
  final int petId;
  final DateTime measuredAt;
  final double weightKg;
  final String? notes;
  const WeightRecord(
      {required this.id,
      required this.petId,
      required this.measuredAt,
      required this.weightKg,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WeightRecordsCompanion toCompanion(bool nullToAbsent) {
    return WeightRecordsCompanion(
      id: Value(id),
      petId: Value(petId),
      measuredAt: Value(measuredAt),
      weightKg: Value(weightKg),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WeightRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightRecord(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'weightKg': serializer.toJson<double>(weightKg),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WeightRecord copyWith(
          {int? id,
          int? petId,
          DateTime? measuredAt,
          double? weightKg,
          Value<String?> notes = const Value.absent()}) =>
      WeightRecord(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        measuredAt: measuredAt ?? this.measuredAt,
        weightKg: weightKg ?? this.weightKg,
        notes: notes.present ? notes.value : this.notes,
      );
  WeightRecord copyWithCompanion(WeightRecordsCompanion data) {
    return WeightRecord(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      measuredAt:
          data.measuredAt.present ? data.measuredAt.value : this.measuredAt,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecord(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, petId, measuredAt, weightKg, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightRecord &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.measuredAt == this.measuredAt &&
          other.weightKg == this.weightKg &&
          other.notes == this.notes);
}

class WeightRecordsCompanion extends UpdateCompanion<WeightRecord> {
  final Value<int> id;
  final Value<int> petId;
  final Value<DateTime> measuredAt;
  final Value<double> weightKg;
  final Value<String?> notes;
  const WeightRecordsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WeightRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    required DateTime measuredAt,
    required double weightKg,
    this.notes = const Value.absent(),
  })  : petId = Value(petId),
        measuredAt = Value(measuredAt),
        weightKg = Value(weightKg);
  static Insertable<WeightRecord> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<DateTime>? measuredAt,
    Expression<double>? weightKg,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (weightKg != null) 'weight_kg': weightKg,
      if (notes != null) 'notes': notes,
    });
  }

  WeightRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<DateTime>? measuredAt,
      Value<double>? weightKg,
      Value<String?>? notes}) {
    return WeightRecordsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      measuredAt: measuredAt ?? this.measuredAt,
      weightKg: weightKg ?? this.weightKg,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $PetImagesTable extends PetImages
    with TableInfo<$PetImagesTable, PetImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _takenAtMeta =
      const VerificationMeta('takenAt');
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
      'taken_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _captionMeta =
      const VerificationMeta('caption');
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
      'caption', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, petId, path, takenAt, caption];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pet_images';
  @override
  VerificationContext validateIntegrity(Insertable<PetImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(_takenAtMeta,
          takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta));
    }
    if (data.containsKey('caption')) {
      context.handle(_captionMeta,
          caption.isAcceptableOrUnknown(data['caption']!, _captionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PetImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PetImage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      takenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}taken_at']),
      caption: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}caption']),
    );
  }

  @override
  $PetImagesTable createAlias(String alias) {
    return $PetImagesTable(attachedDatabase, alias);
  }
}

class PetImage extends DataClass implements Insertable<PetImage> {
  final int id;
  final int petId;
  final String path;
  final DateTime? takenAt;
  final String? caption;
  const PetImage(
      {required this.id,
      required this.petId,
      required this.path,
      this.takenAt,
      this.caption});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<DateTime>(takenAt);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    return map;
  }

  PetImagesCompanion toCompanion(bool nullToAbsent) {
    return PetImagesCompanion(
      id: Value(id),
      petId: Value(petId),
      path: Value(path),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
    );
  }

  factory PetImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PetImage(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      path: serializer.fromJson<String>(json['path']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      caption: serializer.fromJson<String?>(json['caption']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'path': serializer.toJson<String>(path),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'caption': serializer.toJson<String?>(caption),
    };
  }

  PetImage copyWith(
          {int? id,
          int? petId,
          String? path,
          Value<DateTime?> takenAt = const Value.absent(),
          Value<String?> caption = const Value.absent()}) =>
      PetImage(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        path: path ?? this.path,
        takenAt: takenAt.present ? takenAt.value : this.takenAt,
        caption: caption.present ? caption.value : this.caption,
      );
  PetImage copyWithCompanion(PetImagesCompanion data) {
    return PetImage(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      path: data.path.present ? data.path.value : this.path,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      caption: data.caption.present ? data.caption.value : this.caption,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PetImage(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('path: $path, ')
          ..write('takenAt: $takenAt, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, petId, path, takenAt, caption);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PetImage &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.path == this.path &&
          other.takenAt == this.takenAt &&
          other.caption == this.caption);
}

class PetImagesCompanion extends UpdateCompanion<PetImage> {
  final Value<int> id;
  final Value<int> petId;
  final Value<String> path;
  final Value<DateTime?> takenAt;
  final Value<String?> caption;
  const PetImagesCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.path = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.caption = const Value.absent(),
  });
  PetImagesCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    required String path,
    this.takenAt = const Value.absent(),
    this.caption = const Value.absent(),
  })  : petId = Value(petId),
        path = Value(path);
  static Insertable<PetImage> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<String>? path,
    Expression<DateTime>? takenAt,
    Expression<String>? caption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (path != null) 'path': path,
      if (takenAt != null) 'taken_at': takenAt,
      if (caption != null) 'caption': caption,
    });
  }

  PetImagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<String>? path,
      Value<DateTime?>? takenAt,
      Value<String?>? caption}) {
    return PetImagesCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      path: path ?? this.path,
      takenAt: takenAt ?? this.takenAt,
      caption: caption ?? this.caption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetImagesCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('path: $path, ')
          ..write('takenAt: $takenAt, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }
}

class $HealthEventsTable extends HealthEvents
    with TableInfo<$HealthEventsTable, HealthEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eventDateMeta =
      const VerificationMeta('eventDate');
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
      'event_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
      'dosage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vetNameMeta =
      const VerificationMeta('vetName');
  @override
  late final GeneratedColumn<String> vetName = GeneratedColumn<String>(
      'vet_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vetContactMeta =
      const VerificationMeta('vetContact');
  @override
  late final GeneratedColumn<String> vetContact = GeneratedColumn<String>(
      'vet_contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
      'cost', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
      'attachments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        petId,
        type,
        title,
        description,
        eventDate,
        nextDueDate,
        frequency,
        dosage,
        vetName,
        vetContact,
        cost,
        attachments
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_events';
  @override
  VerificationContext validateIntegrity(Insertable<HealthEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('event_date')) {
      context.handle(_eventDateMeta,
          eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta));
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    }
    if (data.containsKey('vet_name')) {
      context.handle(_vetNameMeta,
          vetName.isAcceptableOrUnknown(data['vet_name']!, _vetNameMeta));
    }
    if (data.containsKey('vet_contact')) {
      context.handle(
          _vetContactMeta,
          vetContact.isAcceptableOrUnknown(
              data['vet_contact']!, _vetContactMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    }
    if (data.containsKey('attachments')) {
      context.handle(
          _attachmentsMeta,
          attachments.isAcceptableOrUnknown(
              data['attachments']!, _attachmentsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      eventDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}event_date'])!,
      nextDueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_due_date']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency']),
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage']),
      vetName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vet_name']),
      vetContact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vet_contact']),
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost']),
      attachments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachments']),
    );
  }

  @override
  $HealthEventsTable createAlias(String alias) {
    return $HealthEventsTable(attachedDatabase, alias);
  }
}

class HealthEvent extends DataClass implements Insertable<HealthEvent> {
  final int id;
  final int petId;
  final String type;
  final String title;
  final String? description;
  final DateTime eventDate;
  final DateTime? nextDueDate;
  final String? frequency;
  final String? dosage;
  final String? vetName;
  final String? vetContact;
  final double? cost;
  final String? attachments;
  const HealthEvent(
      {required this.id,
      required this.petId,
      required this.type,
      required this.title,
      this.description,
      required this.eventDate,
      this.nextDueDate,
      this.frequency,
      this.dosage,
      this.vetName,
      this.vetContact,
      this.cost,
      this.attachments});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['event_date'] = Variable<DateTime>(eventDate);
    if (!nullToAbsent || nextDueDate != null) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate);
    }
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<String>(frequency);
    }
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || vetName != null) {
      map['vet_name'] = Variable<String>(vetName);
    }
    if (!nullToAbsent || vetContact != null) {
      map['vet_contact'] = Variable<String>(vetContact);
    }
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    return map;
  }

  HealthEventsCompanion toCompanion(bool nullToAbsent) {
    return HealthEventsCompanion(
      id: Value(id),
      petId: Value(petId),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      eventDate: Value(eventDate),
      nextDueDate: nextDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueDate),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      dosage:
          dosage == null && nullToAbsent ? const Value.absent() : Value(dosage),
      vetName: vetName == null && nullToAbsent
          ? const Value.absent()
          : Value(vetName),
      vetContact: vetContact == null && nullToAbsent
          ? const Value.absent()
          : Value(vetContact),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
    );
  }

  factory HealthEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthEvent(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      nextDueDate: serializer.fromJson<DateTime?>(json['nextDueDate']),
      frequency: serializer.fromJson<String?>(json['frequency']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      vetName: serializer.fromJson<String?>(json['vetName']),
      vetContact: serializer.fromJson<String?>(json['vetContact']),
      cost: serializer.fromJson<double?>(json['cost']),
      attachments: serializer.fromJson<String?>(json['attachments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'nextDueDate': serializer.toJson<DateTime?>(nextDueDate),
      'frequency': serializer.toJson<String?>(frequency),
      'dosage': serializer.toJson<String?>(dosage),
      'vetName': serializer.toJson<String?>(vetName),
      'vetContact': serializer.toJson<String?>(vetContact),
      'cost': serializer.toJson<double?>(cost),
      'attachments': serializer.toJson<String?>(attachments),
    };
  }

  HealthEvent copyWith(
          {int? id,
          int? petId,
          String? type,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? eventDate,
          Value<DateTime?> nextDueDate = const Value.absent(),
          Value<String?> frequency = const Value.absent(),
          Value<String?> dosage = const Value.absent(),
          Value<String?> vetName = const Value.absent(),
          Value<String?> vetContact = const Value.absent(),
          Value<double?> cost = const Value.absent(),
          Value<String?> attachments = const Value.absent()}) =>
      HealthEvent(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        type: type ?? this.type,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        eventDate: eventDate ?? this.eventDate,
        nextDueDate: nextDueDate.present ? nextDueDate.value : this.nextDueDate,
        frequency: frequency.present ? frequency.value : this.frequency,
        dosage: dosage.present ? dosage.value : this.dosage,
        vetName: vetName.present ? vetName.value : this.vetName,
        vetContact: vetContact.present ? vetContact.value : this.vetContact,
        cost: cost.present ? cost.value : this.cost,
        attachments: attachments.present ? attachments.value : this.attachments,
      );
  HealthEvent copyWithCompanion(HealthEventsCompanion data) {
    return HealthEvent(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      vetName: data.vetName.present ? data.vetName.value : this.vetName,
      vetContact:
          data.vetContact.present ? data.vetContact.value : this.vetContact,
      cost: data.cost.present ? data.cost.value : this.cost,
      attachments:
          data.attachments.present ? data.attachments.value : this.attachments,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthEvent(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('eventDate: $eventDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('frequency: $frequency, ')
          ..write('dosage: $dosage, ')
          ..write('vetName: $vetName, ')
          ..write('vetContact: $vetContact, ')
          ..write('cost: $cost, ')
          ..write('attachments: $attachments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      petId,
      type,
      title,
      description,
      eventDate,
      nextDueDate,
      frequency,
      dosage,
      vetName,
      vetContact,
      cost,
      attachments);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthEvent &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.eventDate == this.eventDate &&
          other.nextDueDate == this.nextDueDate &&
          other.frequency == this.frequency &&
          other.dosage == this.dosage &&
          other.vetName == this.vetName &&
          other.vetContact == this.vetContact &&
          other.cost == this.cost &&
          other.attachments == this.attachments);
}

class HealthEventsCompanion extends UpdateCompanion<HealthEvent> {
  final Value<int> id;
  final Value<int> petId;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> eventDate;
  final Value<DateTime?> nextDueDate;
  final Value<String?> frequency;
  final Value<String?> dosage;
  final Value<String?> vetName;
  final Value<String?> vetContact;
  final Value<double?> cost;
  final Value<String?> attachments;
  const HealthEventsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dosage = const Value.absent(),
    this.vetName = const Value.absent(),
    this.vetContact = const Value.absent(),
    this.cost = const Value.absent(),
    this.attachments = const Value.absent(),
  });
  HealthEventsCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    required String type,
    required String title,
    this.description = const Value.absent(),
    required DateTime eventDate,
    this.nextDueDate = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dosage = const Value.absent(),
    this.vetName = const Value.absent(),
    this.vetContact = const Value.absent(),
    this.cost = const Value.absent(),
    this.attachments = const Value.absent(),
  })  : petId = Value(petId),
        type = Value(type),
        title = Value(title),
        eventDate = Value(eventDate);
  static Insertable<HealthEvent> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? eventDate,
    Expression<DateTime>? nextDueDate,
    Expression<String>? frequency,
    Expression<String>? dosage,
    Expression<String>? vetName,
    Expression<String>? vetContact,
    Expression<double>? cost,
    Expression<String>? attachments,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (eventDate != null) 'event_date': eventDate,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (frequency != null) 'frequency': frequency,
      if (dosage != null) 'dosage': dosage,
      if (vetName != null) 'vet_name': vetName,
      if (vetContact != null) 'vet_contact': vetContact,
      if (cost != null) 'cost': cost,
      if (attachments != null) 'attachments': attachments,
    });
  }

  HealthEventsCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<String>? type,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? eventDate,
      Value<DateTime?>? nextDueDate,
      Value<String?>? frequency,
      Value<String?>? dosage,
      Value<String?>? vetName,
      Value<String?>? vetContact,
      Value<double?>? cost,
      Value<String?>? attachments}) {
    return HealthEventsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      frequency: frequency ?? this.frequency,
      dosage: dosage ?? this.dosage,
      vetName: vetName ?? this.vetName,
      vetContact: vetContact ?? this.vetContact,
      cost: cost ?? this.cost,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (vetName.present) {
      map['vet_name'] = Variable<String>(vetName.value);
    }
    if (vetContact.present) {
      map['vet_contact'] = Variable<String>(vetContact.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthEventsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('eventDate: $eventDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('frequency: $frequency, ')
          ..write('dosage: $dosage, ')
          ..write('vetName: $vetName, ')
          ..write('vetContact: $vetContact, ')
          ..write('cost: $cost, ')
          ..write('attachments: $attachments')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
      'dosage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, petId, name, dosage, frequency, startDate, endDate, notes, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<Medication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final int id;
  final int petId;
  final String name;
  final String? dosage;
  final String? frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final bool active;
  const Medication(
      {required this.id,
      required this.petId,
      required this.name,
      this.dosage,
      this.frequency,
      required this.startDate,
      this.endDate,
      this.notes,
      required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<String>(frequency);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      petId: Value(petId),
      name: Value(name),
      dosage:
          dosage == null && nullToAbsent ? const Value.absent() : Value(dosage),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      active: Value(active),
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      frequency: serializer.fromJson<String?>(json['frequency']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String?>(dosage),
      'frequency': serializer.toJson<String?>(frequency),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'notes': serializer.toJson<String?>(notes),
      'active': serializer.toJson<bool>(active),
    };
  }

  Medication copyWith(
          {int? id,
          int? petId,
          String? name,
          Value<String?> dosage = const Value.absent(),
          Value<String?> frequency = const Value.absent(),
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? active}) =>
      Medication(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        name: name ?? this.name,
        dosage: dosage.present ? dosage.value : this.dosage,
        frequency: frequency.present ? frequency.value : this.frequency,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        notes: notes.present ? notes.value : this.notes,
        active: active ?? this.active,
      );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, petId, name, dosage, frequency, startDate, endDate, notes, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.notes == this.notes &&
          other.active == this.active);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<int> petId;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<String?> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> notes;
  final Value<bool> active;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    required String name,
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
  })  : petId = Value(petId),
        name = Value(name),
        startDate = Value(startDate);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? notes,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (notes != null) 'notes': notes,
      if (active != null) 'active': active,
    });
  }

  MedicationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<String>? name,
      Value<String?>? dosage,
      Value<String?>? frequency,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<String?>? notes,
      Value<bool>? active}) {
    return MedicationsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodInventory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('kibble'));
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flavorMeta = const VerificationMeta('flavor');
  @override
  late final GeneratedColumn<String> flavor = GeneratedColumn<String>(
      'flavor', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalKgMeta =
      const VerificationMeta('totalKg');
  @override
  late final GeneratedColumn<double> totalKg = GeneratedColumn<double>(
      'total_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _remainingKgMeta =
      const VerificationMeta('remainingKg');
  @override
  late final GeneratedColumn<double> remainingKg = GeneratedColumn<double>(
      'remaining_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pricePerKgMeta =
      const VerificationMeta('pricePerKg');
  @override
  late final GeneratedColumn<double> pricePerKg = GeneratedColumn<double>(
      'price_per_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _blacklistedMeta =
      const VerificationMeta('blacklisted');
  @override
  late final GeneratedColumn<bool> blacklisted = GeneratedColumn<bool>(
      'blacklisted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("blacklisted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _allergyReasonMeta =
      const VerificationMeta('allergyReason');
  @override
  late final GeneratedColumn<String> allergyReason = GeneratedColumn<String>(
      'allergy_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expireDateMeta =
      const VerificationMeta('expireDate');
  @override
  late final GeneratedColumn<DateTime> expireDate = GeneratedColumn<DateTime>(
      'expire_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        petId,
        category,
        brand,
        productName,
        flavor,
        totalKg,
        remainingKg,
        pricePerKg,
        blacklisted,
        allergyReason,
        purchaseDate,
        expireDate,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(Insertable<FoodInventory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('flavor')) {
      context.handle(_flavorMeta,
          flavor.isAcceptableOrUnknown(data['flavor']!, _flavorMeta));
    }
    if (data.containsKey('total_kg')) {
      context.handle(_totalKgMeta,
          totalKg.isAcceptableOrUnknown(data['total_kg']!, _totalKgMeta));
    } else if (isInserting) {
      context.missing(_totalKgMeta);
    }
    if (data.containsKey('remaining_kg')) {
      context.handle(
          _remainingKgMeta,
          remainingKg.isAcceptableOrUnknown(
              data['remaining_kg']!, _remainingKgMeta));
    } else if (isInserting) {
      context.missing(_remainingKgMeta);
    }
    if (data.containsKey('price_per_kg')) {
      context.handle(
          _pricePerKgMeta,
          pricePerKg.isAcceptableOrUnknown(
              data['price_per_kg']!, _pricePerKgMeta));
    }
    if (data.containsKey('blacklisted')) {
      context.handle(
          _blacklistedMeta,
          blacklisted.isAcceptableOrUnknown(
              data['blacklisted']!, _blacklistedMeta));
    }
    if (data.containsKey('allergy_reason')) {
      context.handle(
          _allergyReasonMeta,
          allergyReason.isAcceptableOrUnknown(
              data['allergy_reason']!, _allergyReasonMeta));
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('expire_date')) {
      context.handle(
          _expireDateMeta,
          expireDate.isAcceptableOrUnknown(
              data['expire_date']!, _expireDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodInventory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodInventory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      flavor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flavor']),
      totalKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_kg'])!,
      remainingKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}remaining_kg'])!,
      pricePerKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_kg']),
      blacklisted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}blacklisted'])!,
      allergyReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}allergy_reason']),
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      expireDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expire_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodInventory extends DataClass implements Insertable<FoodInventory> {
  final int id;
  final int? petId;
  final String category;
  final String brand;
  final String productName;
  final String? flavor;
  final double totalKg;
  final double remainingKg;
  final double? pricePerKg;
  final bool blacklisted;
  final String? allergyReason;
  final DateTime purchaseDate;
  final DateTime? expireDate;
  final String? notes;
  const FoodInventory(
      {required this.id,
      this.petId,
      required this.category,
      required this.brand,
      required this.productName,
      this.flavor,
      required this.totalKg,
      required this.remainingKg,
      this.pricePerKg,
      required this.blacklisted,
      this.allergyReason,
      required this.purchaseDate,
      this.expireDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || petId != null) {
      map['pet_id'] = Variable<int>(petId);
    }
    map['category'] = Variable<String>(category);
    map['brand'] = Variable<String>(brand);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || flavor != null) {
      map['flavor'] = Variable<String>(flavor);
    }
    map['total_kg'] = Variable<double>(totalKg);
    map['remaining_kg'] = Variable<double>(remainingKg);
    if (!nullToAbsent || pricePerKg != null) {
      map['price_per_kg'] = Variable<double>(pricePerKg);
    }
    map['blacklisted'] = Variable<bool>(blacklisted);
    if (!nullToAbsent || allergyReason != null) {
      map['allergy_reason'] = Variable<String>(allergyReason);
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || expireDate != null) {
      map['expire_date'] = Variable<DateTime>(expireDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      petId:
          petId == null && nullToAbsent ? const Value.absent() : Value(petId),
      category: Value(category),
      brand: Value(brand),
      productName: Value(productName),
      flavor:
          flavor == null && nullToAbsent ? const Value.absent() : Value(flavor),
      totalKg: Value(totalKg),
      remainingKg: Value(remainingKg),
      pricePerKg: pricePerKg == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerKg),
      blacklisted: Value(blacklisted),
      allergyReason: allergyReason == null && nullToAbsent
          ? const Value.absent()
          : Value(allergyReason),
      purchaseDate: Value(purchaseDate),
      expireDate: expireDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expireDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory FoodInventory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodInventory(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int?>(json['petId']),
      category: serializer.fromJson<String>(json['category']),
      brand: serializer.fromJson<String>(json['brand']),
      productName: serializer.fromJson<String>(json['productName']),
      flavor: serializer.fromJson<String?>(json['flavor']),
      totalKg: serializer.fromJson<double>(json['totalKg']),
      remainingKg: serializer.fromJson<double>(json['remainingKg']),
      pricePerKg: serializer.fromJson<double?>(json['pricePerKg']),
      blacklisted: serializer.fromJson<bool>(json['blacklisted']),
      allergyReason: serializer.fromJson<String?>(json['allergyReason']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      expireDate: serializer.fromJson<DateTime?>(json['expireDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int?>(petId),
      'category': serializer.toJson<String>(category),
      'brand': serializer.toJson<String>(brand),
      'productName': serializer.toJson<String>(productName),
      'flavor': serializer.toJson<String?>(flavor),
      'totalKg': serializer.toJson<double>(totalKg),
      'remainingKg': serializer.toJson<double>(remainingKg),
      'pricePerKg': serializer.toJson<double?>(pricePerKg),
      'blacklisted': serializer.toJson<bool>(blacklisted),
      'allergyReason': serializer.toJson<String?>(allergyReason),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'expireDate': serializer.toJson<DateTime?>(expireDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FoodInventory copyWith(
          {int? id,
          Value<int?> petId = const Value.absent(),
          String? category,
          String? brand,
          String? productName,
          Value<String?> flavor = const Value.absent(),
          double? totalKg,
          double? remainingKg,
          Value<double?> pricePerKg = const Value.absent(),
          bool? blacklisted,
          Value<String?> allergyReason = const Value.absent(),
          DateTime? purchaseDate,
          Value<DateTime?> expireDate = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      FoodInventory(
        id: id ?? this.id,
        petId: petId.present ? petId.value : this.petId,
        category: category ?? this.category,
        brand: brand ?? this.brand,
        productName: productName ?? this.productName,
        flavor: flavor.present ? flavor.value : this.flavor,
        totalKg: totalKg ?? this.totalKg,
        remainingKg: remainingKg ?? this.remainingKg,
        pricePerKg: pricePerKg.present ? pricePerKg.value : this.pricePerKg,
        blacklisted: blacklisted ?? this.blacklisted,
        allergyReason:
            allergyReason.present ? allergyReason.value : this.allergyReason,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        expireDate: expireDate.present ? expireDate.value : this.expireDate,
        notes: notes.present ? notes.value : this.notes,
      );
  FoodInventory copyWithCompanion(FoodItemsCompanion data) {
    return FoodInventory(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      category: data.category.present ? data.category.value : this.category,
      brand: data.brand.present ? data.brand.value : this.brand,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      flavor: data.flavor.present ? data.flavor.value : this.flavor,
      totalKg: data.totalKg.present ? data.totalKg.value : this.totalKg,
      remainingKg:
          data.remainingKg.present ? data.remainingKg.value : this.remainingKg,
      pricePerKg:
          data.pricePerKg.present ? data.pricePerKg.value : this.pricePerKg,
      blacklisted:
          data.blacklisted.present ? data.blacklisted.value : this.blacklisted,
      allergyReason: data.allergyReason.present
          ? data.allergyReason.value
          : this.allergyReason,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      expireDate:
          data.expireDate.present ? data.expireDate.value : this.expireDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodInventory(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('category: $category, ')
          ..write('brand: $brand, ')
          ..write('productName: $productName, ')
          ..write('flavor: $flavor, ')
          ..write('totalKg: $totalKg, ')
          ..write('remainingKg: $remainingKg, ')
          ..write('pricePerKg: $pricePerKg, ')
          ..write('blacklisted: $blacklisted, ')
          ..write('allergyReason: $allergyReason, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expireDate: $expireDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      petId,
      category,
      brand,
      productName,
      flavor,
      totalKg,
      remainingKg,
      pricePerKg,
      blacklisted,
      allergyReason,
      purchaseDate,
      expireDate,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodInventory &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.category == this.category &&
          other.brand == this.brand &&
          other.productName == this.productName &&
          other.flavor == this.flavor &&
          other.totalKg == this.totalKg &&
          other.remainingKg == this.remainingKg &&
          other.pricePerKg == this.pricePerKg &&
          other.blacklisted == this.blacklisted &&
          other.allergyReason == this.allergyReason &&
          other.purchaseDate == this.purchaseDate &&
          other.expireDate == this.expireDate &&
          other.notes == this.notes);
}

class FoodItemsCompanion extends UpdateCompanion<FoodInventory> {
  final Value<int> id;
  final Value<int?> petId;
  final Value<String> category;
  final Value<String> brand;
  final Value<String> productName;
  final Value<String?> flavor;
  final Value<double> totalKg;
  final Value<double> remainingKg;
  final Value<double?> pricePerKg;
  final Value<bool> blacklisted;
  final Value<String?> allergyReason;
  final Value<DateTime> purchaseDate;
  final Value<DateTime?> expireDate;
  final Value<String?> notes;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.category = const Value.absent(),
    this.brand = const Value.absent(),
    this.productName = const Value.absent(),
    this.flavor = const Value.absent(),
    this.totalKg = const Value.absent(),
    this.remainingKg = const Value.absent(),
    this.pricePerKg = const Value.absent(),
    this.blacklisted = const Value.absent(),
    this.allergyReason = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expireDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.category = const Value.absent(),
    required String brand,
    required String productName,
    this.flavor = const Value.absent(),
    required double totalKg,
    required double remainingKg,
    this.pricePerKg = const Value.absent(),
    this.blacklisted = const Value.absent(),
    this.allergyReason = const Value.absent(),
    required DateTime purchaseDate,
    this.expireDate = const Value.absent(),
    this.notes = const Value.absent(),
  })  : brand = Value(brand),
        productName = Value(productName),
        totalKg = Value(totalKg),
        remainingKg = Value(remainingKg),
        purchaseDate = Value(purchaseDate);
  static Insertable<FoodInventory> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<String>? category,
    Expression<String>? brand,
    Expression<String>? productName,
    Expression<String>? flavor,
    Expression<double>? totalKg,
    Expression<double>? remainingKg,
    Expression<double>? pricePerKg,
    Expression<bool>? blacklisted,
    Expression<String>? allergyReason,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? expireDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (category != null) 'category': category,
      if (brand != null) 'brand': brand,
      if (productName != null) 'product_name': productName,
      if (flavor != null) 'flavor': flavor,
      if (totalKg != null) 'total_kg': totalKg,
      if (remainingKg != null) 'remaining_kg': remainingKg,
      if (pricePerKg != null) 'price_per_kg': pricePerKg,
      if (blacklisted != null) 'blacklisted': blacklisted,
      if (allergyReason != null) 'allergy_reason': allergyReason,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (expireDate != null) 'expire_date': expireDate,
      if (notes != null) 'notes': notes,
    });
  }

  FoodItemsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? petId,
      Value<String>? category,
      Value<String>? brand,
      Value<String>? productName,
      Value<String?>? flavor,
      Value<double>? totalKg,
      Value<double>? remainingKg,
      Value<double?>? pricePerKg,
      Value<bool>? blacklisted,
      Value<String?>? allergyReason,
      Value<DateTime>? purchaseDate,
      Value<DateTime?>? expireDate,
      Value<String?>? notes}) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      productName: productName ?? this.productName,
      flavor: flavor ?? this.flavor,
      totalKg: totalKg ?? this.totalKg,
      remainingKg: remainingKg ?? this.remainingKg,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      blacklisted: blacklisted ?? this.blacklisted,
      allergyReason: allergyReason ?? this.allergyReason,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expireDate: expireDate ?? this.expireDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (flavor.present) {
      map['flavor'] = Variable<String>(flavor.value);
    }
    if (totalKg.present) {
      map['total_kg'] = Variable<double>(totalKg.value);
    }
    if (remainingKg.present) {
      map['remaining_kg'] = Variable<double>(remainingKg.value);
    }
    if (pricePerKg.present) {
      map['price_per_kg'] = Variable<double>(pricePerKg.value);
    }
    if (blacklisted.present) {
      map['blacklisted'] = Variable<bool>(blacklisted.value);
    }
    if (allergyReason.present) {
      map['allergy_reason'] = Variable<String>(allergyReason.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (expireDate.present) {
      map['expire_date'] = Variable<DateTime>(expireDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('category: $category, ')
          ..write('brand: $brand, ')
          ..write('productName: $productName, ')
          ..write('flavor: $flavor, ')
          ..write('totalKg: $totalKg, ')
          ..write('remainingKg: $remainingKg, ')
          ..write('pricePerKg: $pricePerKg, ')
          ..write('blacklisted: $blacklisted, ')
          ..write('allergyReason: $allergyReason, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expireDate: $expireDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $FeedingRecordsTable extends FeedingRecords
    with TableInfo<$FeedingRecordsTable, FeedingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedingRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
      'food_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fedAtMeta = const VerificationMeta('fedAt');
  @override
  late final GeneratedColumn<DateTime> fedAt = GeneratedColumn<DateTime>(
      'fed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _amountKgMeta =
      const VerificationMeta('amountKg');
  @override
  late final GeneratedColumn<double> amountKg = GeneratedColumn<double>(
      'amount_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('meal'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, petId, foodId, fedAt, amountKg, mealType, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feeding_records';
  @override
  VerificationContext validateIntegrity(Insertable<FeedingRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta,
          foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    }
    if (data.containsKey('fed_at')) {
      context.handle(
          _fedAtMeta, fedAt.isAcceptableOrUnknown(data['fed_at']!, _fedAtMeta));
    } else if (isInserting) {
      context.missing(_fedAtMeta);
    }
    if (data.containsKey('amount_kg')) {
      context.handle(_amountKgMeta,
          amountKg.isAcceptableOrUnknown(data['amount_kg']!, _amountKgMeta));
    } else if (isInserting) {
      context.missing(_amountKgMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedingRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      foodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}food_id']),
      fedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fed_at'])!,
      amountKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_kg'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $FeedingRecordsTable createAlias(String alias) {
    return $FeedingRecordsTable(attachedDatabase, alias);
  }
}

class FeedingRecord extends DataClass implements Insertable<FeedingRecord> {
  final int id;
  final int petId;
  final int? foodId;
  final DateTime fedAt;
  final double amountKg;
  final String mealType;
  final String? notes;
  const FeedingRecord(
      {required this.id,
      required this.petId,
      this.foodId,
      required this.fedAt,
      required this.amountKg,
      required this.mealType,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<int>(foodId);
    }
    map['fed_at'] = Variable<DateTime>(fedAt);
    map['amount_kg'] = Variable<double>(amountKg);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FeedingRecordsCompanion toCompanion(bool nullToAbsent) {
    return FeedingRecordsCompanion(
      id: Value(id),
      petId: Value(petId),
      foodId:
          foodId == null && nullToAbsent ? const Value.absent() : Value(foodId),
      fedAt: Value(fedAt),
      amountKg: Value(amountKg),
      mealType: Value(mealType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory FeedingRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedingRecord(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      foodId: serializer.fromJson<int?>(json['foodId']),
      fedAt: serializer.fromJson<DateTime>(json['fedAt']),
      amountKg: serializer.fromJson<double>(json['amountKg']),
      mealType: serializer.fromJson<String>(json['mealType']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'foodId': serializer.toJson<int?>(foodId),
      'fedAt': serializer.toJson<DateTime>(fedAt),
      'amountKg': serializer.toJson<double>(amountKg),
      'mealType': serializer.toJson<String>(mealType),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FeedingRecord copyWith(
          {int? id,
          int? petId,
          Value<int?> foodId = const Value.absent(),
          DateTime? fedAt,
          double? amountKg,
          String? mealType,
          Value<String?> notes = const Value.absent()}) =>
      FeedingRecord(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        foodId: foodId.present ? foodId.value : this.foodId,
        fedAt: fedAt ?? this.fedAt,
        amountKg: amountKg ?? this.amountKg,
        mealType: mealType ?? this.mealType,
        notes: notes.present ? notes.value : this.notes,
      );
  FeedingRecord copyWithCompanion(FeedingRecordsCompanion data) {
    return FeedingRecord(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      fedAt: data.fedAt.present ? data.fedAt.value : this.fedAt,
      amountKg: data.amountKg.present ? data.amountKg.value : this.amountKg,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedingRecord(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('foodId: $foodId, ')
          ..write('fedAt: $fedAt, ')
          ..write('amountKg: $amountKg, ')
          ..write('mealType: $mealType, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, petId, foodId, fedAt, amountKg, mealType, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedingRecord &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.foodId == this.foodId &&
          other.fedAt == this.fedAt &&
          other.amountKg == this.amountKg &&
          other.mealType == this.mealType &&
          other.notes == this.notes);
}

class FeedingRecordsCompanion extends UpdateCompanion<FeedingRecord> {
  final Value<int> id;
  final Value<int> petId;
  final Value<int?> foodId;
  final Value<DateTime> fedAt;
  final Value<double> amountKg;
  final Value<String> mealType;
  final Value<String?> notes;
  const FeedingRecordsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.fedAt = const Value.absent(),
    this.amountKg = const Value.absent(),
    this.mealType = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FeedingRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    this.foodId = const Value.absent(),
    required DateTime fedAt,
    required double amountKg,
    this.mealType = const Value.absent(),
    this.notes = const Value.absent(),
  })  : petId = Value(petId),
        fedAt = Value(fedAt),
        amountKg = Value(amountKg);
  static Insertable<FeedingRecord> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<int>? foodId,
    Expression<DateTime>? fedAt,
    Expression<double>? amountKg,
    Expression<String>? mealType,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (foodId != null) 'food_id': foodId,
      if (fedAt != null) 'fed_at': fedAt,
      if (amountKg != null) 'amount_kg': amountKg,
      if (mealType != null) 'meal_type': mealType,
      if (notes != null) 'notes': notes,
    });
  }

  FeedingRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<int?>? foodId,
      Value<DateTime>? fedAt,
      Value<double>? amountKg,
      Value<String>? mealType,
      Value<String?>? notes}) {
    return FeedingRecordsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      foodId: foodId ?? this.foodId,
      fedAt: fedAt ?? this.fedAt,
      amountKg: amountKg ?? this.amountKg,
      mealType: mealType ?? this.mealType,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (fedAt.present) {
      map['fed_at'] = Variable<DateTime>(fedAt.value);
    }
    if (amountKg.present) {
      map['amount_kg'] = Variable<double>(amountKg.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedingRecordsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('foodId: $foodId, ')
          ..write('fedAt: $fedAt, ')
          ..write('amountKg: $amountKg, ')
          ..write('mealType: $mealType, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _spentAtMeta =
      const VerificationMeta('spentAt');
  @override
  late final GeneratedColumn<DateTime> spentAt = GeneratedColumn<DateTime>(
      'spent_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, petId, spentAt, amount, category, description, paymentMethod];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    }
    if (data.containsKey('spent_at')) {
      context.handle(_spentAtMeta,
          spentAt.isAcceptableOrUnknown(data['spent_at']!, _spentAtMeta));
    } else if (isInserting) {
      context.missing(_spentAtMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id']),
      spentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}spent_at'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int? petId;
  final DateTime spentAt;
  final double amount;
  final String category;
  final String? description;
  final String? paymentMethod;
  const Expense(
      {required this.id,
      this.petId,
      required this.spentAt,
      required this.amount,
      required this.category,
      this.description,
      this.paymentMethod});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || petId != null) {
      map['pet_id'] = Variable<int>(petId);
    }
    map['spent_at'] = Variable<DateTime>(spentAt);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      petId:
          petId == null && nullToAbsent ? const Value.absent() : Value(petId),
      spentAt: Value(spentAt),
      amount: Value(amount),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int?>(json['petId']),
      spentAt: serializer.fromJson<DateTime>(json['spentAt']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int?>(petId),
      'spentAt': serializer.toJson<DateTime>(spentAt),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
    };
  }

  Expense copyWith(
          {int? id,
          Value<int?> petId = const Value.absent(),
          DateTime? spentAt,
          double? amount,
          String? category,
          Value<String?> description = const Value.absent(),
          Value<String?> paymentMethod = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        petId: petId.present ? petId.value : this.petId,
        spentAt: spentAt ?? this.spentAt,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        description: description.present ? description.value : this.description,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      spentAt: data.spentAt.present ? data.spentAt.value : this.spentAt,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('spentAt: $spentAt, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('paymentMethod: $paymentMethod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, petId, spentAt, amount, category, description, paymentMethod);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.spentAt == this.spentAt &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.description == this.description &&
          other.paymentMethod == this.paymentMethod);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int?> petId;
  final Value<DateTime> spentAt;
  final Value<double> amount;
  final Value<String> category;
  final Value<String?> description;
  final Value<String?> paymentMethod;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.spentAt = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentMethod = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    required DateTime spentAt,
    required double amount,
    required String category,
    this.description = const Value.absent(),
    this.paymentMethod = const Value.absent(),
  })  : spentAt = Value(spentAt),
        amount = Value(amount),
        category = Value(category);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<DateTime>? spentAt,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? paymentMethod,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (spentAt != null) 'spent_at': spentAt,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? petId,
      Value<DateTime>? spentAt,
      Value<double>? amount,
      Value<String>? category,
      Value<String?>? description,
      Value<String?>? paymentMethod}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      spentAt: spentAt ?? this.spentAt,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (spentAt.present) {
      map['spent_at'] = Variable<DateTime>(spentAt.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('spentAt: $spentAt, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('paymentMethod: $paymentMethod')
          ..write(')'))
        .toString();
  }
}

class $WalkRecordsTable extends WalkRecords
    with TableInfo<$WalkRecordsTable, WalkRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalkRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _walkedAtMeta =
      const VerificationMeta('walkedAt');
  @override
  late final GeneratedColumn<DateTime> walkedAt = GeneratedColumn<DateTime>(
      'walked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationMinMeta =
      const VerificationMeta('durationMin');
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
      'duration_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _distanceKmMeta =
      const VerificationMeta('distanceKm');
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
      'distance_km', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
      'route', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, petId, walkedAt, durationMin, distanceKm, route, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'walk_records';
  @override
  VerificationContext validateIntegrity(Insertable<WalkRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('walked_at')) {
      context.handle(_walkedAtMeta,
          walkedAt.isAcceptableOrUnknown(data['walked_at']!, _walkedAtMeta));
    } else if (isInserting) {
      context.missing(_walkedAtMeta);
    }
    if (data.containsKey('duration_min')) {
      context.handle(
          _durationMinMeta,
          durationMin.isAcceptableOrUnknown(
              data['duration_min']!, _durationMinMeta));
    } else if (isInserting) {
      context.missing(_durationMinMeta);
    }
    if (data.containsKey('distance_km')) {
      context.handle(
          _distanceKmMeta,
          distanceKm.isAcceptableOrUnknown(
              data['distance_km']!, _distanceKmMeta));
    }
    if (data.containsKey('route')) {
      context.handle(
          _routeMeta, route.isAcceptableOrUnknown(data['route']!, _routeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalkRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalkRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      walkedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}walked_at'])!,
      durationMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_min'])!,
      distanceKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance_km']),
      route: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $WalkRecordsTable createAlias(String alias) {
    return $WalkRecordsTable(attachedDatabase, alias);
  }
}

class WalkRecord extends DataClass implements Insertable<WalkRecord> {
  final int id;
  final int petId;
  final DateTime walkedAt;
  final int durationMin;
  final double? distanceKm;
  final String? route;
  final String? notes;
  const WalkRecord(
      {required this.id,
      required this.petId,
      required this.walkedAt,
      required this.durationMin,
      this.distanceKm,
      this.route,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    map['walked_at'] = Variable<DateTime>(walkedAt);
    map['duration_min'] = Variable<int>(durationMin);
    if (!nullToAbsent || distanceKm != null) {
      map['distance_km'] = Variable<double>(distanceKm);
    }
    if (!nullToAbsent || route != null) {
      map['route'] = Variable<String>(route);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WalkRecordsCompanion toCompanion(bool nullToAbsent) {
    return WalkRecordsCompanion(
      id: Value(id),
      petId: Value(petId),
      walkedAt: Value(walkedAt),
      durationMin: Value(durationMin),
      distanceKm: distanceKm == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceKm),
      route:
          route == null && nullToAbsent ? const Value.absent() : Value(route),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WalkRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalkRecord(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      walkedAt: serializer.fromJson<DateTime>(json['walkedAt']),
      durationMin: serializer.fromJson<int>(json['durationMin']),
      distanceKm: serializer.fromJson<double?>(json['distanceKm']),
      route: serializer.fromJson<String?>(json['route']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'walkedAt': serializer.toJson<DateTime>(walkedAt),
      'durationMin': serializer.toJson<int>(durationMin),
      'distanceKm': serializer.toJson<double?>(distanceKm),
      'route': serializer.toJson<String?>(route),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WalkRecord copyWith(
          {int? id,
          int? petId,
          DateTime? walkedAt,
          int? durationMin,
          Value<double?> distanceKm = const Value.absent(),
          Value<String?> route = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      WalkRecord(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        walkedAt: walkedAt ?? this.walkedAt,
        durationMin: durationMin ?? this.durationMin,
        distanceKm: distanceKm.present ? distanceKm.value : this.distanceKm,
        route: route.present ? route.value : this.route,
        notes: notes.present ? notes.value : this.notes,
      );
  WalkRecord copyWithCompanion(WalkRecordsCompanion data) {
    return WalkRecord(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      walkedAt: data.walkedAt.present ? data.walkedAt.value : this.walkedAt,
      durationMin:
          data.durationMin.present ? data.durationMin.value : this.durationMin,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      route: data.route.present ? data.route.value : this.route,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalkRecord(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('walkedAt: $walkedAt, ')
          ..write('durationMin: $durationMin, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('route: $route, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, petId, walkedAt, durationMin, distanceKm, route, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalkRecord &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.walkedAt == this.walkedAt &&
          other.durationMin == this.durationMin &&
          other.distanceKm == this.distanceKm &&
          other.route == this.route &&
          other.notes == this.notes);
}

class WalkRecordsCompanion extends UpdateCompanion<WalkRecord> {
  final Value<int> id;
  final Value<int> petId;
  final Value<DateTime> walkedAt;
  final Value<int> durationMin;
  final Value<double?> distanceKm;
  final Value<String?> route;
  final Value<String?> notes;
  const WalkRecordsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.walkedAt = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.route = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WalkRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    required DateTime walkedAt,
    required int durationMin,
    this.distanceKm = const Value.absent(),
    this.route = const Value.absent(),
    this.notes = const Value.absent(),
  })  : petId = Value(petId),
        walkedAt = Value(walkedAt),
        durationMin = Value(durationMin);
  static Insertable<WalkRecord> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<DateTime>? walkedAt,
    Expression<int>? durationMin,
    Expression<double>? distanceKm,
    Expression<String>? route,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (walkedAt != null) 'walked_at': walkedAt,
      if (durationMin != null) 'duration_min': durationMin,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (route != null) 'route': route,
      if (notes != null) 'notes': notes,
    });
  }

  WalkRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<DateTime>? walkedAt,
      Value<int>? durationMin,
      Value<double?>? distanceKm,
      Value<String?>? route,
      Value<String?>? notes}) {
    return WalkRecordsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      walkedAt: walkedAt ?? this.walkedAt,
      durationMin: durationMin ?? this.durationMin,
      distanceKm: distanceKm ?? this.distanceKm,
      route: route ?? this.route,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (walkedAt.present) {
      map['walked_at'] = Variable<DateTime>(walkedAt.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalkRecordsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('walkedAt: $walkedAt, ')
          ..write('durationMin: $durationMin, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('route: $route, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $TrainingLogsTable extends TrainingLogs
    with TableInfo<$TrainingLogsTable, TrainingLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _commandMeta =
      const VerificationMeta('command');
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
      'command', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMinMeta =
      const VerificationMeta('durationMin');
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
      'duration_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _performanceMeta =
      const VerificationMeta('performance');
  @override
  late final GeneratedColumn<String> performance = GeneratedColumn<String>(
      'performance', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _trainedAtMeta =
      const VerificationMeta('trainedAt');
  @override
  late final GeneratedColumn<DateTime> trainedAt = GeneratedColumn<DateTime>(
      'trained_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, petId, command, durationMin, performance, trainedAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_logs';
  @override
  VerificationContext validateIntegrity(Insertable<TrainingLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('command')) {
      context.handle(_commandMeta,
          command.isAcceptableOrUnknown(data['command']!, _commandMeta));
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('duration_min')) {
      context.handle(
          _durationMinMeta,
          durationMin.isAcceptableOrUnknown(
              data['duration_min']!, _durationMinMeta));
    }
    if (data.containsKey('performance')) {
      context.handle(
          _performanceMeta,
          performance.isAcceptableOrUnknown(
              data['performance']!, _performanceMeta));
    }
    if (data.containsKey('trained_at')) {
      context.handle(_trainedAtMeta,
          trainedAt.isAcceptableOrUnknown(data['trained_at']!, _trainedAtMeta));
    } else if (isInserting) {
      context.missing(_trainedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      command: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command'])!,
      durationMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_min']),
      performance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}performance']),
      trainedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trained_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $TrainingLogsTable createAlias(String alias) {
    return $TrainingLogsTable(attachedDatabase, alias);
  }
}

class TrainingLog extends DataClass implements Insertable<TrainingLog> {
  final int id;
  final int petId;
  final String command;
  final int? durationMin;
  final String? performance;
  final DateTime trainedAt;
  final String? notes;
  const TrainingLog(
      {required this.id,
      required this.petId,
      required this.command,
      this.durationMin,
      this.performance,
      required this.trainedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    map['command'] = Variable<String>(command);
    if (!nullToAbsent || durationMin != null) {
      map['duration_min'] = Variable<int>(durationMin);
    }
    if (!nullToAbsent || performance != null) {
      map['performance'] = Variable<String>(performance);
    }
    map['trained_at'] = Variable<DateTime>(trainedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TrainingLogsCompanion toCompanion(bool nullToAbsent) {
    return TrainingLogsCompanion(
      id: Value(id),
      petId: Value(petId),
      command: Value(command),
      durationMin: durationMin == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMin),
      performance: performance == null && nullToAbsent
          ? const Value.absent()
          : Value(performance),
      trainedAt: Value(trainedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory TrainingLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingLog(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      command: serializer.fromJson<String>(json['command']),
      durationMin: serializer.fromJson<int?>(json['durationMin']),
      performance: serializer.fromJson<String?>(json['performance']),
      trainedAt: serializer.fromJson<DateTime>(json['trainedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'command': serializer.toJson<String>(command),
      'durationMin': serializer.toJson<int?>(durationMin),
      'performance': serializer.toJson<String?>(performance),
      'trainedAt': serializer.toJson<DateTime>(trainedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TrainingLog copyWith(
          {int? id,
          int? petId,
          String? command,
          Value<int?> durationMin = const Value.absent(),
          Value<String?> performance = const Value.absent(),
          DateTime? trainedAt,
          Value<String?> notes = const Value.absent()}) =>
      TrainingLog(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        command: command ?? this.command,
        durationMin: durationMin.present ? durationMin.value : this.durationMin,
        performance: performance.present ? performance.value : this.performance,
        trainedAt: trainedAt ?? this.trainedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  TrainingLog copyWithCompanion(TrainingLogsCompanion data) {
    return TrainingLog(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      command: data.command.present ? data.command.value : this.command,
      durationMin:
          data.durationMin.present ? data.durationMin.value : this.durationMin,
      performance:
          data.performance.present ? data.performance.value : this.performance,
      trainedAt: data.trainedAt.present ? data.trainedAt.value : this.trainedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingLog(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('command: $command, ')
          ..write('durationMin: $durationMin, ')
          ..write('performance: $performance, ')
          ..write('trainedAt: $trainedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, petId, command, durationMin, performance, trainedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingLog &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.command == this.command &&
          other.durationMin == this.durationMin &&
          other.performance == this.performance &&
          other.trainedAt == this.trainedAt &&
          other.notes == this.notes);
}

class TrainingLogsCompanion extends UpdateCompanion<TrainingLog> {
  final Value<int> id;
  final Value<int> petId;
  final Value<String> command;
  final Value<int?> durationMin;
  final Value<String?> performance;
  final Value<DateTime> trainedAt;
  final Value<String?> notes;
  const TrainingLogsCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.command = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.performance = const Value.absent(),
    this.trainedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  TrainingLogsCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    required String command,
    this.durationMin = const Value.absent(),
    this.performance = const Value.absent(),
    required DateTime trainedAt,
    this.notes = const Value.absent(),
  })  : petId = Value(petId),
        command = Value(command),
        trainedAt = Value(trainedAt);
  static Insertable<TrainingLog> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<String>? command,
    Expression<int>? durationMin,
    Expression<String>? performance,
    Expression<DateTime>? trainedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (command != null) 'command': command,
      if (durationMin != null) 'duration_min': durationMin,
      if (performance != null) 'performance': performance,
      if (trainedAt != null) 'trained_at': trainedAt,
      if (notes != null) 'notes': notes,
    });
  }

  TrainingLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<String>? command,
      Value<int?>? durationMin,
      Value<String?>? performance,
      Value<DateTime>? trainedAt,
      Value<String?>? notes}) {
    return TrainingLogsCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      command: command ?? this.command,
      durationMin: durationMin ?? this.durationMin,
      performance: performance ?? this.performance,
      trainedAt: trainedAt ?? this.trainedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (performance.present) {
      map['performance'] = Variable<String>(performance.value);
    }
    if (trainedAt.present) {
      map['trained_at'] = Variable<DateTime>(trainedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingLogsCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('command: $command, ')
          ..write('durationMin: $durationMin, ')
          ..write('performance: $performance, ')
          ..write('trainedAt: $trainedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $TrainingPlansTable extends TrainingPlans
    with TableInfo<$TrainingPlansTable, TrainingPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _petIdMeta = const VerificationMeta('petId');
  @override
  late final GeneratedColumn<int> petId = GeneratedColumn<int>(
      'pet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commandMeta =
      const VerificationMeta('command');
  @override
  late final GeneratedColumn<String> command = GeneratedColumn<String>(
      'command', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetDaysMeta =
      const VerificationMeta('targetDays');
  @override
  late final GeneratedColumn<int> targetDays = GeneratedColumn<int>(
      'target_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dailyMinutesMeta =
      const VerificationMeta('dailyMinutes');
  @override
  late final GeneratedColumn<int> dailyMinutes = GeneratedColumn<int>(
      'daily_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        petId,
        title,
        command,
        targetDays,
        dailyMinutes,
        progress,
        startDate,
        endDate,
        completed,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_plans';
  @override
  VerificationContext validateIntegrity(Insertable<TrainingPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet_id')) {
      context.handle(
          _petIdMeta, petId.isAcceptableOrUnknown(data['pet_id']!, _petIdMeta));
    } else if (isInserting) {
      context.missing(_petIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('command')) {
      context.handle(_commandMeta,
          command.isAcceptableOrUnknown(data['command']!, _commandMeta));
    } else if (isInserting) {
      context.missing(_commandMeta);
    }
    if (data.containsKey('target_days')) {
      context.handle(
          _targetDaysMeta,
          targetDays.isAcceptableOrUnknown(
              data['target_days']!, _targetDaysMeta));
    } else if (isInserting) {
      context.missing(_targetDaysMeta);
    }
    if (data.containsKey('daily_minutes')) {
      context.handle(
          _dailyMinutesMeta,
          dailyMinutes.isAcceptableOrUnknown(
              data['daily_minutes']!, _dailyMinutesMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      petId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pet_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      command: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}command'])!,
      targetDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_days'])!,
      dailyMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daily_minutes'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $TrainingPlansTable createAlias(String alias) {
    return $TrainingPlansTable(attachedDatabase, alias);
  }
}

class TrainingPlan extends DataClass implements Insertable<TrainingPlan> {
  final int id;
  final int petId;
  final String title;
  final String command;
  final int targetDays;
  final int dailyMinutes;
  final int progress;
  final DateTime startDate;
  final DateTime? endDate;
  final bool completed;
  final String? notes;
  const TrainingPlan(
      {required this.id,
      required this.petId,
      required this.title,
      required this.command,
      required this.targetDays,
      required this.dailyMinutes,
      required this.progress,
      required this.startDate,
      this.endDate,
      required this.completed,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet_id'] = Variable<int>(petId);
    map['title'] = Variable<String>(title);
    map['command'] = Variable<String>(command);
    map['target_days'] = Variable<int>(targetDays);
    map['daily_minutes'] = Variable<int>(dailyMinutes);
    map['progress'] = Variable<int>(progress);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TrainingPlansCompanion toCompanion(bool nullToAbsent) {
    return TrainingPlansCompanion(
      id: Value(id),
      petId: Value(petId),
      title: Value(title),
      command: Value(command),
      targetDays: Value(targetDays),
      dailyMinutes: Value(dailyMinutes),
      progress: Value(progress),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      completed: Value(completed),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory TrainingPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingPlan(
      id: serializer.fromJson<int>(json['id']),
      petId: serializer.fromJson<int>(json['petId']),
      title: serializer.fromJson<String>(json['title']),
      command: serializer.fromJson<String>(json['command']),
      targetDays: serializer.fromJson<int>(json['targetDays']),
      dailyMinutes: serializer.fromJson<int>(json['dailyMinutes']),
      progress: serializer.fromJson<int>(json['progress']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      completed: serializer.fromJson<bool>(json['completed']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'petId': serializer.toJson<int>(petId),
      'title': serializer.toJson<String>(title),
      'command': serializer.toJson<String>(command),
      'targetDays': serializer.toJson<int>(targetDays),
      'dailyMinutes': serializer.toJson<int>(dailyMinutes),
      'progress': serializer.toJson<int>(progress),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'completed': serializer.toJson<bool>(completed),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TrainingPlan copyWith(
          {int? id,
          int? petId,
          String? title,
          String? command,
          int? targetDays,
          int? dailyMinutes,
          int? progress,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          bool? completed,
          Value<String?> notes = const Value.absent()}) =>
      TrainingPlan(
        id: id ?? this.id,
        petId: petId ?? this.petId,
        title: title ?? this.title,
        command: command ?? this.command,
        targetDays: targetDays ?? this.targetDays,
        dailyMinutes: dailyMinutes ?? this.dailyMinutes,
        progress: progress ?? this.progress,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        completed: completed ?? this.completed,
        notes: notes.present ? notes.value : this.notes,
      );
  TrainingPlan copyWithCompanion(TrainingPlansCompanion data) {
    return TrainingPlan(
      id: data.id.present ? data.id.value : this.id,
      petId: data.petId.present ? data.petId.value : this.petId,
      title: data.title.present ? data.title.value : this.title,
      command: data.command.present ? data.command.value : this.command,
      targetDays:
          data.targetDays.present ? data.targetDays.value : this.targetDays,
      dailyMinutes: data.dailyMinutes.present
          ? data.dailyMinutes.value
          : this.dailyMinutes,
      progress: data.progress.present ? data.progress.value : this.progress,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      completed: data.completed.present ? data.completed.value : this.completed,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlan(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('title: $title, ')
          ..write('command: $command, ')
          ..write('targetDays: $targetDays, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('progress: $progress, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, petId, title, command, targetDays,
      dailyMinutes, progress, startDate, endDate, completed, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingPlan &&
          other.id == this.id &&
          other.petId == this.petId &&
          other.title == this.title &&
          other.command == this.command &&
          other.targetDays == this.targetDays &&
          other.dailyMinutes == this.dailyMinutes &&
          other.progress == this.progress &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.completed == this.completed &&
          other.notes == this.notes);
}

class TrainingPlansCompanion extends UpdateCompanion<TrainingPlan> {
  final Value<int> id;
  final Value<int> petId;
  final Value<String> title;
  final Value<String> command;
  final Value<int> targetDays;
  final Value<int> dailyMinutes;
  final Value<int> progress;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> completed;
  final Value<String?> notes;
  const TrainingPlansCompanion({
    this.id = const Value.absent(),
    this.petId = const Value.absent(),
    this.title = const Value.absent(),
    this.command = const Value.absent(),
    this.targetDays = const Value.absent(),
    this.dailyMinutes = const Value.absent(),
    this.progress = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
  });
  TrainingPlansCompanion.insert({
    this.id = const Value.absent(),
    required int petId,
    required String title,
    required String command,
    required int targetDays,
    this.dailyMinutes = const Value.absent(),
    this.progress = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
  })  : petId = Value(petId),
        title = Value(title),
        command = Value(command),
        targetDays = Value(targetDays),
        startDate = Value(startDate);
  static Insertable<TrainingPlan> custom({
    Expression<int>? id,
    Expression<int>? petId,
    Expression<String>? title,
    Expression<String>? command,
    Expression<int>? targetDays,
    Expression<int>? dailyMinutes,
    Expression<int>? progress,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? completed,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (petId != null) 'pet_id': petId,
      if (title != null) 'title': title,
      if (command != null) 'command': command,
      if (targetDays != null) 'target_days': targetDays,
      if (dailyMinutes != null) 'daily_minutes': dailyMinutes,
      if (progress != null) 'progress': progress,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (completed != null) 'completed': completed,
      if (notes != null) 'notes': notes,
    });
  }

  TrainingPlansCompanion copyWith(
      {Value<int>? id,
      Value<int>? petId,
      Value<String>? title,
      Value<String>? command,
      Value<int>? targetDays,
      Value<int>? dailyMinutes,
      Value<int>? progress,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<bool>? completed,
      Value<String?>? notes}) {
    return TrainingPlansCompanion(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      command: command ?? this.command,
      targetDays: targetDays ?? this.targetDays,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (petId.present) {
      map['pet_id'] = Variable<int>(petId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (command.present) {
      map['command'] = Variable<String>(command.value);
    }
    if (targetDays.present) {
      map['target_days'] = Variable<int>(targetDays.value);
    }
    if (dailyMinutes.present) {
      map['daily_minutes'] = Variable<int>(dailyMinutes.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlansCompanion(')
          ..write('id: $id, ')
          ..write('petId: $petId, ')
          ..write('title: $title, ')
          ..write('command: $command, ')
          ..write('targetDays: $targetDays, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('progress: $progress, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ForbiddenFoodsTable extends ForbiddenFoods
    with TableInfo<$ForbiddenFoodsTable, ForbiddenFood> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ForbiddenFoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, nameEn, reason, severity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forbidden_foods';
  @override
  VerificationContext validateIntegrity(Insertable<ForbiddenFood> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ForbiddenFood map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ForbiddenFood(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
    );
  }

  @override
  $ForbiddenFoodsTable createAlias(String alias) {
    return $ForbiddenFoodsTable(attachedDatabase, alias);
  }
}

class ForbiddenFood extends DataClass implements Insertable<ForbiddenFood> {
  final int id;
  final String name;
  final String? nameEn;
  final String reason;
  final String severity;
  const ForbiddenFood(
      {required this.id,
      required this.name,
      this.nameEn,
      required this.reason,
      required this.severity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    map['reason'] = Variable<String>(reason);
    map['severity'] = Variable<String>(severity);
    return map;
  }

  ForbiddenFoodsCompanion toCompanion(bool nullToAbsent) {
    return ForbiddenFoodsCompanion(
      id: Value(id),
      name: Value(name),
      nameEn:
          nameEn == null && nullToAbsent ? const Value.absent() : Value(nameEn),
      reason: Value(reason),
      severity: Value(severity),
    );
  }

  factory ForbiddenFood.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForbiddenFood(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      reason: serializer.fromJson<String>(json['reason']),
      severity: serializer.fromJson<String>(json['severity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'reason': serializer.toJson<String>(reason),
      'severity': serializer.toJson<String>(severity),
    };
  }

  ForbiddenFood copyWith(
          {int? id,
          String? name,
          Value<String?> nameEn = const Value.absent(),
          String? reason,
          String? severity}) =>
      ForbiddenFood(
        id: id ?? this.id,
        name: name ?? this.name,
        nameEn: nameEn.present ? nameEn.value : this.nameEn,
        reason: reason ?? this.reason,
        severity: severity ?? this.severity,
      );
  ForbiddenFood copyWithCompanion(ForbiddenFoodsCompanion data) {
    return ForbiddenFood(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      reason: data.reason.present ? data.reason.value : this.reason,
      severity: data.severity.present ? data.severity.value : this.severity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ForbiddenFood(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('reason: $reason, ')
          ..write('severity: $severity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nameEn, reason, severity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForbiddenFood &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.reason == this.reason &&
          other.severity == this.severity);
}

class ForbiddenFoodsCompanion extends UpdateCompanion<ForbiddenFood> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String> reason;
  final Value<String> severity;
  const ForbiddenFoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.reason = const Value.absent(),
    this.severity = const Value.absent(),
  });
  ForbiddenFoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameEn = const Value.absent(),
    required String reason,
    required String severity,
  })  : name = Value(name),
        reason = Value(reason),
        severity = Value(severity);
  static Insertable<ForbiddenFood> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? reason,
    Expression<String>? severity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (reason != null) 'reason': reason,
      if (severity != null) 'severity': severity,
    });
  }

  ForbiddenFoodsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? nameEn,
      Value<String>? reason,
      Value<String>? severity}) {
    return ForbiddenFoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      reason: reason ?? this.reason,
      severity: severity ?? this.severity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ForbiddenFoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('reason: $reason, ')
          ..write('severity: $severity')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('hospital'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, address, type, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(Insertable<Contact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final int id;
  final String name;
  final String phone;
  final String? address;
  final String type;
  final String? notes;
  const Contact(
      {required this.id,
      required this.name,
      required this.phone,
      this.address,
      required this.type,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      type: Value(type),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      type: serializer.fromJson<String>(json['type']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String?>(address),
      'type': serializer.toJson<String>(type),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Contact copyWith(
          {int? id,
          String? name,
          String? phone,
          Value<String?> address = const Value.absent(),
          String? type,
          Value<String?> notes = const Value.absent()}) =>
      Contact(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address.present ? address.value : this.address,
        type: type ?? this.type,
        notes: notes.present ? notes.value : this.notes,
      );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      type: data.type.present ? data.type.value : this.type,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, address, type, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.type == this.type &&
          other.notes == this.notes);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> address;
  final Value<String> type;
  final Value<String?> notes;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    this.address = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
  })  : name = Value(name),
        phone = Value(phone);
  static Insertable<Contact> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? type,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (type != null) 'type': type,
      if (notes != null) 'notes': notes,
    });
  }

  ContactsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? phone,
      Value<String?>? address,
      Value<String>? type,
      Value<String?>? notes}) {
    return ContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      type: type ?? this.type,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $FavoritePlacesTable extends FavoritePlaces
    with TableInfo<$FavoritePlacesTable, FavoritePlace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritePlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _amapIdMeta = const VerificationMeta('amapId');
  @override
  late final GeneratedColumn<String> amapId = GeneratedColumn<String>(
      'amap_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _visitCountMeta =
      const VerificationMeta('visitCount');
  @override
  late final GeneratedColumn<int> visitCount = GeneratedColumn<int>(
      'visit_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastVisitedAtMeta =
      const VerificationMeta('lastVisitedAt');
  @override
  late final GeneratedColumn<DateTime> lastVisitedAt =
      GeneratedColumn<DateTime>('last_visited_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        address,
        phone,
        latitude,
        longitude,
        amapId,
        visitCount,
        lastVisitedAt,
        createdAt,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_places';
  @override
  VerificationContext validateIntegrity(Insertable<FavoritePlace> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('amap_id')) {
      context.handle(_amapIdMeta,
          amapId.isAcceptableOrUnknown(data['amap_id']!, _amapIdMeta));
    }
    if (data.containsKey('visit_count')) {
      context.handle(
          _visitCountMeta,
          visitCount.isAcceptableOrUnknown(
              data['visit_count']!, _visitCountMeta));
    }
    if (data.containsKey('last_visited_at')) {
      context.handle(
          _lastVisitedAtMeta,
          lastVisitedAt.isAcceptableOrUnknown(
              data['last_visited_at']!, _lastVisitedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoritePlace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritePlace(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      amapId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amap_id']),
      visitCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visit_count'])!,
      lastVisitedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_visited_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $FavoritePlacesTable createAlias(String alias) {
    return $FavoritePlacesTable(attachedDatabase, alias);
  }
}

class FavoritePlace extends DataClass implements Insertable<FavoritePlace> {
  final int id;
  final String name;
  final String category;
  final String? address;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final String? amapId;
  final int visitCount;
  final DateTime? lastVisitedAt;
  final DateTime createdAt;
  final String? notes;
  const FavoritePlace(
      {required this.id,
      required this.name,
      required this.category,
      this.address,
      this.phone,
      this.latitude,
      this.longitude,
      this.amapId,
      required this.visitCount,
      this.lastVisitedAt,
      required this.createdAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || amapId != null) {
      map['amap_id'] = Variable<String>(amapId);
    }
    map['visit_count'] = Variable<int>(visitCount);
    if (!nullToAbsent || lastVisitedAt != null) {
      map['last_visited_at'] = Variable<DateTime>(lastVisitedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FavoritePlacesCompanion toCompanion(bool nullToAbsent) {
    return FavoritePlacesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      amapId:
          amapId == null && nullToAbsent ? const Value.absent() : Value(amapId),
      visitCount: Value(visitCount),
      lastVisitedAt: lastVisitedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisitedAt),
      createdAt: Value(createdAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory FavoritePlace.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritePlace(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      amapId: serializer.fromJson<String?>(json['amapId']),
      visitCount: serializer.fromJson<int>(json['visitCount']),
      lastVisitedAt: serializer.fromJson<DateTime?>(json['lastVisitedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'amapId': serializer.toJson<String?>(amapId),
      'visitCount': serializer.toJson<int>(visitCount),
      'lastVisitedAt': serializer.toJson<DateTime?>(lastVisitedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FavoritePlace copyWith(
          {int? id,
          String? name,
          String? category,
          Value<String?> address = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<String?> amapId = const Value.absent(),
          int? visitCount,
          Value<DateTime?> lastVisitedAt = const Value.absent(),
          DateTime? createdAt,
          Value<String?> notes = const Value.absent()}) =>
      FavoritePlace(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        address: address.present ? address.value : this.address,
        phone: phone.present ? phone.value : this.phone,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        amapId: amapId.present ? amapId.value : this.amapId,
        visitCount: visitCount ?? this.visitCount,
        lastVisitedAt:
            lastVisitedAt.present ? lastVisitedAt.value : this.lastVisitedAt,
        createdAt: createdAt ?? this.createdAt,
        notes: notes.present ? notes.value : this.notes,
      );
  FavoritePlace copyWithCompanion(FavoritePlacesCompanion data) {
    return FavoritePlace(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      amapId: data.amapId.present ? data.amapId.value : this.amapId,
      visitCount:
          data.visitCount.present ? data.visitCount.value : this.visitCount,
      lastVisitedAt: data.lastVisitedAt.present
          ? data.lastVisitedAt.value
          : this.lastVisitedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritePlace(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('amapId: $amapId, ')
          ..write('visitCount: $visitCount, ')
          ..write('lastVisitedAt: $lastVisitedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, address, phone, latitude,
      longitude, amapId, visitCount, lastVisitedAt, createdAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritePlace &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.amapId == this.amapId &&
          other.visitCount == this.visitCount &&
          other.lastVisitedAt == this.lastVisitedAt &&
          other.createdAt == this.createdAt &&
          other.notes == this.notes);
}

class FavoritePlacesCompanion extends UpdateCompanion<FavoritePlace> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> amapId;
  final Value<int> visitCount;
  final Value<DateTime?> lastVisitedAt;
  final Value<DateTime> createdAt;
  final Value<String?> notes;
  const FavoritePlacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.amapId = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.lastVisitedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FavoritePlacesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.amapId = const Value.absent(),
    this.visitCount = const Value.absent(),
    this.lastVisitedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notes = const Value.absent(),
  })  : name = Value(name),
        category = Value(category);
  static Insertable<FavoritePlace> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? amapId,
    Expression<int>? visitCount,
    Expression<DateTime>? lastVisitedAt,
    Expression<DateTime>? createdAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (amapId != null) 'amap_id': amapId,
      if (visitCount != null) 'visit_count': visitCount,
      if (lastVisitedAt != null) 'last_visited_at': lastVisitedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (notes != null) 'notes': notes,
    });
  }

  FavoritePlacesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? category,
      Value<String?>? address,
      Value<String?>? phone,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String?>? amapId,
      Value<int>? visitCount,
      Value<DateTime?>? lastVisitedAt,
      Value<DateTime>? createdAt,
      Value<String?>? notes}) {
    return FavoritePlacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      amapId: amapId ?? this.amapId,
      visitCount: visitCount ?? this.visitCount,
      lastVisitedAt: lastVisitedAt ?? this.lastVisitedAt,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (amapId.present) {
      map['amap_id'] = Variable<String>(amapId.value);
    }
    if (visitCount.present) {
      map['visit_count'] = Variable<int>(visitCount.value);
    }
    if (lastVisitedAt.present) {
      map['last_visited_at'] = Variable<DateTime>(lastVisitedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritePlacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('amapId: $amapId, ')
          ..write('visitCount: $visitCount, ')
          ..write('lastVisitedAt: $lastVisitedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(Insertable<UserPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final String key;
  final String value;
  const UserPreference({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory UserPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserPreference copyWith({String? key, String? value}) => UserPreference(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.key == this.key &&
          other.value == this.value);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const UserPreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<UserPreference> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return UserPreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExportSettingsTable extends ExportSettings
    with TableInfo<$ExportSettingsTable, ExportSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExportSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
      'salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, pinHash, salt, enabled, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'export_settings';
  @override
  VerificationContext validateIntegrity(Insertable<ExportSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('salt')) {
      context.handle(
          _saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExportSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExportSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      salt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salt'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExportSettingsTable createAlias(String alias) {
    return $ExportSettingsTable(attachedDatabase, alias);
  }
}

class ExportSetting extends DataClass implements Insertable<ExportSetting> {
  final int id;
  final String pinHash;
  final String salt;
  final bool enabled;
  final DateTime createdAt;
  const ExportSetting(
      {required this.id,
      required this.pinHash,
      required this.salt,
      required this.enabled,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pin_hash'] = Variable<String>(pinHash);
    map['salt'] = Variable<String>(salt);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExportSettingsCompanion toCompanion(bool nullToAbsent) {
    return ExportSettingsCompanion(
      id: Value(id),
      pinHash: Value(pinHash),
      salt: Value(salt),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
    );
  }

  factory ExportSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExportSetting(
      id: serializer.fromJson<int>(json['id']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      salt: serializer.fromJson<String>(json['salt']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pinHash': serializer.toJson<String>(pinHash),
      'salt': serializer.toJson<String>(salt),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExportSetting copyWith(
          {int? id,
          String? pinHash,
          String? salt,
          bool? enabled,
          DateTime? createdAt}) =>
      ExportSetting(
        id: id ?? this.id,
        pinHash: pinHash ?? this.pinHash,
        salt: salt ?? this.salt,
        enabled: enabled ?? this.enabled,
        createdAt: createdAt ?? this.createdAt,
      );
  ExportSetting copyWithCompanion(ExportSettingsCompanion data) {
    return ExportSetting(
      id: data.id.present ? data.id.value : this.id,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      salt: data.salt.present ? data.salt.value : this.salt,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExportSetting(')
          ..write('id: $id, ')
          ..write('pinHash: $pinHash, ')
          ..write('salt: $salt, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pinHash, salt, enabled, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExportSetting &&
          other.id == this.id &&
          other.pinHash == this.pinHash &&
          other.salt == this.salt &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt);
}

class ExportSettingsCompanion extends UpdateCompanion<ExportSetting> {
  final Value<int> id;
  final Value<String> pinHash;
  final Value<String> salt;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  const ExportSettingsCompanion({
    this.id = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.salt = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExportSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String pinHash,
    required String salt,
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : pinHash = Value(pinHash),
        salt = Value(salt);
  static Insertable<ExportSetting> custom({
    Expression<int>? id,
    Expression<String>? pinHash,
    Expression<String>? salt,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pinHash != null) 'pin_hash': pinHash,
      if (salt != null) 'salt': salt,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExportSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? pinHash,
      Value<String>? salt,
      Value<bool>? enabled,
      Value<DateTime>? createdAt}) {
    return ExportSettingsCompanion(
      id: id ?? this.id,
      pinHash: pinHash ?? this.pinHash,
      salt: salt ?? this.salt,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExportSettingsCompanion(')
          ..write('id: $id, ')
          ..write('pinHash: $pinHash, ')
          ..write('salt: $salt, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PoiCacheTable extends PoiCache
    with TableInfo<$PoiCacheTable, PoiCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoiCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amapIdMeta = const VerificationMeta('amapId');
  @override
  late final GeneratedColumn<String> amapId = GeneratedColumn<String>(
      'amap_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cloud'));
  static const VerificationMeta _cloudVersionMeta =
      const VerificationMeta('cloudVersion');
  @override
  late final GeneratedColumn<int> cloudVersion = GeneratedColumn<int>(
      'cloud_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cloudSyncedAtMeta =
      const VerificationMeta('cloudSyncedAt');
  @override
  late final GeneratedColumn<DateTime> cloudSyncedAt =
      GeneratedColumn<DateTime>('cloud_synced_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _submittedByMeta =
      const VerificationMeta('submittedBy');
  @override
  late final GeneratedColumn<String> submittedBy = GeneratedColumn<String>(
      'submitted_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amapId,
        name,
        category,
        address,
        phone,
        description,
        latitude,
        longitude,
        city,
        source,
        cloudVersion,
        cloudSyncedAt,
        localUpdatedAt,
        submittedBy,
        active
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'poi_cache';
  @override
  VerificationContext validateIntegrity(Insertable<PoiCacheEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amap_id')) {
      context.handle(_amapIdMeta,
          amapId.isAcceptableOrUnknown(data['amap_id']!, _amapIdMeta));
    } else if (isInserting) {
      context.missing(_amapIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('cloud_version')) {
      context.handle(
          _cloudVersionMeta,
          cloudVersion.isAcceptableOrUnknown(
              data['cloud_version']!, _cloudVersionMeta));
    }
    if (data.containsKey('cloud_synced_at')) {
      context.handle(
          _cloudSyncedAtMeta,
          cloudSyncedAt.isAcceptableOrUnknown(
              data['cloud_synced_at']!, _cloudSyncedAtMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    }
    if (data.containsKey('submitted_by')) {
      context.handle(
          _submittedByMeta,
          submittedBy.isAcceptableOrUnknown(
              data['submitted_by']!, _submittedByMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PoiCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PoiCacheEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amapId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amap_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      cloudVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cloud_version'])!,
      cloudSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}cloud_synced_at']),
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at'])!,
      submittedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}submitted_by']),
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $PoiCacheTable createAlias(String alias) {
    return $PoiCacheTable(attachedDatabase, alias);
  }
}

class PoiCacheEntry extends DataClass implements Insertable<PoiCacheEntry> {
  final int id;
  final String amapId;
  final String name;
  final String category;
  final String? address;
  final String? phone;
  final String? description;
  final double latitude;
  final double longitude;
  final String? city;
  final String source;
  final int cloudVersion;
  final DateTime? cloudSyncedAt;
  final DateTime localUpdatedAt;
  final String? submittedBy;
  final bool active;
  const PoiCacheEntry(
      {required this.id,
      required this.amapId,
      required this.name,
      required this.category,
      this.address,
      this.phone,
      this.description,
      required this.latitude,
      required this.longitude,
      this.city,
      required this.source,
      required this.cloudVersion,
      this.cloudSyncedAt,
      required this.localUpdatedAt,
      this.submittedBy,
      required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amap_id'] = Variable<String>(amapId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    map['source'] = Variable<String>(source);
    map['cloud_version'] = Variable<int>(cloudVersion);
    if (!nullToAbsent || cloudSyncedAt != null) {
      map['cloud_synced_at'] = Variable<DateTime>(cloudSyncedAt);
    }
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || submittedBy != null) {
      map['submitted_by'] = Variable<String>(submittedBy);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  PoiCacheCompanion toCompanion(bool nullToAbsent) {
    return PoiCacheCompanion(
      id: Value(id),
      amapId: Value(amapId),
      name: Value(name),
      category: Value(category),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      latitude: Value(latitude),
      longitude: Value(longitude),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      source: Value(source),
      cloudVersion: Value(cloudVersion),
      cloudSyncedAt: cloudSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudSyncedAt),
      localUpdatedAt: Value(localUpdatedAt),
      submittedBy: submittedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedBy),
      active: Value(active),
    );
  }

  factory PoiCacheEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PoiCacheEntry(
      id: serializer.fromJson<int>(json['id']),
      amapId: serializer.fromJson<String>(json['amapId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      description: serializer.fromJson<String?>(json['description']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      city: serializer.fromJson<String?>(json['city']),
      source: serializer.fromJson<String>(json['source']),
      cloudVersion: serializer.fromJson<int>(json['cloudVersion']),
      cloudSyncedAt: serializer.fromJson<DateTime?>(json['cloudSyncedAt']),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      submittedBy: serializer.fromJson<String?>(json['submittedBy']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amapId': serializer.toJson<String>(amapId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'description': serializer.toJson<String?>(description),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'city': serializer.toJson<String?>(city),
      'source': serializer.toJson<String>(source),
      'cloudVersion': serializer.toJson<int>(cloudVersion),
      'cloudSyncedAt': serializer.toJson<DateTime?>(cloudSyncedAt),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'submittedBy': serializer.toJson<String?>(submittedBy),
      'active': serializer.toJson<bool>(active),
    };
  }

  PoiCacheEntry copyWith(
          {int? id,
          String? amapId,
          String? name,
          String? category,
          Value<String?> address = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> description = const Value.absent(),
          double? latitude,
          double? longitude,
          Value<String?> city = const Value.absent(),
          String? source,
          int? cloudVersion,
          Value<DateTime?> cloudSyncedAt = const Value.absent(),
          DateTime? localUpdatedAt,
          Value<String?> submittedBy = const Value.absent(),
          bool? active}) =>
      PoiCacheEntry(
        id: id ?? this.id,
        amapId: amapId ?? this.amapId,
        name: name ?? this.name,
        category: category ?? this.category,
        address: address.present ? address.value : this.address,
        phone: phone.present ? phone.value : this.phone,
        description: description.present ? description.value : this.description,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        city: city.present ? city.value : this.city,
        source: source ?? this.source,
        cloudVersion: cloudVersion ?? this.cloudVersion,
        cloudSyncedAt:
            cloudSyncedAt.present ? cloudSyncedAt.value : this.cloudSyncedAt,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        submittedBy: submittedBy.present ? submittedBy.value : this.submittedBy,
        active: active ?? this.active,
      );
  PoiCacheEntry copyWithCompanion(PoiCacheCompanion data) {
    return PoiCacheEntry(
      id: data.id.present ? data.id.value : this.id,
      amapId: data.amapId.present ? data.amapId.value : this.amapId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      description:
          data.description.present ? data.description.value : this.description,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      city: data.city.present ? data.city.value : this.city,
      source: data.source.present ? data.source.value : this.source,
      cloudVersion: data.cloudVersion.present
          ? data.cloudVersion.value
          : this.cloudVersion,
      cloudSyncedAt: data.cloudSyncedAt.present
          ? data.cloudSyncedAt.value
          : this.cloudSyncedAt,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      submittedBy:
          data.submittedBy.present ? data.submittedBy.value : this.submittedBy,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PoiCacheEntry(')
          ..write('id: $id, ')
          ..write('amapId: $amapId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('city: $city, ')
          ..write('source: $source, ')
          ..write('cloudVersion: $cloudVersion, ')
          ..write('cloudSyncedAt: $cloudSyncedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('submittedBy: $submittedBy, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      amapId,
      name,
      category,
      address,
      phone,
      description,
      latitude,
      longitude,
      city,
      source,
      cloudVersion,
      cloudSyncedAt,
      localUpdatedAt,
      submittedBy,
      active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoiCacheEntry &&
          other.id == this.id &&
          other.amapId == this.amapId &&
          other.name == this.name &&
          other.category == this.category &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.description == this.description &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.city == this.city &&
          other.source == this.source &&
          other.cloudVersion == this.cloudVersion &&
          other.cloudSyncedAt == this.cloudSyncedAt &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.submittedBy == this.submittedBy &&
          other.active == this.active);
}

class PoiCacheCompanion extends UpdateCompanion<PoiCacheEntry> {
  final Value<int> id;
  final Value<String> amapId;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> description;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> city;
  final Value<String> source;
  final Value<int> cloudVersion;
  final Value<DateTime?> cloudSyncedAt;
  final Value<DateTime> localUpdatedAt;
  final Value<String?> submittedBy;
  final Value<bool> active;
  const PoiCacheCompanion({
    this.id = const Value.absent(),
    this.amapId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.description = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.city = const Value.absent(),
    this.source = const Value.absent(),
    this.cloudVersion = const Value.absent(),
    this.cloudSyncedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.submittedBy = const Value.absent(),
    this.active = const Value.absent(),
  });
  PoiCacheCompanion.insert({
    this.id = const Value.absent(),
    required String amapId,
    required String name,
    required String category,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.description = const Value.absent(),
    required double latitude,
    required double longitude,
    this.city = const Value.absent(),
    this.source = const Value.absent(),
    this.cloudVersion = const Value.absent(),
    this.cloudSyncedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.submittedBy = const Value.absent(),
    this.active = const Value.absent(),
  })  : amapId = Value(amapId),
        name = Value(name),
        category = Value(category),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<PoiCacheEntry> custom({
    Expression<int>? id,
    Expression<String>? amapId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? description,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? city,
    Expression<String>? source,
    Expression<int>? cloudVersion,
    Expression<DateTime>? cloudSyncedAt,
    Expression<DateTime>? localUpdatedAt,
    Expression<String>? submittedBy,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amapId != null) 'amap_id': amapId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (description != null) 'description': description,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (city != null) 'city': city,
      if (source != null) 'source': source,
      if (cloudVersion != null) 'cloud_version': cloudVersion,
      if (cloudSyncedAt != null) 'cloud_synced_at': cloudSyncedAt,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (submittedBy != null) 'submitted_by': submittedBy,
      if (active != null) 'active': active,
    });
  }

  PoiCacheCompanion copyWith(
      {Value<int>? id,
      Value<String>? amapId,
      Value<String>? name,
      Value<String>? category,
      Value<String?>? address,
      Value<String?>? phone,
      Value<String?>? description,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String?>? city,
      Value<String>? source,
      Value<int>? cloudVersion,
      Value<DateTime?>? cloudSyncedAt,
      Value<DateTime>? localUpdatedAt,
      Value<String?>? submittedBy,
      Value<bool>? active}) {
    return PoiCacheCompanion(
      id: id ?? this.id,
      amapId: amapId ?? this.amapId,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      source: source ?? this.source,
      cloudVersion: cloudVersion ?? this.cloudVersion,
      cloudSyncedAt: cloudSyncedAt ?? this.cloudSyncedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      submittedBy: submittedBy ?? this.submittedBy,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amapId.present) {
      map['amap_id'] = Variable<String>(amapId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (cloudVersion.present) {
      map['cloud_version'] = Variable<int>(cloudVersion.value);
    }
    if (cloudSyncedAt.present) {
      map['cloud_synced_at'] = Variable<DateTime>(cloudSyncedAt.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (submittedBy.present) {
      map['submitted_by'] = Variable<String>(submittedBy.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoiCacheCompanion(')
          ..write('id: $id, ')
          ..write('amapId: $amapId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('city: $city, ')
          ..write('source: $source, ')
          ..write('cloudVersion: $cloudVersion, ')
          ..write('cloudSyncedAt: $cloudSyncedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('submittedBy: $submittedBy, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PetsTable pets = $PetsTable(this);
  late final $WeightRecordsTable weightRecords = $WeightRecordsTable(this);
  late final $PetImagesTable petImages = $PetImagesTable(this);
  late final $HealthEventsTable healthEvents = $HealthEventsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $FeedingRecordsTable feedingRecords = $FeedingRecordsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $WalkRecordsTable walkRecords = $WalkRecordsTable(this);
  late final $TrainingLogsTable trainingLogs = $TrainingLogsTable(this);
  late final $TrainingPlansTable trainingPlans = $TrainingPlansTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $ForbiddenFoodsTable forbiddenFoods = $ForbiddenFoodsTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $FavoritePlacesTable favoritePlaces = $FavoritePlacesTable(this);
  late final $UserPreferencesTable userPreferences =
      $UserPreferencesTable(this);
  late final $ExportSettingsTable exportSettings = $ExportSettingsTable(this);
  late final $PoiCacheTable poiCache = $PoiCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        pets,
        weightRecords,
        petImages,
        healthEvents,
        medications,
        foodItems,
        feedingRecords,
        expenses,
        walkRecords,
        trainingLogs,
        trainingPlans,
        settings,
        forbiddenFoods,
        contacts,
        favoritePlaces,
        userPreferences,
        exportSettings,
        poiCache
      ];
}

typedef $$PetsTableCreateCompanionBuilder = PetsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> breed,
  Value<DateTime?> birthday,
  required String gender,
  Value<bool> neutered,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$PetsTableUpdateCompanionBuilder = PetsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> breed,
  Value<DateTime?> birthday,
  Value<String> gender,
  Value<bool> neutered,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

class $$PetsTableFilterComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthday => $composableBuilder(
      column: $table.birthday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get neutered => $composableBuilder(
      column: $table.neutered, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PetsTableOrderingComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breed => $composableBuilder(
      column: $table.breed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthday => $composableBuilder(
      column: $table.birthday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get neutered => $composableBuilder(
      column: $table.neutered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<DateTime> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<bool> get neutered =>
      $composableBuilder(column: $table.neutered, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PetsTable,
    Pet,
    $$PetsTableFilterComposer,
    $$PetsTableOrderingComposer,
    $$PetsTableAnnotationComposer,
    $$PetsTableCreateCompanionBuilder,
    $$PetsTableUpdateCompanionBuilder,
    (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
    Pet,
    PrefetchHooks Function()> {
  $$PetsTableTableManager(_$AppDatabase db, $PetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> breed = const Value.absent(),
            Value<DateTime?> birthday = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<bool> neutered = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PetsCompanion(
            id: id,
            name: name,
            breed: breed,
            birthday: birthday,
            gender: gender,
            neutered: neutered,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> breed = const Value.absent(),
            Value<DateTime?> birthday = const Value.absent(),
            required String gender,
            Value<bool> neutered = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PetsCompanion.insert(
            id: id,
            name: name,
            breed: breed,
            birthday: birthday,
            gender: gender,
            neutered: neutered,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PetsTable,
    Pet,
    $$PetsTableFilterComposer,
    $$PetsTableOrderingComposer,
    $$PetsTableAnnotationComposer,
    $$PetsTableCreateCompanionBuilder,
    $$PetsTableUpdateCompanionBuilder,
    (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
    Pet,
    PrefetchHooks Function()>;
typedef $$WeightRecordsTableCreateCompanionBuilder = WeightRecordsCompanion
    Function({
  Value<int> id,
  required int petId,
  required DateTime measuredAt,
  required double weightKg,
  Value<String?> notes,
});
typedef $$WeightRecordsTableUpdateCompanionBuilder = WeightRecordsCompanion
    Function({
  Value<int> id,
  Value<int> petId,
  Value<DateTime> measuredAt,
  Value<double> weightKg,
  Value<String?> notes,
});

class $$WeightRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
      column: $table.measuredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$WeightRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
      column: $table.measuredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$WeightRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
      column: $table.measuredAt, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WeightRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeightRecordsTable,
    WeightRecord,
    $$WeightRecordsTableFilterComposer,
    $$WeightRecordsTableOrderingComposer,
    $$WeightRecordsTableAnnotationComposer,
    $$WeightRecordsTableCreateCompanionBuilder,
    $$WeightRecordsTableUpdateCompanionBuilder,
    (
      WeightRecord,
      BaseReferences<_$AppDatabase, $WeightRecordsTable, WeightRecord>
    ),
    WeightRecord,
    PrefetchHooks Function()> {
  $$WeightRecordsTableTableManager(_$AppDatabase db, $WeightRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<DateTime> measuredAt = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              WeightRecordsCompanion(
            id: id,
            petId: petId,
            measuredAt: measuredAt,
            weightKg: weightKg,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            required DateTime measuredAt,
            required double weightKg,
            Value<String?> notes = const Value.absent(),
          }) =>
              WeightRecordsCompanion.insert(
            id: id,
            petId: petId,
            measuredAt: measuredAt,
            weightKg: weightKg,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeightRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeightRecordsTable,
    WeightRecord,
    $$WeightRecordsTableFilterComposer,
    $$WeightRecordsTableOrderingComposer,
    $$WeightRecordsTableAnnotationComposer,
    $$WeightRecordsTableCreateCompanionBuilder,
    $$WeightRecordsTableUpdateCompanionBuilder,
    (
      WeightRecord,
      BaseReferences<_$AppDatabase, $WeightRecordsTable, WeightRecord>
    ),
    WeightRecord,
    PrefetchHooks Function()>;
typedef $$PetImagesTableCreateCompanionBuilder = PetImagesCompanion Function({
  Value<int> id,
  required int petId,
  required String path,
  Value<DateTime?> takenAt,
  Value<String?> caption,
});
typedef $$PetImagesTableUpdateCompanionBuilder = PetImagesCompanion Function({
  Value<int> id,
  Value<int> petId,
  Value<String> path,
  Value<DateTime?> takenAt,
  Value<String?> caption,
});

class $$PetImagesTableFilterComposer
    extends Composer<_$AppDatabase, $PetImagesTable> {
  $$PetImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnFilters(column));
}

class $$PetImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PetImagesTable> {
  $$PetImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get caption => $composableBuilder(
      column: $table.caption, builder: (column) => ColumnOrderings(column));
}

class $$PetImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetImagesTable> {
  $$PetImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);
}

class $$PetImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PetImagesTable,
    PetImage,
    $$PetImagesTableFilterComposer,
    $$PetImagesTableOrderingComposer,
    $$PetImagesTableAnnotationComposer,
    $$PetImagesTableCreateCompanionBuilder,
    $$PetImagesTableUpdateCompanionBuilder,
    (PetImage, BaseReferences<_$AppDatabase, $PetImagesTable, PetImage>),
    PetImage,
    PrefetchHooks Function()> {
  $$PetImagesTableTableManager(_$AppDatabase db, $PetImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<DateTime?> takenAt = const Value.absent(),
            Value<String?> caption = const Value.absent(),
          }) =>
              PetImagesCompanion(
            id: id,
            petId: petId,
            path: path,
            takenAt: takenAt,
            caption: caption,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            required String path,
            Value<DateTime?> takenAt = const Value.absent(),
            Value<String?> caption = const Value.absent(),
          }) =>
              PetImagesCompanion.insert(
            id: id,
            petId: petId,
            path: path,
            takenAt: takenAt,
            caption: caption,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PetImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PetImagesTable,
    PetImage,
    $$PetImagesTableFilterComposer,
    $$PetImagesTableOrderingComposer,
    $$PetImagesTableAnnotationComposer,
    $$PetImagesTableCreateCompanionBuilder,
    $$PetImagesTableUpdateCompanionBuilder,
    (PetImage, BaseReferences<_$AppDatabase, $PetImagesTable, PetImage>),
    PetImage,
    PrefetchHooks Function()>;
typedef $$HealthEventsTableCreateCompanionBuilder = HealthEventsCompanion
    Function({
  Value<int> id,
  required int petId,
  required String type,
  required String title,
  Value<String?> description,
  required DateTime eventDate,
  Value<DateTime?> nextDueDate,
  Value<String?> frequency,
  Value<String?> dosage,
  Value<String?> vetName,
  Value<String?> vetContact,
  Value<double?> cost,
  Value<String?> attachments,
});
typedef $$HealthEventsTableUpdateCompanionBuilder = HealthEventsCompanion
    Function({
  Value<int> id,
  Value<int> petId,
  Value<String> type,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> eventDate,
  Value<DateTime?> nextDueDate,
  Value<String?> frequency,
  Value<String?> dosage,
  Value<String?> vetName,
  Value<String?> vetContact,
  Value<double?> cost,
  Value<String?> attachments,
});

class $$HealthEventsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthEventsTable> {
  $$HealthEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
      column: $table.eventDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vetName => $composableBuilder(
      column: $table.vetName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vetContact => $composableBuilder(
      column: $table.vetContact, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnFilters(column));
}

class $$HealthEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthEventsTable> {
  $$HealthEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
      column: $table.eventDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vetName => $composableBuilder(
      column: $table.vetName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vetContact => $composableBuilder(
      column: $table.vetContact, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnOrderings(column));
}

class $$HealthEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthEventsTable> {
  $$HealthEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get vetName =>
      $composableBuilder(column: $table.vetName, builder: (column) => column);

  GeneratedColumn<String> get vetContact => $composableBuilder(
      column: $table.vetContact, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => column);
}

class $$HealthEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HealthEventsTable,
    HealthEvent,
    $$HealthEventsTableFilterComposer,
    $$HealthEventsTableOrderingComposer,
    $$HealthEventsTableAnnotationComposer,
    $$HealthEventsTableCreateCompanionBuilder,
    $$HealthEventsTableUpdateCompanionBuilder,
    (
      HealthEvent,
      BaseReferences<_$AppDatabase, $HealthEventsTable, HealthEvent>
    ),
    HealthEvent,
    PrefetchHooks Function()> {
  $$HealthEventsTableTableManager(_$AppDatabase db, $HealthEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> eventDate = const Value.absent(),
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<String?> frequency = const Value.absent(),
            Value<String?> dosage = const Value.absent(),
            Value<String?> vetName = const Value.absent(),
            Value<String?> vetContact = const Value.absent(),
            Value<double?> cost = const Value.absent(),
            Value<String?> attachments = const Value.absent(),
          }) =>
              HealthEventsCompanion(
            id: id,
            petId: petId,
            type: type,
            title: title,
            description: description,
            eventDate: eventDate,
            nextDueDate: nextDueDate,
            frequency: frequency,
            dosage: dosage,
            vetName: vetName,
            vetContact: vetContact,
            cost: cost,
            attachments: attachments,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            required String type,
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime eventDate,
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<String?> frequency = const Value.absent(),
            Value<String?> dosage = const Value.absent(),
            Value<String?> vetName = const Value.absent(),
            Value<String?> vetContact = const Value.absent(),
            Value<double?> cost = const Value.absent(),
            Value<String?> attachments = const Value.absent(),
          }) =>
              HealthEventsCompanion.insert(
            id: id,
            petId: petId,
            type: type,
            title: title,
            description: description,
            eventDate: eventDate,
            nextDueDate: nextDueDate,
            frequency: frequency,
            dosage: dosage,
            vetName: vetName,
            vetContact: vetContact,
            cost: cost,
            attachments: attachments,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HealthEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HealthEventsTable,
    HealthEvent,
    $$HealthEventsTableFilterComposer,
    $$HealthEventsTableOrderingComposer,
    $$HealthEventsTableAnnotationComposer,
    $$HealthEventsTableCreateCompanionBuilder,
    $$HealthEventsTableUpdateCompanionBuilder,
    (
      HealthEvent,
      BaseReferences<_$AppDatabase, $HealthEventsTable, HealthEvent>
    ),
    HealthEvent,
    PrefetchHooks Function()>;
typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  Value<int> id,
  required int petId,
  required String name,
  Value<String?> dosage,
  Value<String?> frequency,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<String?> notes,
  Value<bool> active,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<int> id,
  Value<int> petId,
  Value<String> name,
  Value<String?> dosage,
  Value<String?> frequency,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String?> notes,
  Value<bool> active,
});

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, BaseReferences<_$AppDatabase, $MedicationsTable, Medication>),
    Medication,
    PrefetchHooks Function()> {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> dosage = const Value.absent(),
            Value<String?> frequency = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> active = const Value.absent(),
          }) =>
              MedicationsCompanion(
            id: id,
            petId: petId,
            name: name,
            dosage: dosage,
            frequency: frequency,
            startDate: startDate,
            endDate: endDate,
            notes: notes,
            active: active,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            required String name,
            Value<String?> dosage = const Value.absent(),
            Value<String?> frequency = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> active = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            id: id,
            petId: petId,
            name: name,
            dosage: dosage,
            frequency: frequency,
            startDate: startDate,
            endDate: endDate,
            notes: notes,
            active: active,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, BaseReferences<_$AppDatabase, $MedicationsTable, Medication>),
    Medication,
    PrefetchHooks Function()>;
typedef $$FoodItemsTableCreateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<int?> petId,
  Value<String> category,
  required String brand,
  required String productName,
  Value<String?> flavor,
  required double totalKg,
  required double remainingKg,
  Value<double?> pricePerKg,
  Value<bool> blacklisted,
  Value<String?> allergyReason,
  required DateTime purchaseDate,
  Value<DateTime?> expireDate,
  Value<String?> notes,
});
typedef $$FoodItemsTableUpdateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<int?> petId,
  Value<String> category,
  Value<String> brand,
  Value<String> productName,
  Value<String?> flavor,
  Value<double> totalKg,
  Value<double> remainingKg,
  Value<double?> pricePerKg,
  Value<bool> blacklisted,
  Value<String?> allergyReason,
  Value<DateTime> purchaseDate,
  Value<DateTime?> expireDate,
  Value<String?> notes,
});

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flavor => $composableBuilder(
      column: $table.flavor, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalKg => $composableBuilder(
      column: $table.totalKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingKg => $composableBuilder(
      column: $table.remainingKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerKg => $composableBuilder(
      column: $table.pricePerKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get blacklisted => $composableBuilder(
      column: $table.blacklisted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergyReason => $composableBuilder(
      column: $table.allergyReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expireDate => $composableBuilder(
      column: $table.expireDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flavor => $composableBuilder(
      column: $table.flavor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalKg => $composableBuilder(
      column: $table.totalKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingKg => $composableBuilder(
      column: $table.remainingKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerKg => $composableBuilder(
      column: $table.pricePerKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get blacklisted => $composableBuilder(
      column: $table.blacklisted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergyReason => $composableBuilder(
      column: $table.allergyReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expireDate => $composableBuilder(
      column: $table.expireDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<String> get flavor =>
      $composableBuilder(column: $table.flavor, builder: (column) => column);

  GeneratedColumn<double> get totalKg =>
      $composableBuilder(column: $table.totalKg, builder: (column) => column);

  GeneratedColumn<double> get remainingKg => $composableBuilder(
      column: $table.remainingKg, builder: (column) => column);

  GeneratedColumn<double> get pricePerKg => $composableBuilder(
      column: $table.pricePerKg, builder: (column) => column);

  GeneratedColumn<bool> get blacklisted => $composableBuilder(
      column: $table.blacklisted, builder: (column) => column);

  GeneratedColumn<String> get allergyReason => $composableBuilder(
      column: $table.allergyReason, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expireDate => $composableBuilder(
      column: $table.expireDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FoodItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodItemsTable,
    FoodInventory,
    $$FoodItemsTableFilterComposer,
    $$FoodItemsTableOrderingComposer,
    $$FoodItemsTableAnnotationComposer,
    $$FoodItemsTableCreateCompanionBuilder,
    $$FoodItemsTableUpdateCompanionBuilder,
    (
      FoodInventory,
      BaseReferences<_$AppDatabase, $FoodItemsTable, FoodInventory>
    ),
    FoodInventory,
    PrefetchHooks Function()> {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> petId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<String?> flavor = const Value.absent(),
            Value<double> totalKg = const Value.absent(),
            Value<double> remainingKg = const Value.absent(),
            Value<double?> pricePerKg = const Value.absent(),
            Value<bool> blacklisted = const Value.absent(),
            Value<String?> allergyReason = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<DateTime?> expireDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              FoodItemsCompanion(
            id: id,
            petId: petId,
            category: category,
            brand: brand,
            productName: productName,
            flavor: flavor,
            totalKg: totalKg,
            remainingKg: remainingKg,
            pricePerKg: pricePerKg,
            blacklisted: blacklisted,
            allergyReason: allergyReason,
            purchaseDate: purchaseDate,
            expireDate: expireDate,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> petId = const Value.absent(),
            Value<String> category = const Value.absent(),
            required String brand,
            required String productName,
            Value<String?> flavor = const Value.absent(),
            required double totalKg,
            required double remainingKg,
            Value<double?> pricePerKg = const Value.absent(),
            Value<bool> blacklisted = const Value.absent(),
            Value<String?> allergyReason = const Value.absent(),
            required DateTime purchaseDate,
            Value<DateTime?> expireDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              FoodItemsCompanion.insert(
            id: id,
            petId: petId,
            category: category,
            brand: brand,
            productName: productName,
            flavor: flavor,
            totalKg: totalKg,
            remainingKg: remainingKg,
            pricePerKg: pricePerKg,
            blacklisted: blacklisted,
            allergyReason: allergyReason,
            purchaseDate: purchaseDate,
            expireDate: expireDate,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FoodItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodItemsTable,
    FoodInventory,
    $$FoodItemsTableFilterComposer,
    $$FoodItemsTableOrderingComposer,
    $$FoodItemsTableAnnotationComposer,
    $$FoodItemsTableCreateCompanionBuilder,
    $$FoodItemsTableUpdateCompanionBuilder,
    (
      FoodInventory,
      BaseReferences<_$AppDatabase, $FoodItemsTable, FoodInventory>
    ),
    FoodInventory,
    PrefetchHooks Function()>;
typedef $$FeedingRecordsTableCreateCompanionBuilder = FeedingRecordsCompanion
    Function({
  Value<int> id,
  required int petId,
  Value<int?> foodId,
  required DateTime fedAt,
  required double amountKg,
  Value<String> mealType,
  Value<String?> notes,
});
typedef $$FeedingRecordsTableUpdateCompanionBuilder = FeedingRecordsCompanion
    Function({
  Value<int> id,
  Value<int> petId,
  Value<int?> foodId,
  Value<DateTime> fedAt,
  Value<double> amountKg,
  Value<String> mealType,
  Value<String?> notes,
});

class $$FeedingRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FeedingRecordsTable> {
  $$FeedingRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get foodId => $composableBuilder(
      column: $table.foodId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fedAt => $composableBuilder(
      column: $table.fedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountKg => $composableBuilder(
      column: $table.amountKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$FeedingRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedingRecordsTable> {
  $$FeedingRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get foodId => $composableBuilder(
      column: $table.foodId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fedAt => $composableBuilder(
      column: $table.fedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountKg => $composableBuilder(
      column: $table.amountKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$FeedingRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedingRecordsTable> {
  $$FeedingRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<DateTime> get fedAt =>
      $composableBuilder(column: $table.fedAt, builder: (column) => column);

  GeneratedColumn<double> get amountKg =>
      $composableBuilder(column: $table.amountKg, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FeedingRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FeedingRecordsTable,
    FeedingRecord,
    $$FeedingRecordsTableFilterComposer,
    $$FeedingRecordsTableOrderingComposer,
    $$FeedingRecordsTableAnnotationComposer,
    $$FeedingRecordsTableCreateCompanionBuilder,
    $$FeedingRecordsTableUpdateCompanionBuilder,
    (
      FeedingRecord,
      BaseReferences<_$AppDatabase, $FeedingRecordsTable, FeedingRecord>
    ),
    FeedingRecord,
    PrefetchHooks Function()> {
  $$FeedingRecordsTableTableManager(
      _$AppDatabase db, $FeedingRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedingRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedingRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedingRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<int?> foodId = const Value.absent(),
            Value<DateTime> fedAt = const Value.absent(),
            Value<double> amountKg = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              FeedingRecordsCompanion(
            id: id,
            petId: petId,
            foodId: foodId,
            fedAt: fedAt,
            amountKg: amountKg,
            mealType: mealType,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            Value<int?> foodId = const Value.absent(),
            required DateTime fedAt,
            required double amountKg,
            Value<String> mealType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              FeedingRecordsCompanion.insert(
            id: id,
            petId: petId,
            foodId: foodId,
            fedAt: fedAt,
            amountKg: amountKg,
            mealType: mealType,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FeedingRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FeedingRecordsTable,
    FeedingRecord,
    $$FeedingRecordsTableFilterComposer,
    $$FeedingRecordsTableOrderingComposer,
    $$FeedingRecordsTableAnnotationComposer,
    $$FeedingRecordsTableCreateCompanionBuilder,
    $$FeedingRecordsTableUpdateCompanionBuilder,
    (
      FeedingRecord,
      BaseReferences<_$AppDatabase, $FeedingRecordsTable, FeedingRecord>
    ),
    FeedingRecord,
    PrefetchHooks Function()>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<int?> petId,
  required DateTime spentAt,
  required double amount,
  required String category,
  Value<String?> description,
  Value<String?> paymentMethod,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<int?> petId,
  Value<DateTime> spentAt,
  Value<double> amount,
  Value<String> category,
  Value<String?> description,
  Value<String?> paymentMethod,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get spentAt => $composableBuilder(
      column: $table.spentAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get spentAt => $composableBuilder(
      column: $table.spentAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<DateTime> get spentAt =>
      $composableBuilder(column: $table.spentAt, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> petId = const Value.absent(),
            Value<DateTime> spentAt = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            petId: petId,
            spentAt: spentAt,
            amount: amount,
            category: category,
            description: description,
            paymentMethod: paymentMethod,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> petId = const Value.absent(),
            required DateTime spentAt,
            required double amount,
            required String category,
            Value<String?> description = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            petId: petId,
            spentAt: spentAt,
            amount: amount,
            category: category,
            description: description,
            paymentMethod: paymentMethod,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$WalkRecordsTableCreateCompanionBuilder = WalkRecordsCompanion
    Function({
  Value<int> id,
  required int petId,
  required DateTime walkedAt,
  required int durationMin,
  Value<double?> distanceKm,
  Value<String?> route,
  Value<String?> notes,
});
typedef $$WalkRecordsTableUpdateCompanionBuilder = WalkRecordsCompanion
    Function({
  Value<int> id,
  Value<int> petId,
  Value<DateTime> walkedAt,
  Value<int> durationMin,
  Value<double?> distanceKm,
  Value<String?> route,
  Value<String?> notes,
});

class $$WalkRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WalkRecordsTable> {
  $$WalkRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get walkedAt => $composableBuilder(
      column: $table.walkedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMin => $composableBuilder(
      column: $table.durationMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get route => $composableBuilder(
      column: $table.route, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$WalkRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalkRecordsTable> {
  $$WalkRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get walkedAt => $composableBuilder(
      column: $table.walkedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMin => $composableBuilder(
      column: $table.durationMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get route => $composableBuilder(
      column: $table.route, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$WalkRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalkRecordsTable> {
  $$WalkRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<DateTime> get walkedAt =>
      $composableBuilder(column: $table.walkedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMin => $composableBuilder(
      column: $table.durationMin, builder: (column) => column);

  GeneratedColumn<double> get distanceKm => $composableBuilder(
      column: $table.distanceKm, builder: (column) => column);

  GeneratedColumn<String> get route =>
      $composableBuilder(column: $table.route, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WalkRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WalkRecordsTable,
    WalkRecord,
    $$WalkRecordsTableFilterComposer,
    $$WalkRecordsTableOrderingComposer,
    $$WalkRecordsTableAnnotationComposer,
    $$WalkRecordsTableCreateCompanionBuilder,
    $$WalkRecordsTableUpdateCompanionBuilder,
    (WalkRecord, BaseReferences<_$AppDatabase, $WalkRecordsTable, WalkRecord>),
    WalkRecord,
    PrefetchHooks Function()> {
  $$WalkRecordsTableTableManager(_$AppDatabase db, $WalkRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalkRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalkRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalkRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<DateTime> walkedAt = const Value.absent(),
            Value<int> durationMin = const Value.absent(),
            Value<double?> distanceKm = const Value.absent(),
            Value<String?> route = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              WalkRecordsCompanion(
            id: id,
            petId: petId,
            walkedAt: walkedAt,
            durationMin: durationMin,
            distanceKm: distanceKm,
            route: route,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            required DateTime walkedAt,
            required int durationMin,
            Value<double?> distanceKm = const Value.absent(),
            Value<String?> route = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              WalkRecordsCompanion.insert(
            id: id,
            petId: petId,
            walkedAt: walkedAt,
            durationMin: durationMin,
            distanceKm: distanceKm,
            route: route,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WalkRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WalkRecordsTable,
    WalkRecord,
    $$WalkRecordsTableFilterComposer,
    $$WalkRecordsTableOrderingComposer,
    $$WalkRecordsTableAnnotationComposer,
    $$WalkRecordsTableCreateCompanionBuilder,
    $$WalkRecordsTableUpdateCompanionBuilder,
    (WalkRecord, BaseReferences<_$AppDatabase, $WalkRecordsTable, WalkRecord>),
    WalkRecord,
    PrefetchHooks Function()>;
typedef $$TrainingLogsTableCreateCompanionBuilder = TrainingLogsCompanion
    Function({
  Value<int> id,
  required int petId,
  required String command,
  Value<int?> durationMin,
  Value<String?> performance,
  required DateTime trainedAt,
  Value<String?> notes,
});
typedef $$TrainingLogsTableUpdateCompanionBuilder = TrainingLogsCompanion
    Function({
  Value<int> id,
  Value<int> petId,
  Value<String> command,
  Value<int?> durationMin,
  Value<String?> performance,
  Value<DateTime> trainedAt,
  Value<String?> notes,
});

class $$TrainingLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingLogsTable> {
  $$TrainingLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMin => $composableBuilder(
      column: $table.durationMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get performance => $composableBuilder(
      column: $table.performance, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get trainedAt => $composableBuilder(
      column: $table.trainedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$TrainingLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingLogsTable> {
  $$TrainingLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMin => $composableBuilder(
      column: $table.durationMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get performance => $composableBuilder(
      column: $table.performance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get trainedAt => $composableBuilder(
      column: $table.trainedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$TrainingLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingLogsTable> {
  $$TrainingLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<int> get durationMin => $composableBuilder(
      column: $table.durationMin, builder: (column) => column);

  GeneratedColumn<String> get performance => $composableBuilder(
      column: $table.performance, builder: (column) => column);

  GeneratedColumn<DateTime> get trainedAt =>
      $composableBuilder(column: $table.trainedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TrainingLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrainingLogsTable,
    TrainingLog,
    $$TrainingLogsTableFilterComposer,
    $$TrainingLogsTableOrderingComposer,
    $$TrainingLogsTableAnnotationComposer,
    $$TrainingLogsTableCreateCompanionBuilder,
    $$TrainingLogsTableUpdateCompanionBuilder,
    (
      TrainingLog,
      BaseReferences<_$AppDatabase, $TrainingLogsTable, TrainingLog>
    ),
    TrainingLog,
    PrefetchHooks Function()> {
  $$TrainingLogsTableTableManager(_$AppDatabase db, $TrainingLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<String> command = const Value.absent(),
            Value<int?> durationMin = const Value.absent(),
            Value<String?> performance = const Value.absent(),
            Value<DateTime> trainedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              TrainingLogsCompanion(
            id: id,
            petId: petId,
            command: command,
            durationMin: durationMin,
            performance: performance,
            trainedAt: trainedAt,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            required String command,
            Value<int?> durationMin = const Value.absent(),
            Value<String?> performance = const Value.absent(),
            required DateTime trainedAt,
            Value<String?> notes = const Value.absent(),
          }) =>
              TrainingLogsCompanion.insert(
            id: id,
            petId: petId,
            command: command,
            durationMin: durationMin,
            performance: performance,
            trainedAt: trainedAt,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrainingLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrainingLogsTable,
    TrainingLog,
    $$TrainingLogsTableFilterComposer,
    $$TrainingLogsTableOrderingComposer,
    $$TrainingLogsTableAnnotationComposer,
    $$TrainingLogsTableCreateCompanionBuilder,
    $$TrainingLogsTableUpdateCompanionBuilder,
    (
      TrainingLog,
      BaseReferences<_$AppDatabase, $TrainingLogsTable, TrainingLog>
    ),
    TrainingLog,
    PrefetchHooks Function()>;
typedef $$TrainingPlansTableCreateCompanionBuilder = TrainingPlansCompanion
    Function({
  Value<int> id,
  required int petId,
  required String title,
  required String command,
  required int targetDays,
  Value<int> dailyMinutes,
  Value<int> progress,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<bool> completed,
  Value<String?> notes,
});
typedef $$TrainingPlansTableUpdateCompanionBuilder = TrainingPlansCompanion
    Function({
  Value<int> id,
  Value<int> petId,
  Value<String> title,
  Value<String> command,
  Value<int> targetDays,
  Value<int> dailyMinutes,
  Value<int> progress,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<bool> completed,
  Value<String?> notes,
});

class $$TrainingPlansTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetDays => $composableBuilder(
      column: $table.targetDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailyMinutes => $composableBuilder(
      column: $table.dailyMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$TrainingPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get petId => $composableBuilder(
      column: $table.petId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get command => $composableBuilder(
      column: $table.command, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetDays => $composableBuilder(
      column: $table.targetDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailyMinutes => $composableBuilder(
      column: $table.dailyMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$TrainingPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get petId =>
      $composableBuilder(column: $table.petId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get command =>
      $composableBuilder(column: $table.command, builder: (column) => column);

  GeneratedColumn<int> get targetDays => $composableBuilder(
      column: $table.targetDays, builder: (column) => column);

  GeneratedColumn<int> get dailyMinutes => $composableBuilder(
      column: $table.dailyMinutes, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TrainingPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrainingPlansTable,
    TrainingPlan,
    $$TrainingPlansTableFilterComposer,
    $$TrainingPlansTableOrderingComposer,
    $$TrainingPlansTableAnnotationComposer,
    $$TrainingPlansTableCreateCompanionBuilder,
    $$TrainingPlansTableUpdateCompanionBuilder,
    (
      TrainingPlan,
      BaseReferences<_$AppDatabase, $TrainingPlansTable, TrainingPlan>
    ),
    TrainingPlan,
    PrefetchHooks Function()> {
  $$TrainingPlansTableTableManager(_$AppDatabase db, $TrainingPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> petId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> command = const Value.absent(),
            Value<int> targetDays = const Value.absent(),
            Value<int> dailyMinutes = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              TrainingPlansCompanion(
            id: id,
            petId: petId,
            title: title,
            command: command,
            targetDays: targetDays,
            dailyMinutes: dailyMinutes,
            progress: progress,
            startDate: startDate,
            endDate: endDate,
            completed: completed,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int petId,
            required String title,
            required String command,
            required int targetDays,
            Value<int> dailyMinutes = const Value.absent(),
            Value<int> progress = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              TrainingPlansCompanion.insert(
            id: id,
            petId: petId,
            title: title,
            command: command,
            targetDays: targetDays,
            dailyMinutes: dailyMinutes,
            progress: progress,
            startDate: startDate,
            endDate: endDate,
            completed: completed,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrainingPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrainingPlansTable,
    TrainingPlan,
    $$TrainingPlansTableFilterComposer,
    $$TrainingPlansTableOrderingComposer,
    $$TrainingPlansTableAnnotationComposer,
    $$TrainingPlansTableCreateCompanionBuilder,
    $$TrainingPlansTableUpdateCompanionBuilder,
    (
      TrainingPlan,
      BaseReferences<_$AppDatabase, $TrainingPlansTable, TrainingPlan>
    ),
    TrainingPlan,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$ForbiddenFoodsTableCreateCompanionBuilder = ForbiddenFoodsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> nameEn,
  required String reason,
  required String severity,
});
typedef $$ForbiddenFoodsTableUpdateCompanionBuilder = ForbiddenFoodsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> nameEn,
  Value<String> reason,
  Value<String> severity,
});

class $$ForbiddenFoodsTableFilterComposer
    extends Composer<_$AppDatabase, $ForbiddenFoodsTable> {
  $$ForbiddenFoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));
}

class $$ForbiddenFoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $ForbiddenFoodsTable> {
  $$ForbiddenFoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));
}

class $$ForbiddenFoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ForbiddenFoodsTable> {
  $$ForbiddenFoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);
}

class $$ForbiddenFoodsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ForbiddenFoodsTable,
    ForbiddenFood,
    $$ForbiddenFoodsTableFilterComposer,
    $$ForbiddenFoodsTableOrderingComposer,
    $$ForbiddenFoodsTableAnnotationComposer,
    $$ForbiddenFoodsTableCreateCompanionBuilder,
    $$ForbiddenFoodsTableUpdateCompanionBuilder,
    (
      ForbiddenFood,
      BaseReferences<_$AppDatabase, $ForbiddenFoodsTable, ForbiddenFood>
    ),
    ForbiddenFood,
    PrefetchHooks Function()> {
  $$ForbiddenFoodsTableTableManager(
      _$AppDatabase db, $ForbiddenFoodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ForbiddenFoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ForbiddenFoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ForbiddenFoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> severity = const Value.absent(),
          }) =>
              ForbiddenFoodsCompanion(
            id: id,
            name: name,
            nameEn: nameEn,
            reason: reason,
            severity: severity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> nameEn = const Value.absent(),
            required String reason,
            required String severity,
          }) =>
              ForbiddenFoodsCompanion.insert(
            id: id,
            name: name,
            nameEn: nameEn,
            reason: reason,
            severity: severity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ForbiddenFoodsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ForbiddenFoodsTable,
    ForbiddenFood,
    $$ForbiddenFoodsTableFilterComposer,
    $$ForbiddenFoodsTableOrderingComposer,
    $$ForbiddenFoodsTableAnnotationComposer,
    $$ForbiddenFoodsTableCreateCompanionBuilder,
    $$ForbiddenFoodsTableUpdateCompanionBuilder,
    (
      ForbiddenFood,
      BaseReferences<_$AppDatabase, $ForbiddenFoodsTable, ForbiddenFood>
    ),
    ForbiddenFood,
    PrefetchHooks Function()>;
typedef $$ContactsTableCreateCompanionBuilder = ContactsCompanion Function({
  Value<int> id,
  required String name,
  required String phone,
  Value<String?> address,
  Value<String> type,
  Value<String?> notes,
});
typedef $$ContactsTableUpdateCompanionBuilder = ContactsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> phone,
  Value<String?> address,
  Value<String> type,
  Value<String?> notes,
});

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ContactsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContactsTable,
    Contact,
    $$ContactsTableFilterComposer,
    $$ContactsTableOrderingComposer,
    $$ContactsTableAnnotationComposer,
    $$ContactsTableCreateCompanionBuilder,
    $$ContactsTableUpdateCompanionBuilder,
    (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
    Contact,
    PrefetchHooks Function()> {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              ContactsCompanion(
            id: id,
            name: name,
            phone: phone,
            address: address,
            type: type,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String phone,
            Value<String?> address = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              ContactsCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            address: address,
            type: type,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContactsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContactsTable,
    Contact,
    $$ContactsTableFilterComposer,
    $$ContactsTableOrderingComposer,
    $$ContactsTableAnnotationComposer,
    $$ContactsTableCreateCompanionBuilder,
    $$ContactsTableUpdateCompanionBuilder,
    (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
    Contact,
    PrefetchHooks Function()>;
typedef $$FavoritePlacesTableCreateCompanionBuilder = FavoritePlacesCompanion
    Function({
  Value<int> id,
  required String name,
  required String category,
  Value<String?> address,
  Value<String?> phone,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> amapId,
  Value<int> visitCount,
  Value<DateTime?> lastVisitedAt,
  Value<DateTime> createdAt,
  Value<String?> notes,
});
typedef $$FavoritePlacesTableUpdateCompanionBuilder = FavoritePlacesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
  Value<String?> address,
  Value<String?> phone,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> amapId,
  Value<int> visitCount,
  Value<DateTime?> lastVisitedAt,
  Value<DateTime> createdAt,
  Value<String?> notes,
});

class $$FavoritePlacesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritePlacesTable> {
  $$FavoritePlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amapId => $composableBuilder(
      column: $table.amapId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visitCount => $composableBuilder(
      column: $table.visitCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastVisitedAt => $composableBuilder(
      column: $table.lastVisitedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$FavoritePlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritePlacesTable> {
  $$FavoritePlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amapId => $composableBuilder(
      column: $table.amapId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visitCount => $composableBuilder(
      column: $table.visitCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastVisitedAt => $composableBuilder(
      column: $table.lastVisitedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$FavoritePlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritePlacesTable> {
  $$FavoritePlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get amapId =>
      $composableBuilder(column: $table.amapId, builder: (column) => column);

  GeneratedColumn<int> get visitCount => $composableBuilder(
      column: $table.visitCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastVisitedAt => $composableBuilder(
      column: $table.lastVisitedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FavoritePlacesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritePlacesTable,
    FavoritePlace,
    $$FavoritePlacesTableFilterComposer,
    $$FavoritePlacesTableOrderingComposer,
    $$FavoritePlacesTableAnnotationComposer,
    $$FavoritePlacesTableCreateCompanionBuilder,
    $$FavoritePlacesTableUpdateCompanionBuilder,
    (
      FavoritePlace,
      BaseReferences<_$AppDatabase, $FavoritePlacesTable, FavoritePlace>
    ),
    FavoritePlace,
    PrefetchHooks Function()> {
  $$FavoritePlacesTableTableManager(
      _$AppDatabase db, $FavoritePlacesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritePlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritePlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritePlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> amapId = const Value.absent(),
            Value<int> visitCount = const Value.absent(),
            Value<DateTime?> lastVisitedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              FavoritePlacesCompanion(
            id: id,
            name: name,
            category: category,
            address: address,
            phone: phone,
            latitude: latitude,
            longitude: longitude,
            amapId: amapId,
            visitCount: visitCount,
            lastVisitedAt: lastVisitedAt,
            createdAt: createdAt,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String category,
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> amapId = const Value.absent(),
            Value<int> visitCount = const Value.absent(),
            Value<DateTime?> lastVisitedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              FavoritePlacesCompanion.insert(
            id: id,
            name: name,
            category: category,
            address: address,
            phone: phone,
            latitude: latitude,
            longitude: longitude,
            amapId: amapId,
            visitCount: visitCount,
            lastVisitedAt: lastVisitedAt,
            createdAt: createdAt,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritePlacesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritePlacesTable,
    FavoritePlace,
    $$FavoritePlacesTableFilterComposer,
    $$FavoritePlacesTableOrderingComposer,
    $$FavoritePlacesTableAnnotationComposer,
    $$FavoritePlacesTableCreateCompanionBuilder,
    $$FavoritePlacesTableUpdateCompanionBuilder,
    (
      FavoritePlace,
      BaseReferences<_$AppDatabase, $FavoritePlacesTable, FavoritePlace>
    ),
    FavoritePlace,
    PrefetchHooks Function()>;
typedef $$UserPreferencesTableCreateCompanionBuilder = UserPreferencesCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$UserPreferencesTableUpdateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (
      UserPreference,
      BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>
    ),
    UserPreference,
    PrefetchHooks Function()> {
  $$UserPreferencesTableTableManager(
      _$AppDatabase db, $UserPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (
      UserPreference,
      BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>
    ),
    UserPreference,
    PrefetchHooks Function()>;
typedef $$ExportSettingsTableCreateCompanionBuilder = ExportSettingsCompanion
    Function({
  Value<int> id,
  required String pinHash,
  required String salt,
  Value<bool> enabled,
  Value<DateTime> createdAt,
});
typedef $$ExportSettingsTableUpdateCompanionBuilder = ExportSettingsCompanion
    Function({
  Value<int> id,
  Value<String> pinHash,
  Value<String> salt,
  Value<bool> enabled,
  Value<DateTime> createdAt,
});

class $$ExportSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ExportSettingsTable> {
  $$ExportSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ExportSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExportSettingsTable> {
  $$ExportSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExportSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExportSettingsTable> {
  $$ExportSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExportSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExportSettingsTable,
    ExportSetting,
    $$ExportSettingsTableFilterComposer,
    $$ExportSettingsTableOrderingComposer,
    $$ExportSettingsTableAnnotationComposer,
    $$ExportSettingsTableCreateCompanionBuilder,
    $$ExportSettingsTableUpdateCompanionBuilder,
    (
      ExportSetting,
      BaseReferences<_$AppDatabase, $ExportSettingsTable, ExportSetting>
    ),
    ExportSetting,
    PrefetchHooks Function()> {
  $$ExportSettingsTableTableManager(
      _$AppDatabase db, $ExportSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExportSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExportSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExportSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<String> salt = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExportSettingsCompanion(
            id: id,
            pinHash: pinHash,
            salt: salt,
            enabled: enabled,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String pinHash,
            required String salt,
            Value<bool> enabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExportSettingsCompanion.insert(
            id: id,
            pinHash: pinHash,
            salt: salt,
            enabled: enabled,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExportSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExportSettingsTable,
    ExportSetting,
    $$ExportSettingsTableFilterComposer,
    $$ExportSettingsTableOrderingComposer,
    $$ExportSettingsTableAnnotationComposer,
    $$ExportSettingsTableCreateCompanionBuilder,
    $$ExportSettingsTableUpdateCompanionBuilder,
    (
      ExportSetting,
      BaseReferences<_$AppDatabase, $ExportSettingsTable, ExportSetting>
    ),
    ExportSetting,
    PrefetchHooks Function()>;
typedef $$PoiCacheTableCreateCompanionBuilder = PoiCacheCompanion Function({
  Value<int> id,
  required String amapId,
  required String name,
  required String category,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> description,
  required double latitude,
  required double longitude,
  Value<String?> city,
  Value<String> source,
  Value<int> cloudVersion,
  Value<DateTime?> cloudSyncedAt,
  Value<DateTime> localUpdatedAt,
  Value<String?> submittedBy,
  Value<bool> active,
});
typedef $$PoiCacheTableUpdateCompanionBuilder = PoiCacheCompanion Function({
  Value<int> id,
  Value<String> amapId,
  Value<String> name,
  Value<String> category,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> description,
  Value<double> latitude,
  Value<double> longitude,
  Value<String?> city,
  Value<String> source,
  Value<int> cloudVersion,
  Value<DateTime?> cloudSyncedAt,
  Value<DateTime> localUpdatedAt,
  Value<String?> submittedBy,
  Value<bool> active,
});

class $$PoiCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PoiCacheTable> {
  $$PoiCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amapId => $composableBuilder(
      column: $table.amapId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cloudVersion => $composableBuilder(
      column: $table.cloudVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cloudSyncedAt => $composableBuilder(
      column: $table.cloudSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get submittedBy => $composableBuilder(
      column: $table.submittedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));
}

class $$PoiCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PoiCacheTable> {
  $$PoiCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amapId => $composableBuilder(
      column: $table.amapId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cloudVersion => $composableBuilder(
      column: $table.cloudVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cloudSyncedAt => $composableBuilder(
      column: $table.cloudSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get submittedBy => $composableBuilder(
      column: $table.submittedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$PoiCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PoiCacheTable> {
  $$PoiCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get amapId =>
      $composableBuilder(column: $table.amapId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get cloudVersion => $composableBuilder(
      column: $table.cloudVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get cloudSyncedAt => $composableBuilder(
      column: $table.cloudSyncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get submittedBy => $composableBuilder(
      column: $table.submittedBy, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$PoiCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PoiCacheTable,
    PoiCacheEntry,
    $$PoiCacheTableFilterComposer,
    $$PoiCacheTableOrderingComposer,
    $$PoiCacheTableAnnotationComposer,
    $$PoiCacheTableCreateCompanionBuilder,
    $$PoiCacheTableUpdateCompanionBuilder,
    (
      PoiCacheEntry,
      BaseReferences<_$AppDatabase, $PoiCacheTable, PoiCacheEntry>
    ),
    PoiCacheEntry,
    PrefetchHooks Function()> {
  $$PoiCacheTableTableManager(_$AppDatabase db, $PoiCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PoiCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PoiCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PoiCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> amapId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<int> cloudVersion = const Value.absent(),
            Value<DateTime?> cloudSyncedAt = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<String?> submittedBy = const Value.absent(),
            Value<bool> active = const Value.absent(),
          }) =>
              PoiCacheCompanion(
            id: id,
            amapId: amapId,
            name: name,
            category: category,
            address: address,
            phone: phone,
            description: description,
            latitude: latitude,
            longitude: longitude,
            city: city,
            source: source,
            cloudVersion: cloudVersion,
            cloudSyncedAt: cloudSyncedAt,
            localUpdatedAt: localUpdatedAt,
            submittedBy: submittedBy,
            active: active,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String amapId,
            required String name,
            required String category,
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required double latitude,
            required double longitude,
            Value<String?> city = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<int> cloudVersion = const Value.absent(),
            Value<DateTime?> cloudSyncedAt = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<String?> submittedBy = const Value.absent(),
            Value<bool> active = const Value.absent(),
          }) =>
              PoiCacheCompanion.insert(
            id: id,
            amapId: amapId,
            name: name,
            category: category,
            address: address,
            phone: phone,
            description: description,
            latitude: latitude,
            longitude: longitude,
            city: city,
            source: source,
            cloudVersion: cloudVersion,
            cloudSyncedAt: cloudSyncedAt,
            localUpdatedAt: localUpdatedAt,
            submittedBy: submittedBy,
            active: active,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PoiCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PoiCacheTable,
    PoiCacheEntry,
    $$PoiCacheTableFilterComposer,
    $$PoiCacheTableOrderingComposer,
    $$PoiCacheTableAnnotationComposer,
    $$PoiCacheTableCreateCompanionBuilder,
    $$PoiCacheTableUpdateCompanionBuilder,
    (
      PoiCacheEntry,
      BaseReferences<_$AppDatabase, $PoiCacheTable, PoiCacheEntry>
    ),
    PoiCacheEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
  $$WeightRecordsTableTableManager get weightRecords =>
      $$WeightRecordsTableTableManager(_db, _db.weightRecords);
  $$PetImagesTableTableManager get petImages =>
      $$PetImagesTableTableManager(_db, _db.petImages);
  $$HealthEventsTableTableManager get healthEvents =>
      $$HealthEventsTableTableManager(_db, _db.healthEvents);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$FeedingRecordsTableTableManager get feedingRecords =>
      $$FeedingRecordsTableTableManager(_db, _db.feedingRecords);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$WalkRecordsTableTableManager get walkRecords =>
      $$WalkRecordsTableTableManager(_db, _db.walkRecords);
  $$TrainingLogsTableTableManager get trainingLogs =>
      $$TrainingLogsTableTableManager(_db, _db.trainingLogs);
  $$TrainingPlansTableTableManager get trainingPlans =>
      $$TrainingPlansTableTableManager(_db, _db.trainingPlans);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$ForbiddenFoodsTableTableManager get forbiddenFoods =>
      $$ForbiddenFoodsTableTableManager(_db, _db.forbiddenFoods);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$FavoritePlacesTableTableManager get favoritePlaces =>
      $$FavoritePlacesTableTableManager(_db, _db.favoritePlaces);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$ExportSettingsTableTableManager get exportSettings =>
      $$ExportSettingsTableTableManager(_db, _db.exportSettings);
  $$PoiCacheTableTableManager get poiCache =>
      $$PoiCacheTableTableManager(_db, _db.poiCache);
}
