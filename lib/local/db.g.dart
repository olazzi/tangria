// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $AiRequestTable extends AiRequest
    with drift.TableInfo<$AiRequestTable, AiRequestData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiRequestTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta = const drift.VerificationMeta(
    'id',
  );
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<DateTime> createdAt =
      drift.GeneratedColumn<DateTime>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: drift.currentDateAndTime,
      );
  static const drift.VerificationMeta _modelMeta = const drift.VerificationMeta(
    'model',
  );
  @override
  late final drift.GeneratedColumn<String> model =
      drift.GeneratedColumn<String>(
        'model',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _temperatureMeta =
      const drift.VerificationMeta('temperature');
  @override
  late final drift.GeneratedColumn<double> temperature =
      drift.GeneratedColumn<double>(
        'temperature',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _statusCodeMeta =
      const drift.VerificationMeta('statusCode');
  @override
  late final drift.GeneratedColumn<int> statusCode = drift.GeneratedColumn<int>(
    'status_code',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _latencyMsMeta =
      const drift.VerificationMeta('latencyMs');
  @override
  late final drift.GeneratedColumn<int> latencyMs = drift.GeneratedColumn<int>(
    'latency_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _promptMeta =
      const drift.VerificationMeta('prompt');
  @override
  late final drift.GeneratedColumn<String> prompt =
      drift.GeneratedColumn<String>(
        'prompt',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _errorTextMeta =
      const drift.VerificationMeta('errorText');
  @override
  late final drift.GeneratedColumn<String> errorText =
      drift.GeneratedColumn<String>(
        'error_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _responseTextMeta =
      const drift.VerificationMeta('responseText');
  @override
  late final drift.GeneratedColumn<String> responseText =
      drift.GeneratedColumn<String>(
        'response_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _responseJsonMeta =
      const drift.VerificationMeta('responseJson');
  @override
  late final drift.GeneratedColumn<String> responseJson =
      drift.GeneratedColumn<String>(
        'response_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<drift.GeneratedColumn> get $columns => [
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
  drift.VerificationContext validateIntegrity(
    drift.Insertable<AiRequestData> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {id};
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

class AiRequestData extends drift.DataClass
    implements drift.Insertable<AiRequestData> {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['created_at'] = drift.Variable<DateTime>(createdAt);
    map['model'] = drift.Variable<String>(model);
    map['temperature'] = drift.Variable<double>(temperature);
    map['status_code'] = drift.Variable<int>(statusCode);
    map['latency_ms'] = drift.Variable<int>(latencyMs);
    if (!nullToAbsent || prompt != null) {
      map['prompt'] = drift.Variable<String>(prompt);
    }
    if (!nullToAbsent || errorText != null) {
      map['error_text'] = drift.Variable<String>(errorText);
    }
    if (!nullToAbsent || responseText != null) {
      map['response_text'] = drift.Variable<String>(responseText);
    }
    if (!nullToAbsent || responseJson != null) {
      map['response_json'] = drift.Variable<String>(responseJson);
    }
    return map;
  }

  AiRequestCompanion toCompanion(bool nullToAbsent) {
    return AiRequestCompanion(
      id: drift.Value(id),
      createdAt: drift.Value(createdAt),
      model: drift.Value(model),
      temperature: drift.Value(temperature),
      statusCode: drift.Value(statusCode),
      latencyMs: drift.Value(latencyMs),
      prompt: prompt == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(prompt),
      errorText: errorText == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(errorText),
      responseText: responseText == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(responseText),
      responseJson: responseJson == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(responseJson),
    );
  }

  factory AiRequestData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    drift.Value<String?> prompt = const drift.Value.absent(),
    drift.Value<String?> errorText = const drift.Value.absent(),
    drift.Value<String?> responseText = const drift.Value.absent(),
    drift.Value<String?> responseJson = const drift.Value.absent(),
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

class AiRequestCompanion extends drift.UpdateCompanion<AiRequestData> {
  final drift.Value<String> id;
  final drift.Value<DateTime> createdAt;
  final drift.Value<String> model;
  final drift.Value<double> temperature;
  final drift.Value<int> statusCode;
  final drift.Value<int> latencyMs;
  final drift.Value<String?> prompt;
  final drift.Value<String?> errorText;
  final drift.Value<String?> responseText;
  final drift.Value<String?> responseJson;
  final drift.Value<int> rowid;
  const AiRequestCompanion({
    this.id = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.model = const drift.Value.absent(),
    this.temperature = const drift.Value.absent(),
    this.statusCode = const drift.Value.absent(),
    this.latencyMs = const drift.Value.absent(),
    this.prompt = const drift.Value.absent(),
    this.errorText = const drift.Value.absent(),
    this.responseText = const drift.Value.absent(),
    this.responseJson = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  AiRequestCompanion.insert({
    required String id,
    this.createdAt = const drift.Value.absent(),
    required String model,
    required double temperature,
    required int statusCode,
    required int latencyMs,
    this.prompt = const drift.Value.absent(),
    this.errorText = const drift.Value.absent(),
    this.responseText = const drift.Value.absent(),
    this.responseJson = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : id = drift.Value(id),
       model = drift.Value(model),
       temperature = drift.Value(temperature),
       statusCode = drift.Value(statusCode),
       latencyMs = drift.Value(latencyMs);
  static drift.Insertable<AiRequestData> custom({
    drift.Expression<String>? id,
    drift.Expression<DateTime>? createdAt,
    drift.Expression<String>? model,
    drift.Expression<double>? temperature,
    drift.Expression<int>? statusCode,
    drift.Expression<int>? latencyMs,
    drift.Expression<String>? prompt,
    drift.Expression<String>? errorText,
    drift.Expression<String>? responseText,
    drift.Expression<String>? responseJson,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
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
    drift.Value<String>? id,
    drift.Value<DateTime>? createdAt,
    drift.Value<String>? model,
    drift.Value<double>? temperature,
    drift.Value<int>? statusCode,
    drift.Value<int>? latencyMs,
    drift.Value<String?>? prompt,
    drift.Value<String?>? errorText,
    drift.Value<String?>? responseText,
    drift.Value<String?>? responseJson,
    drift.Value<int>? rowid,
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<DateTime>(createdAt.value);
    }
    if (model.present) {
      map['model'] = drift.Variable<String>(model.value);
    }
    if (temperature.present) {
      map['temperature'] = drift.Variable<double>(temperature.value);
    }
    if (statusCode.present) {
      map['status_code'] = drift.Variable<int>(statusCode.value);
    }
    if (latencyMs.present) {
      map['latency_ms'] = drift.Variable<int>(latencyMs.value);
    }
    if (prompt.present) {
      map['prompt'] = drift.Variable<String>(prompt.value);
    }
    if (errorText.present) {
      map['error_text'] = drift.Variable<String>(errorText.value);
    }
    if (responseText.present) {
      map['response_text'] = drift.Variable<String>(responseText.value);
    }
    if (responseJson.present) {
      map['response_json'] = drift.Variable<String>(responseJson.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
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
    with drift.TableInfo<$AiRequestImageTable, AiRequestImageData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiRequestImageTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta = const drift.VerificationMeta(
    'id',
  );
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _requestIdMeta =
      const drift.VerificationMeta('requestId');
  @override
  late final drift.GeneratedColumn<String> requestId =
      drift.GeneratedColumn<String>(
        'request_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ai_request (id) ON DELETE CASCADE',
        ),
      );
  static const drift.VerificationMeta _idxMeta = const drift.VerificationMeta(
    'idx',
  );
  @override
  late final drift.GeneratedColumn<int> idx = drift.GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _mimeTypeMeta =
      const drift.VerificationMeta('mimeType');
  @override
  late final drift.GeneratedColumn<String> mimeType =
      drift.GeneratedColumn<String>(
        'mime_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const drift.VerificationMeta _pathMeta = const drift.VerificationMeta(
    'path',
  );
  @override
  late final drift.GeneratedColumn<String> path = drift.GeneratedColumn<String>(
    'path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<drift.GeneratedColumn> get $columns => [
    id,
    requestId,
    idx,
    mimeType,
    path,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_request_image';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<AiRequestImageData> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
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
  Set<drift.GeneratedColumn> get $primaryKey => {id};
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

class AiRequestImageData extends drift.DataClass
    implements drift.Insertable<AiRequestImageData> {
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['request_id'] = drift.Variable<String>(requestId);
    map['idx'] = drift.Variable<int>(idx);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = drift.Variable<String>(mimeType);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = drift.Variable<String>(path);
    }
    return map;
  }

  AiRequestImageCompanion toCompanion(bool nullToAbsent) {
    return AiRequestImageCompanion(
      id: drift.Value(id),
      requestId: drift.Value(requestId),
      idx: drift.Value(idx),
      mimeType: mimeType == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(mimeType),
      path: path == null && nullToAbsent
          ? const drift.Value.absent()
          : drift.Value(path),
    );
  }

  factory AiRequestImageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
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
    drift.Value<String?> mimeType = const drift.Value.absent(),
    drift.Value<String?> path = const drift.Value.absent(),
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

class AiRequestImageCompanion
    extends drift.UpdateCompanion<AiRequestImageData> {
  final drift.Value<String> id;
  final drift.Value<String> requestId;
  final drift.Value<int> idx;
  final drift.Value<String?> mimeType;
  final drift.Value<String?> path;
  final drift.Value<int> rowid;
  const AiRequestImageCompanion({
    this.id = const drift.Value.absent(),
    this.requestId = const drift.Value.absent(),
    this.idx = const drift.Value.absent(),
    this.mimeType = const drift.Value.absent(),
    this.path = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  AiRequestImageCompanion.insert({
    required String id,
    required String requestId,
    required int idx,
    this.mimeType = const drift.Value.absent(),
    this.path = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  }) : id = drift.Value(id),
       requestId = drift.Value(requestId),
       idx = drift.Value(idx);
  static drift.Insertable<AiRequestImageData> custom({
    drift.Expression<String>? id,
    drift.Expression<String>? requestId,
    drift.Expression<int>? idx,
    drift.Expression<String>? mimeType,
    drift.Expression<String>? path,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (id != null) 'id': id,
      if (requestId != null) 'request_id': requestId,
      if (idx != null) 'idx': idx,
      if (mimeType != null) 'mime_type': mimeType,
      if (path != null) 'path': path,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiRequestImageCompanion copyWith({
    drift.Value<String>? id,
    drift.Value<String>? requestId,
    drift.Value<int>? idx,
    drift.Value<String?>? mimeType,
    drift.Value<String?>? path,
    drift.Value<int>? rowid,
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
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (requestId.present) {
      map['request_id'] = drift.Variable<String>(requestId.value);
    }
    if (idx.present) {
      map['idx'] = drift.Variable<int>(idx.value);
    }
    if (mimeType.present) {
      map['mime_type'] = drift.Variable<String>(mimeType.value);
    }
    if (path.present) {
      map['path'] = drift.Variable<String>(path.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
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

class $RecommendationTable extends Recommendation
    with drift.TableInfo<$RecommendationTable, RecommendationData> {
  @override
  final drift.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecommendationTable(this.attachedDatabase, [this._alias]);
  static const drift.VerificationMeta _idMeta = const drift.VerificationMeta(
    'id',
  );
  @override
  late final drift.GeneratedColumn<String> id = drift.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _createdAtMeta =
      const drift.VerificationMeta('createdAt');
  @override
  late final drift.GeneratedColumn<DateTime> createdAt =
      drift.GeneratedColumn<DateTime>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: drift.currentDateAndTime,
      );
  static const drift.VerificationMeta _rankMeta = const drift.VerificationMeta(
    'rank',
  );
  @override
  late final drift.GeneratedColumn<int> rank = drift.GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const drift.VerificationMeta _titleMeta = const drift.VerificationMeta(
    'title',
  );
  @override
  late final drift.GeneratedColumn<String> title =
      drift.GeneratedColumn<String>(
        'title',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const drift.VerificationMeta _reasonMeta =
      const drift.VerificationMeta('reason');
  @override
  late final drift.GeneratedColumn<String> reason =
      drift.GeneratedColumn<String>(
        'reason',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<drift.GeneratedColumn> get $columns => [
    id,
    createdAt,
    rank,
    title,
    reason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recommendation';
  @override
  drift.VerificationContext validateIntegrity(
    drift.Insertable<RecommendationData> instance, {
    bool isInserting = false,
  }) {
    final context = drift.VerificationContext();
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
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    return context;
  }

  @override
  Set<drift.GeneratedColumn> get $primaryKey => {id};
  @override
  RecommendationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecommendationData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
    );
  }

  @override
  $RecommendationTable createAlias(String alias) {
    return $RecommendationTable(attachedDatabase, alias);
  }
}

class RecommendationData extends drift.DataClass
    implements drift.Insertable<RecommendationData> {
  final String id;
  final DateTime createdAt;
  final int rank;
  final String title;
  final String reason;
  const RecommendationData({
    required this.id,
    required this.createdAt,
    required this.rank,
    required this.title,
    required this.reason,
  });
  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    map['id'] = drift.Variable<String>(id);
    map['created_at'] = drift.Variable<DateTime>(createdAt);
    map['rank'] = drift.Variable<int>(rank);
    map['title'] = drift.Variable<String>(title);
    map['reason'] = drift.Variable<String>(reason);
    return map;
  }

  RecommendationCompanion toCompanion(bool nullToAbsent) {
    return RecommendationCompanion(
      id: drift.Value(id),
      createdAt: drift.Value(createdAt),
      rank: drift.Value(rank),
      title: drift.Value(title),
      reason: drift.Value(reason),
    );
  }

  factory RecommendationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return RecommendationData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      rank: serializer.fromJson<int>(json['rank']),
      title: serializer.fromJson<String>(json['title']),
      reason: serializer.fromJson<String>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= drift.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'rank': serializer.toJson<int>(rank),
      'title': serializer.toJson<String>(title),
      'reason': serializer.toJson<String>(reason),
    };
  }

  RecommendationData copyWith({
    String? id,
    DateTime? createdAt,
    int? rank,
    String? title,
    String? reason,
  }) => RecommendationData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    rank: rank ?? this.rank,
    title: title ?? this.title,
    reason: reason ?? this.reason,
  );
  RecommendationData copyWithCompanion(RecommendationCompanion data) {
    return RecommendationData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      rank: data.rank.present ? data.rank.value : this.rank,
      title: data.title.present ? data.title.value : this.title,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('rank: $rank, ')
          ..write('title: $title, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, rank, title, reason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecommendationData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.rank == this.rank &&
          other.title == this.title &&
          other.reason == this.reason);
}

class RecommendationCompanion
    extends drift.UpdateCompanion<RecommendationData> {
  final drift.Value<String> id;
  final drift.Value<DateTime> createdAt;
  final drift.Value<int> rank;
  final drift.Value<String> title;
  final drift.Value<String> reason;
  final drift.Value<int> rowid;
  const RecommendationCompanion({
    this.id = const drift.Value.absent(),
    this.createdAt = const drift.Value.absent(),
    this.rank = const drift.Value.absent(),
    this.title = const drift.Value.absent(),
    this.reason = const drift.Value.absent(),
    this.rowid = const drift.Value.absent(),
  });
  RecommendationCompanion.insert({
    required String id,
    this.createdAt = const drift.Value.absent(),
    required int rank,
    required String title,
    required String reason,
    this.rowid = const drift.Value.absent(),
  }) : id = drift.Value(id),
       rank = drift.Value(rank),
       title = drift.Value(title),
       reason = drift.Value(reason);
  static drift.Insertable<RecommendationData> custom({
    drift.Expression<String>? id,
    drift.Expression<DateTime>? createdAt,
    drift.Expression<int>? rank,
    drift.Expression<String>? title,
    drift.Expression<String>? reason,
    drift.Expression<int>? rowid,
  }) {
    return drift.RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (rank != null) 'rank': rank,
      if (title != null) 'title': title,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecommendationCompanion copyWith({
    drift.Value<String>? id,
    drift.Value<DateTime>? createdAt,
    drift.Value<int>? rank,
    drift.Value<String>? title,
    drift.Value<String>? reason,
    drift.Value<int>? rowid,
  }) {
    return RecommendationCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      rank: rank ?? this.rank,
      title: title ?? this.title,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, drift.Expression> toColumns(bool nullToAbsent) {
    final map = <String, drift.Expression>{};
    if (id.present) {
      map['id'] = drift.Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = drift.Variable<DateTime>(createdAt.value);
    }
    if (rank.present) {
      map['rank'] = drift.Variable<int>(rank.value);
    }
    if (title.present) {
      map['title'] = drift.Variable<String>(title.value);
    }
    if (reason.present) {
      map['reason'] = drift.Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = drift.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('rank: $rank, ')
          ..write('title: $title, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends drift.GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $AiRequestTable aiRequest = $AiRequestTable(this);
  late final $AiRequestImageTable aiRequestImage = $AiRequestImageTable(this);
  late final $RecommendationTable recommendation = $RecommendationTable(this);
  @override
  Iterable<drift.TableInfo<drift.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<drift.TableInfo<drift.Table, Object?>>();
  @override
  List<drift.DatabaseSchemaEntity> get allSchemaEntities => [
    aiRequest,
    aiRequestImage,
    recommendation,
  ];
  @override
  drift.StreamQueryUpdateRules get streamUpdateRules =>
      const StreamQueryUpdateRules([
        drift.WritePropagation(
          on: drift.TableUpdateQuery.onTableName(
            'ai_request',
            limitUpdateKind: drift.UpdateKind.delete,
          ),
          result: [
            drift.TableUpdate(
              'ai_request_image',
              kind: drift.UpdateKind.delete,
            ),
          ],
        ),
      ]);
}

typedef $$AiRequestTableCreateCompanionBuilder =
    AiRequestCompanion Function({
      required String id,
      drift.Value<DateTime> createdAt,
      required String model,
      required double temperature,
      required int statusCode,
      required int latencyMs,
      drift.Value<String?> prompt,
      drift.Value<String?> errorText,
      drift.Value<String?> responseText,
      drift.Value<String?> responseJson,
      drift.Value<int> rowid,
    });
typedef $$AiRequestTableUpdateCompanionBuilder =
    AiRequestCompanion Function({
      drift.Value<String> id,
      drift.Value<DateTime> createdAt,
      drift.Value<String> model,
      drift.Value<double> temperature,
      drift.Value<int> statusCode,
      drift.Value<int> latencyMs,
      drift.Value<String?> prompt,
      drift.Value<String?> errorText,
      drift.Value<String?> responseText,
      drift.Value<String?> responseJson,
      drift.Value<int> rowid,
    });

final class $$AiRequestTableReferences
    extends drift.BaseReferences<_$AppDb, $AiRequestTable, AiRequestData> {
  $$AiRequestTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static drift.MultiTypedResultKey<
    $AiRequestImageTable,
    List<AiRequestImageData>
  >
  _aiRequestImageRefsTable(_$AppDb db) => drift.MultiTypedResultKey.fromTable(
    db.aiRequestImage,
    aliasName: drift.$_aliasNameGenerator(
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
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AiRequestTableFilterComposer
    extends drift.Composer<_$AppDb, $AiRequestTable> {
  $$AiRequestTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get errorText => $composableBuilder(
    column: $table.errorText,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.Expression<bool> aiRequestImageRefs(
    drift.Expression<bool> Function($$AiRequestImageTableFilterComposer f) f,
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
    extends drift.Composer<_$AppDb, $AiRequestTable> {
  $$AiRequestTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get errorText => $composableBuilder(
    column: $table.errorText,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$AiRequestTableAnnotationComposer
    extends drift.Composer<_$AppDb, $AiRequestTable> {
  $$AiRequestTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  drift.GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  drift.GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => column,
  );

  drift.GeneratedColumn<int> get latencyMs =>
      $composableBuilder(column: $table.latencyMs, builder: (column) => column);

  drift.GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  drift.GeneratedColumn<String> get errorText =>
      $composableBuilder(column: $table.errorText, builder: (column) => column);

  drift.GeneratedColumn<String> get responseText => $composableBuilder(
    column: $table.responseText,
    builder: (column) => column,
  );

  drift.GeneratedColumn<String> get responseJson => $composableBuilder(
    column: $table.responseJson,
    builder: (column) => column,
  );

  drift.Expression<T> aiRequestImageRefs<T extends Object>(
    drift.Expression<T> Function($$AiRequestImageTableAnnotationComposer a) f,
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
        drift.RootTableManager<
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
          drift.PrefetchHooks Function({bool aiRequestImageRefs})
        > {
  $$AiRequestTableTableManager(_$AppDb db, $AiRequestTable table)
    : super(
        drift.TableManagerState(
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
                drift.Value<String> id = const drift.Value.absent(),
                drift.Value<DateTime> createdAt = const drift.Value.absent(),
                drift.Value<String> model = const drift.Value.absent(),
                drift.Value<double> temperature = const drift.Value.absent(),
                drift.Value<int> statusCode = const drift.Value.absent(),
                drift.Value<int> latencyMs = const drift.Value.absent(),
                drift.Value<String?> prompt = const drift.Value.absent(),
                drift.Value<String?> errorText = const drift.Value.absent(),
                drift.Value<String?> responseText = const drift.Value.absent(),
                drift.Value<String?> responseJson = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
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
                drift.Value<DateTime> createdAt = const drift.Value.absent(),
                required String model,
                required double temperature,
                required int statusCode,
                required int latencyMs,
                drift.Value<String?> prompt = const drift.Value.absent(),
                drift.Value<String?> errorText = const drift.Value.absent(),
                drift.Value<String?> responseText = const drift.Value.absent(),
                drift.Value<String?> responseJson = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
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
            return drift.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (aiRequestImageRefs) db.aiRequestImage,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (aiRequestImageRefs)
                    await drift.$_getPrefetchedData<
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
    drift.ProcessedTableManager<
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
      drift.PrefetchHooks Function({bool aiRequestImageRefs})
    >;
typedef $$AiRequestImageTableCreateCompanionBuilder =
    AiRequestImageCompanion Function({
      required String id,
      required String requestId,
      required int idx,
      drift.Value<String?> mimeType,
      drift.Value<String?> path,
      drift.Value<int> rowid,
    });
typedef $$AiRequestImageTableUpdateCompanionBuilder =
    AiRequestImageCompanion Function({
      drift.Value<String> id,
      drift.Value<String> requestId,
      drift.Value<int> idx,
      drift.Value<String?> mimeType,
      drift.Value<String?> path,
      drift.Value<int> rowid,
    });

final class $$AiRequestImageTableReferences
    extends
        drift.BaseReferences<
          _$AppDb,
          $AiRequestImageTable,
          AiRequestImageData
        > {
  $$AiRequestImageTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AiRequestTable _requestIdTable(_$AppDb db) =>
      db.aiRequest.createAlias(
        drift.$_aliasNameGenerator(
          db.aiRequestImage.requestId,
          db.aiRequest.id,
        ),
      );

  $$AiRequestTableProcessedTableManager get requestId {
    final $_column = $_itemColumn<String>('request_id')!;

    final manager = $$AiRequestTableTableManager(
      $_db,
      $_db.aiRequest,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requestIdTable($_db));
    if (item == null) return manager;
    return drift.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AiRequestImageTableFilterComposer
    extends drift.Composer<_$AppDb, $AiRequestImageTable> {
  $$AiRequestImageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => drift.ColumnFilters(column),
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
    extends drift.Composer<_$AppDb, $AiRequestImageTable> {
  $$AiRequestImageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get idx => $composableBuilder(
    column: $table.idx,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => drift.ColumnOrderings(column),
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
    extends drift.Composer<_$AppDb, $AiRequestImageTable> {
  $$AiRequestImageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<int> get idx =>
      $composableBuilder(column: $table.idx, builder: (column) => column);

  drift.GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  drift.GeneratedColumn<String> get path =>
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
        drift.RootTableManager<
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
          drift.PrefetchHooks Function({bool requestId})
        > {
  $$AiRequestImageTableTableManager(_$AppDb db, $AiRequestImageTable table)
    : super(
        drift.TableManagerState(
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
                drift.Value<String> id = const drift.Value.absent(),
                drift.Value<String> requestId = const drift.Value.absent(),
                drift.Value<int> idx = const drift.Value.absent(),
                drift.Value<String?> mimeType = const drift.Value.absent(),
                drift.Value<String?> path = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
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
                drift.Value<String?> mimeType = const drift.Value.absent(),
                drift.Value<String?> path = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
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
            return drift.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends drift.TableManagerState<
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
    drift.ProcessedTableManager<
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
      drift.PrefetchHooks Function({bool requestId})
    >;
typedef $$RecommendationTableCreateCompanionBuilder =
    RecommendationCompanion Function({
      required String id,
      drift.Value<DateTime> createdAt,
      required int rank,
      required String title,
      required String reason,
      drift.Value<int> rowid,
    });
typedef $$RecommendationTableUpdateCompanionBuilder =
    RecommendationCompanion Function({
      drift.Value<String> id,
      drift.Value<DateTime> createdAt,
      drift.Value<int> rank,
      drift.Value<String> title,
      drift.Value<String> reason,
      drift.Value<int> rowid,
    });

class $$RecommendationTableFilterComposer
    extends drift.Composer<_$AppDb, $RecommendationTable> {
  $$RecommendationTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => drift.ColumnFilters(column),
  );

  drift.ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => drift.ColumnFilters(column),
  );
}

class $$RecommendationTableOrderingComposer
    extends drift.Composer<_$AppDb, $RecommendationTable> {
  $$RecommendationTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => drift.ColumnOrderings(column),
  );

  drift.ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => drift.ColumnOrderings(column),
  );
}

class $$RecommendationTableAnnotationComposer
    extends drift.Composer<_$AppDb, $RecommendationTable> {
  $$RecommendationTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  drift.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  drift.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  drift.GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  drift.GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  drift.GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);
}

class $$RecommendationTableTableManager
    extends
        drift.RootTableManager<
          _$AppDb,
          $RecommendationTable,
          RecommendationData,
          $$RecommendationTableFilterComposer,
          $$RecommendationTableOrderingComposer,
          $$RecommendationTableAnnotationComposer,
          $$RecommendationTableCreateCompanionBuilder,
          $$RecommendationTableUpdateCompanionBuilder,
          (
            RecommendationData,
            drift.BaseReferences<
              _$AppDb,
              $RecommendationTable,
              RecommendationData
            >,
          ),
          RecommendationData,
          drift.PrefetchHooks Function()
        > {
  $$RecommendationTableTableManager(_$AppDb db, $RecommendationTable table)
    : super(
        drift.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecommendationTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecommendationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecommendationTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                drift.Value<String> id = const drift.Value.absent(),
                drift.Value<DateTime> createdAt = const drift.Value.absent(),
                drift.Value<int> rank = const drift.Value.absent(),
                drift.Value<String> title = const drift.Value.absent(),
                drift.Value<String> reason = const drift.Value.absent(),
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => RecommendationCompanion(
                id: id,
                createdAt: createdAt,
                rank: rank,
                title: title,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                drift.Value<DateTime> createdAt = const drift.Value.absent(),
                required int rank,
                required String title,
                required String reason,
                drift.Value<int> rowid = const drift.Value.absent(),
              }) => RecommendationCompanion.insert(
                id: id,
                createdAt: createdAt,
                rank: rank,
                title: title,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), drift.BaseReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecommendationTableProcessedTableManager =
    drift.ProcessedTableManager<
      _$AppDb,
      $RecommendationTable,
      RecommendationData,
      $$RecommendationTableFilterComposer,
      $$RecommendationTableOrderingComposer,
      $$RecommendationTableAnnotationComposer,
      $$RecommendationTableCreateCompanionBuilder,
      $$RecommendationTableUpdateCompanionBuilder,
      (
        RecommendationData,
        drift.BaseReferences<_$AppDb, $RecommendationTable, RecommendationData>,
      ),
      RecommendationData,
      drift.PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$AiRequestTableTableManager get aiRequest =>
      $$AiRequestTableTableManager(_db, _db.aiRequest);
  $$AiRequestImageTableTableManager get aiRequestImage =>
      $$AiRequestImageTableTableManager(_db, _db.aiRequestImage);
  $$RecommendationTableTableManager get recommendation =>
      $$RecommendationTableTableManager(_db, _db.recommendation);
}
