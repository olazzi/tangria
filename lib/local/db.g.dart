// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $AiRequestTable extends AiRequest
    with TableInfo<$AiRequestTable, AiRequestData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiRequestTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusCodeMeta = const VerificationMeta(
    'statusCode',
  );
  @override
  late final GeneratedColumn<int> statusCode = GeneratedColumn<int>(
    'status_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latencyMsMeta = const VerificationMeta(
    'latencyMs',
  );
  @override
  late final GeneratedColumn<int> latencyMs = GeneratedColumn<int>(
    'latency_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorTextMeta = const VerificationMeta(
    'errorText',
  );
  @override
  late final GeneratedColumn<String> errorText = GeneratedColumn<String>(
    'error_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _responseTextMeta = const VerificationMeta(
    'responseText',
  );
  @override
  late final GeneratedColumn<String> responseText = GeneratedColumn<String>(
    'response_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _responseJsonMeta = const VerificationMeta(
    'responseJson',
  );
  @override
  late final GeneratedColumn<String> responseJson = GeneratedColumn<String>(
    'response_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    model,
    temperature,
    statusCode,
    latencyMs,
    prompt,
    errorText,
    responseText,
    responseJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_request';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiRequestData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('status_code')) {
      context.handle(
        _statusCodeMeta,
        statusCode.isAcceptableOrUnknown(data['status_code']!, _statusCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_statusCodeMeta);
    }
    if (data.containsKey('latency_ms')) {
      context.handle(
        _latencyMsMeta,
        latencyMs.isAcceptableOrUnknown(data['latency_ms']!, _latencyMsMeta),
      );
    } else if (isInserting) {
      context.missing(_latencyMsMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    }
    if (data.containsKey('error_text')) {
      context.handle(
        _errorTextMeta,
        errorText.isAcceptableOrUnknown(data['error_text']!, _errorTextMeta),
      );
    }
    if (data.containsKey('response_text')) {
      context.handle(
        _responseTextMeta,
        responseText.isAcceptableOrUnknown(
          data['response_text']!,
          _responseTextMeta,
        ),
      );
    }
    if (data.containsKey('response_json')) {
      context.handle(
        _responseJsonMeta,
        responseJson.isAcceptableOrUnknown(
          data['response_json']!,
          _responseJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiRequestData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiRequestData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      )!,
      statusCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_code'],
      )!,
      latencyMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}latency_ms'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      ),
      errorText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_text'],
      ),
      responseText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_text'],
      ),
      responseJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_json'],
      ),
    );
  }

  @override
  $AiRequestTable createAlias(String alias) {
    return $AiRequestTable(attachedDatabase, alias);
  }
}

class AiRequestData extends DataClass implements Insertable<AiRequestData> {
  final String id;
  final DateTime createdAt;
  final String model;
  final double temperature;
  final int statusCode;
  final int latencyMs;
  final String? prompt;
  final String? errorText;
  final String? responseText;
  final String? responseJson;
  const AiRequestData({
    required this.id,
    required this.createdAt,
    required this.model,
    required this.temperature,
    required this.statusCode,
    required this.latencyMs,
    this.prompt,
    this.errorText,
    this.responseText,
    this.responseJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['model'] = Variable<String>(model);
    map['temperature'] = Variable<double>(temperature);
    map['status_code'] = Variable<int>(statusCode);
    map['latency_ms'] = Variable<int>(latencyMs);
    if (!nullToAbsent || prompt != null) {
      map['prompt'] = Variable<String>(prompt);
    }
    if (!nullToAbsent || errorText != null) {
      map['error_text'] = Variable<String>(errorText);
    }
    if (!nullToAbsent || responseText != null) {
      map['response_text'] = Variable<String>(responseText);
    }
    if (!nullToAbsent || responseJson != null) {
      map['response_json'] = Variable<String>(responseJson);
    }
    return map;
  }

  AiRequestCompanion toCompanion(bool nullToAbsent) {
    return AiRequestCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      model: Value(model),
      temperature: Value(temperature),
      statusCode: Value(statusCode),
      latencyMs: Value(latencyMs),
      prompt: prompt == null && nullToAbsent
          ? const Value.absent()
          : Value(prompt),
      errorText: errorText == null && nullToAbsent
          ? const Value.absent()
          : Value(errorText),
      responseText: responseText == null && nullToAbsent
          ? const Value.absent()
          : Value(responseText),
      responseJson: responseJson == null && nullToAbsent
          ? const Value.absent()
          : Value(responseJson),
    );
  }

