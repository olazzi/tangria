import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

class AiRequest extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get model => text()();
  RealColumn get temperature => real()();
  IntColumn get statusCode => integer()();
  IntColumn get latencyMs => integer()();
  TextColumn get prompt => text().nullable()();
  TextColumn get errorText => text().nullable()();
  TextColumn get responseText => text().nullable()();
  TextColumn get responseJson => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class AiRequestImage extends Table {
  TextColumn get id => text()();
  TextColumn get requestId => text().references(AiRequest, #id, onDelete: KeyAction.cascade)();
  IntColumn get idx => integer()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get path => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [AiRequest, AiRequestImage])
class AppDb extends _$AppDb {
  AppDb._(super.e);
  static AppDb? _instance;
  static Future<AppDb> instance() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationSupportDirectory();
    final dbDir = Directory(p.join(dir.path, 'app_data', 'database'));
    await dbDir.create(recursive: true);
    final file = File(p.join(dbDir.path, 'tangria.db'));
    final db = NativeDatabase.createInBackground(file);
    _instance = AppDb._(db);
    return _instance!;
  }

  @override
  int get schemaVersion => 1;

  Future<String> insertRequest({
    required String id,
    required String model,
    required double temperature,
    required int statusCode,
    required int latencyMs,
    String? prompt,
    String? errorText,
    String? responseText,
    String? responseJson,
  }) async {
    await into(aiRequest).insert(AiRequestCompanion.insert(
      id: id,
      model: model,
      temperature: temperature,
      statusCode: statusCode,
      latencyMs: latencyMs,
      prompt: Value(prompt),
      errorText: Value(errorText),
      responseText: Value(responseText),
      responseJson: Value(responseJson),
    ));
    return id;
  }

  Future<void> insertImages(String requestId, List<AiRequestImageCompanion> items) async {
    await batch((b) => b.insertAll(aiRequestImage, items));
  }

  Future<List<AiRequestData>> listRequests({int limit = 50}) {
    return (select(aiRequest)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])..limit(limit)).get();
  }

  Future<List<AiRequestImageData>> imagesOf(String requestId) {
    return (select(aiRequestImage)..where((t) => t.requestId.equals(requestId))..orderBy([(t) => OrderingTerm.asc(t.idx)])).get();
  }

  Future<void> deleteRequest(String id) async {
    await (delete(aiRequest)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateRequestResponseJson(String id, String responseJson) async {
  await (update(aiRequest)..where((t) => t.id.equals(id))).write(
    AiRequestCompanion(responseJson: drift.Value(responseJson)),
  );
}

}
