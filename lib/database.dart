import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
part 'database.g.dart';

class ExpressionRecordItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exp => text()();
  RealColumn get ans => real()();

  @override
  String toString() {
    return "{id: $id, exp: $exp, ans: $ans}";
  }
}

@DriftDatabase(tables: [ExpressionRecordItem])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(join(dbFolder.path, "db.sqlite"));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    print(dbFolder.path);

    return NativeDatabase.createInBackground(file);
  });
}

class DatabaseController {
  DatabaseController._privateConstructor();

  static final AppDatabase database = AppDatabase();
}