  factory AiRequestData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiRequestData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      model: serializer.fromJson<String>(json['model']),
      temperature: serializer.fromJson<double>(json['temperature']),
      statusCode: serializer.fromJson<int>(json['statusCode']),
      latencyMs: serializer.fromJson<int>(json['latencyMs']),
      prompt: serializer.fromJson<String?>(json['prompt']),
      errorText: serializer.fromJson<String?>(json['errorText']),
      responseText: serializer.fromJson<String?>(json['responseText']),
      responseJson: serializer.fromJson<String?>(json['responseJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'model': serializer.toJson<String>(model),
      'temperature': serializer.toJson<double>(temperature),
      'statusCode': serializer.toJson<int>(statusCode),
      'latencyMs': serializer.toJson<int>(latencyMs),
      'prompt': serializer.toJson<String?>(prompt),
      'errorText': serializer.toJson<String?>(errorText),
      'responseText': serializer.toJson<String?>(responseText),
      'responseJson': serializer.toJson<String?>(responseJson),
    };
  }

  AiRequestData copyWith({
    String? id,
    DateTime? createdAt,
    String? model,
    double? temperature,
    int? statusCode,
    int? latencyMs,
    Value<String?> prompt = const Value.absent(),
    Value<String?> errorText = const Value.absent(),
    Value<String?> responseText = const Value.absent(),
    Value<String?> responseJson = const Value.absent(),
  }) => AiRequestData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    model: model ?? this.model,
    temperature: temperature ?? this.temperature,
    statusCode: statusCode ?? this.statusCode,
    latencyMs: latencyMs ?? this.latencyMs,
    prompt: prompt.present ? prompt.value : this.prompt,
    errorText: errorText.present ? errorText.value : this.errorText,
    responseText: responseText.present ? responseText.value : this.responseText,
    responseJson: responseJson.present ? responseJson.value : this.responseJson,
  );
  AiRequestData copyWithCompanion(AiRequestCompanion data) {
    return AiRequestData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      model: data.model.present ? data.model.value : this.model,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      statusCode: data.statusCode.present
          ? data.statusCode.value
          : this.statusCode,
      latencyMs: data.latencyMs.present ? data.latencyMs.value : this.latencyMs,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      errorText: data.errorText.present ? data.errorText.value : this.errorText,
      responseText: data.responseText.present
          ? data.responseText.value
          : this.responseText,
      responseJson: data.responseJson.present
          ? data.responseJson.value
          : this.responseJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiRequestData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('model: $model, ')
          ..write('temperature: $temperature, ')
          ..write('statusCode: $statusCode, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('prompt: $prompt, ')
          ..write('errorText: $errorText, ')
          ..write('responseText: $responseText, ')
          ..write('responseJson: $responseJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    model,
    temperature,
    statusCode,
    latencyMs,
    prompt,
    errorText,
    responseText,
    responseJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiRequestData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.model == this.model &&
          other.temperature == this.temperature &&
          other.statusCode == this.statusCode &&
          other.latencyMs == this.latencyMs &&
          other.prompt == this.prompt &&
          other.errorText == this.errorText &&
          other.responseText == this.responseText &&
          other.responseJson == this.responseJson);
}

class AiRequestCompanion extends UpdateCompanion<AiRequestData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<String> model;
  final Value<double> temperature;
  final Value<int> statusCode;
  final Value<int> latencyMs;
  final Value<String?> prompt;
  final Value<String?> errorText;
  final Value<String?> responseText;
  final Value<String?> responseJson;
  final Value<int> rowid;
  const AiRequestCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.model = const Value.absent(),
    this.temperature = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.latencyMs = const Value.absent(),
    this.prompt = const Value.absent(),
    this.errorText = const Value.absent(),
    this.responseText = const Value.absent(),
    this.responseJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiRequestCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    required String model,
    required double temperature,
    required int statusCode,
    required int latencyMs,
    this.prompt = const Value.absent(),
    this.errorText = const Value.absent(),
    this.responseText = const Value.absent(),
    this.responseJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       model = Value(model),
       temperature = Value(temperature),
       statusCode = Value(statusCode),
       latencyMs = Value(latencyMs);
  static Insertable<AiRequestData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? model,
    Expression<double>? temperature,
    Expression<int>? statusCode,
    Expression<int>? latencyMs,
    Expression<String>? prompt,
    Expression<String>? errorText,
    Expression<String>? responseText,
    Expression<String>? responseJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (model != null) 'model': model,
      if (temperature != null) 'temperature': temperature,
      if (statusCode != null) 'status_code': statusCode,
      if (latencyMs != null) 'latency_ms': latencyMs,
      if (prompt != null) 'prompt': prompt,
      if (errorText != null) 'error_text': errorText,
      if (responseText != null) 'response_text': responseText,
      if (responseJson != null) 'response_json': responseJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiRequestCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<String>? model,
    Value<double>? temperature,
    Value<int>? statusCode,
    Value<int>? latencyMs,
    Value<String?>? prompt,
    Value<String?>? errorText,
    Value<String?>? responseText,
    Value<String?>? responseJson,
    Value<int>? rowid,
  }) {
    return AiRequestCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      statusCode: statusCode ?? this.statusCode,
      latencyMs: latencyMs ?? this.latencyMs,
      prompt: prompt ?? this.prompt,
      errorText: errorText ?? this.errorText,
      responseText: responseText ?? this.responseText,
      responseJson: responseJson ?? this.responseJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (statusCode.present) {
      map['status_code'] = Variable<int>(statusCode.value);
    }
    if (latencyMs.present) {
      map['latency_ms'] = Variable<int>(latencyMs.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (errorText.present) {
      map['error_text'] = Variable<String>(errorText.value);
    }
    if (responseText.present) {
      map['response_text'] = Variable<String>(responseText.value);
    }
    if (responseJson.present) {
      map['response_json'] = Variable<String>(responseJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiRequestCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('model: $model, ')
          ..write('temperature: $temperature, ')
          ..write('statusCode: $statusCode, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('prompt: $prompt, ')
          ..write('errorText: $errorText, ')
          ..write('responseText: $responseText, ')
          ..write('responseJson: $responseJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiRequestImageTable extends AiRequestImage
    with TableInfo<$AiRequestImageTable, AiRequestImageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiRequestImageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestIdMeta = const VerificationMeta(
    'requestId',
  );
  @override
  late final GeneratedColumn<String> requestId = GeneratedColumn<String>(
    'request_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ai_request (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idxMeta = const VerificationMeta('idx');
  @override
  late final GeneratedColumn<int> idx = GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, requestId, idx, mimeType, path];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_request_image';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiRequestImageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('request_id')) {
      context.handle(
        _requestIdMeta,
        requestId.isAcceptableOrUnknown(data['request_id']!, _requestIdMeta),
      );
    } else if (isInserting) {
      context.missing(_requestIdMeta);
    }
    if (data.containsKey('idx')) {
      context.handle(
        _idxMeta,
        idx.isAcceptableOrUnknown(data['idx']!, _idxMeta),
      );
    } else if (isInserting) {
      context.missing(_idxMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiRequestImageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiRequestImageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      requestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_id'],
      )!,
      idx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idx'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      ),
    );
  }

  @override
  $AiRequestImageTable createAlias(String alias) {
    return $AiRequestImageTable(attachedDatabase, alias);
  }
}

class AiRequestImageData extends DataClass
    implements Insertable<AiRequestImageData> {
  final String id;
  final String requestId;
  final int idx;
  final String? mimeType;
  final String? path;
  const AiRequestImageData({
    required this.id,
    required this.requestId,
    required this.idx,
    this.mimeType,
    this.path,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['request_id'] = Variable<String>(requestId);
    map['idx'] = Variable<int>(idx);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    return map;
  }

  AiRequestImageCompanion toCompanion(bool nullToAbsent) {
    return AiRequestImageCompanion(
      id: Value(id),
      requestId: Value(requestId),
      idx: Value(idx),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
    );
  }

  factory AiRequestImageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiRequestImageData(
      id: serializer.fromJson<String>(json['id']),
      requestId: serializer.fromJson<String>(json['requestId']),
      idx: serializer.fromJson<int>(json['idx']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      path: serializer.fromJson<String?>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'requestId': serializer.toJson<String>(requestId),
      'idx': serializer.toJson<int>(idx),
      'mimeType': serializer.toJson<String?>(mimeType),
      'path': serializer.toJson<String?>(path),
    };
  }

  AiRequestImageData copyWith({
    String? id,
    String? requestId,
    int? idx,
    Value<String?> mimeType = const Value.absent(),
    Value<String?> path = const Value.absent(),
  }) => AiRequestImageData(
    id: id ?? this.id,
    requestId: requestId ?? this.requestId,
    idx: idx ?? this.idx,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    path: path.present ? path.value : this.path,
  );
  AiRequestImageData copyWithCompanion(AiRequestImageCompanion data) {
    return AiRequestImageData(
      id: data.id.present ? data.id.value : this.id,
      requestId: data.requestId.present ? data.requestId.value : this.requestId,
      idx: data.idx.present ? data.idx.value : this.idx,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiRequestImageData(')
          ..write('id: $id, ')
          ..write('requestId: $requestId, ')
          ..write('idx: $idx, ')
          ..write('mimeType: $mimeType, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, requestId, idx, mimeType, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiRequestImageData &&
          other.id == this.id &&
          other.requestId == this.requestId &&
          other.idx == this.idx &&
          other.mimeType == this.mimeType &&
          other.path == this.path);
}

class AiRequestImageCompanion extends UpdateCompanion<AiRequestImageData> {
  final Value<String> id;
  final Value<String> requestId;
  final Value<int> idx;
  final Value<String?> mimeType;
  final Value<String?> path;
  final Value<int> rowid;
  const AiRequestImageCompanion({
    this.id = const Value.absent(),
    this.requestId = const Value.absent(),
    this.idx = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.path = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiRequestImageCompanion.insert({
    required String id,
    required String requestId,
    required int idx,
    this.mimeType = const Value.absent(),
    this.path = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       requestId = Value(requestId),
       idx = Value(idx);
  static Insertable<AiRequestImageData> custom({
    Expression<String>? id,
    Expression<String>? requestId,
    Expression<int>? idx,
    Expression<String>? mimeType,
    Expression<String>? path,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (requestId != null) 'request_id': requestId,
      if (idx != null) 'idx': idx,
      if (mimeType != null) 'mime_type': mimeType,
      if (path != null) 'path': path,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiRequestImageCompanion copyWith({
    Value<String>? id,
    Value<String>? requestId,
    Value<int>? idx,
    Value<String?>? mimeType,
    Value<String?>? path,
    Value<int>? rowid,
  }) {
    return AiRequestImageCompanion(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      idx: idx ?? this.idx,
      mimeType: mimeType ?? this.mimeType,
      path: path ?? this.path,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (requestId.present) {
      map['request_id'] = Variable<String>(requestId.value);
    }
    if (idx.present) {
      map['idx'] = Variable<int>(idx.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiRequestImageCompanion(')
          ..write('id: $id, ')
          ..write('requestId: $requestId, ')
          ..write('idx: $idx, ')
          ..write('mimeType: $mimeType, ')
          ..write('path: $path, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $AiRequestTable aiRequest = $AiRequestTable(this);
  late final $AiRequestImageTable aiRequestImage = $AiRequestImageTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    aiRequest,
    aiRequestImage,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ai_request',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ai_request_image', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AiRequestTableCreateCompanionBuilder =
    AiRequestCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      required String model,
      required double temperature,
      required int statusCode,
      required int latencyMs,
      Value<String?> prompt,
      Value<String?> errorText,
      Value<String?> responseText,
      Value<String?> responseJson,
      Value<int> rowid,
    });
typedef $$AiRequestTableUpdateCompanionBuilder =
    AiRequestCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<String> model,
      Value<double> temperature,
      Value<int> statusCode,
      Value<int> latencyMs,
      Value<String?> prompt,
      Value<String?> errorText,
      Value<String?> responseText,
      Value<String?> responseJson,
      Value<int> rowid,
    });

final class $$AiRequestTableReferences
    extends BaseReferences<_$AppDb, $AiRequestTable, AiRequestData> {
  $$AiRequestTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AiRequestImageTable, List<AiRequestImageData>>
  _aiRequestImageRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.aiRequestImage,
    aliasName: $_aliasNameGenerator(
      db.aiRequest.id,
      db.aiRequestImage.requestId,
    ),
  );

  $$AiRequestImageTableProcessedTableManager get aiRequestImageRefs {
    final manager = $$AiRequestImageTableTableManager(
      $_db,
      $_db.aiRequestImage,
    ).filter((f) => f.requestId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_aiRequestImageRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AiRequestTableFilterComposer
    extends Composer<_$AppDb, $AiRequestTable> {
  $$AiRequestTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorText => $composableBuilder(
    column: $table.errorText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> aiRequestImageRefs(
    Expression<bool> Function($$AiRequestImageTableFilterComposer f) f,
  ) {
    final $$AiRequestImageTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiRequestImage,
      getReferencedColumn: (t) => t.requestId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiRequestImageTableFilterComposer(
            $db: $db,
            $table: $db.aiRequestImage,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AiRequestTableOrderingComposer
    extends Composer<_$AppDb, $AiRequestTable> {
  $$AiRequestTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorText => $composableBuilder(
    column: $table.errorText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiRequestTableAnnotationComposer
    extends Composer<_$AppDb, $AiRequestTable> {
  $$AiRequestTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get latencyMs =>
      $composableBuilder(column: $table.latencyMs, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get errorText =>
      $composableBuilder(column: $table.errorText, builder: (column) => column);

  GeneratedColumn<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => column,
  );

  Expression<T> aiRequestImageRefs<T extends Object>(
    Expression<T> Function($$AiRequestImageTableAnnotationComposer a) f,
  ) {
    final $$AiRequestImageTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiRequestImage,
      getReferencedColumn: (t) => t.requestId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiRequestImageTableAnnotationComposer(
            $db: $db,
            $table: $db.aiRequestImage,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AiRequestTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AiRequestTable,
          AiRequestData,
          $$AiRequestTableFilterComposer,
          $$AiRequestTableOrderingComposer,
          $$AiRequestTableAnnotationComposer,
          $$AiRequestTableCreateCompanionBuilder,
          $$AiRequestTableUpdateCompanionBuilder,
          (AiRequestData, $$AiRequestTableReferences),
          AiRequestData,
          PrefetchHooks Function({bool aiRequestImageRefs})
        > {
  $$AiRequestTableTableManager(_$AppDb db, $AiRequestTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiRequestTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiRequestTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiRequestTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<double> temperature = const Value.absent(),
                Value<int> statusCode = const Value.absent(),
                Value<int> latencyMs = const Value.absent(),
                Value<String?> prompt = const Value.absent(),
                Value<String?> errorText = const Value.absent(),
                Value<String?> responseText = const Value.absent(),
                Value<String?> responseJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiRequestCompanion(
                id: id,
                createdAt: createdAt,
                model: model,
                temperature: temperature,
                statusCode: statusCode,
                latencyMs: latencyMs,
                prompt: prompt,
                errorText: errorText,
                responseText: responseText,
                responseJson: responseJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                required String model,
                required double temperature,
                required int statusCode,
                required int latencyMs,
                Value<String?> prompt = const Value.absent(),
                Value<String?> errorText = const Value.absent(),
                Value<String?> responseText = const Value.absent(),
                Value<String?> responseJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiRequestCompanion.insert(
                id: id,
                createdAt: createdAt,
                model: model,
                temperature: temperature,
                statusCode: statusCode,
                latencyMs: latencyMs,
                prompt: prompt,
                errorText: errorText,
                responseText: responseText,
                responseJson: responseJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AiRequestTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({aiRequestImageRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (aiRequestImageRefs) db.aiRequestImage,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (aiRequestImageRefs)
                    await $_getPrefetchedData<
                      AiRequestData,
                      $AiRequestTable,
                      AiRequestImageData
                    >(
                      currentTable: table,
                      referencedTable: $$AiRequestTableReferences
                          ._aiRequestImageRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AiRequestTableReferences(
                            db,
                            table,
                            p0,
                          ).aiRequestImageRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.requestId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AiRequestTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AiRequestTable,
      AiRequestData,
      $$AiRequestTableFilterComposer,
      $$AiRequestTableOrderingComposer,
      $$AiRequestTableAnnotationComposer,
      $$AiRequestTableCreateCompanionBuilder,
      $$AiRequestTableUpdateCompanionBuilder,
      (AiRequestData, $$AiRequestTableReferences),
      AiRequestData,
      PrefetchHooks Function({bool aiRequestImageRefs})
    >;
typedef $$AiRequestImageTableCreateCompanionBuilder =
    AiRequestImageCompanion Function({
      required String id,
      required String requestId,
      required int idx,
      Value<String?> mimeType,
      Value<String?> path,
      Value<int> rowid,
    });
typedef $$AiRequestImageTableUpdateCompanionBuilder =
    AiRequestImageCompanion Function({
      Value<String> id,
      Value<String> requestId,
      Value<int> idx,
      Value<String?> mimeType,
      Value<String?> path,
      Value<int> rowid,
    });

final class $$AiRequestImageTableReferences
    extends BaseReferences<_$AppDb, $AiRequestImageTable, AiRequestImageData> {
  $$AiRequestImageTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AiRequestTable _requestIdTable(_$AppDb db) =>
      db.aiRequest.createAlias(
        $_aliasNameGenerator(db.aiRequestImage.requestId, db.aiRequest.id),
      );

  $$AiRequestTableProcessedTableManager get requestId {
    final $_column = $_itemColumn<String>('request_id')!;

    final manager = $$AiRequestTableTableManager(
      $_db,
      $_db.aiRequest,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AiRequestImageTableFilterComposer
    extends Composer<_$AppDb, $AiRequestImageTable> {
  $$AiRequestImageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  $$AiRequestTableFilterComposer get requestId {
    final $$AiRequestTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requestId,
      referencedTable: $db.aiRequest,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiRequestTableFilterComposer(
            $db: $db,
            $table: $db.aiRequest,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiRequestImageTableOrderingComposer
    extends Composer<_$AppDb, $AiRequestImageTable> {
  $$AiRequestImageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  $$AiRequestTableOrderingComposer get requestId {
    final $$AiRequestTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requestId,
      referencedTable: $db.aiRequest,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiRequestTableOrderingComposer(
            $db: $db,
            $table: $db.aiRequest,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiRequestImageTableAnnotationComposer
    extends Composer<_$AppDb, $AiRequestImageTable> {
  $$AiRequestImageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get idx =>
      $composableBuilder(column: $table.idx, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  $$AiRequestTableAnnotationComposer get requestId {
    final $$AiRequestTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requestId,
      referencedTable: $db.aiRequest,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiRequestTableAnnotationComposer(
            $db: $db,
            $table: $db.aiRequest,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiRequestImageTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AiRequestImageTable,
          AiRequestImageData,
          $$AiRequestImageTableFilterComposer,
          $$AiRequestImageTableOrderingComposer,
          $$AiRequestImageTableAnnotationComposer,
          $$AiRequestImageTableCreateCompanionBuilder,
          $$AiRequestImageTableUpdateCompanionBuilder,
          (AiRequestImageData, $$AiRequestImageTableReferences),
          AiRequestImageData,
          PrefetchHooks Function({bool requestId})
        > {
  $$AiRequestImageTableTableManager(_$AppDb db, $AiRequestImageTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiRequestImageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiRequestImageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiRequestImageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> requestId = const Value.absent(),
                Value<int> idx = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiRequestImageCompanion(
                id: id,
                requestId: requestId,
                idx: idx,
                mimeType: mimeType,
                path: path,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String requestId,
                required int idx,
                Value<String?> mimeType = const Value.absent(),
                Value<String?> path = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiRequestImageCompanion.insert(
                id: id,
                requestId: requestId,
                idx: idx,
                mimeType: mimeType,
                path: path,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AiRequestImageTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({requestId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (requestId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.requestId,
                                referencedTable: $$AiRequestImageTableReferences
                                    ._requestIdTable(db),
                                referencedColumn:
                                    $$AiRequestImageTableReferences
                                        ._requestIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AiRequestImageTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AiRequestImageTable,
      AiRequestImageData,
      $$AiRequestImageTableFilterComposer,
      $$AiRequestImageTableOrderingComposer,
      $$AiRequestImageTableAnnotationComposer,
      $$AiRequestImageTableCreateCompanionBuilder,
      $$AiRequestImageTableUpdateCompanionBuilder,
      (AiRequestImageData, $$AiRequestImageTableReferences),
      AiRequestImageData,
      PrefetchHooks Function({bool requestId})
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$AiRequestTableTableManager get aiRequest =>
      $$AiRequestTableTableManager(_db, _db.aiRequest);
  $$AiRequestImageTableTableManager get aiRequestImage =>
      $$AiRequestImageTableTableManager(_db, _db.aiRequestImage);
}
