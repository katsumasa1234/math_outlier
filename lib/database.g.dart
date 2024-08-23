// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExpressionRecordItemTable extends ExpressionRecordItem
    with TableInfo<$ExpressionRecordItemTable, ExpressionRecordItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpressionRecordItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<String> exp = GeneratedColumn<String>(
      'exp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ansMeta = const VerificationMeta('ans');
  @override
  late final GeneratedColumn<double> ans = GeneratedColumn<double>(
      'ans', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, exp, ans];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expression_record_item';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExpressionRecordItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exp')) {
      context.handle(
          _expMeta, exp.isAcceptableOrUnknown(data['exp']!, _expMeta));
    } else if (isInserting) {
      context.missing(_expMeta);
    }
    if (data.containsKey('ans')) {
      context.handle(
          _ansMeta, ans.isAcceptableOrUnknown(data['ans']!, _ansMeta));
    } else if (isInserting) {
      context.missing(_ansMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpressionRecordItemData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpressionRecordItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exp'])!,
      ans: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ans'])!,
    );
  }

  @override
  $ExpressionRecordItemTable createAlias(String alias) {
    return $ExpressionRecordItemTable(attachedDatabase, alias);
  }
}

class ExpressionRecordItemData extends DataClass
    implements Insertable<ExpressionRecordItemData> {
  final int id;
  final String exp;
  final double ans;
  const ExpressionRecordItemData(
      {required this.id, required this.exp, required this.ans});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exp'] = Variable<String>(exp);
    map['ans'] = Variable<double>(ans);
    return map;
  }

  ExpressionRecordItemCompanion toCompanion(bool nullToAbsent) {
    return ExpressionRecordItemCompanion(
      id: Value(id),
      exp: Value(exp),
      ans: Value(ans),
    );
  }

  factory ExpressionRecordItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpressionRecordItemData(
      id: serializer.fromJson<int>(json['id']),
      exp: serializer.fromJson<String>(json['exp']),
      ans: serializer.fromJson<double>(json['ans']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exp': serializer.toJson<String>(exp),
      'ans': serializer.toJson<double>(ans),
    };
  }

  ExpressionRecordItemData copyWith({int? id, String? exp, double? ans}) =>
      ExpressionRecordItemData(
        id: id ?? this.id,
        exp: exp ?? this.exp,
        ans: ans ?? this.ans,
      );
  ExpressionRecordItemData copyWithCompanion(
      ExpressionRecordItemCompanion data) {
    return ExpressionRecordItemData(
      id: data.id.present ? data.id.value : this.id,
      exp: data.exp.present ? data.exp.value : this.exp,
      ans: data.ans.present ? data.ans.value : this.ans,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpressionRecordItemData(')
          ..write('id: $id, ')
          ..write('exp: $exp, ')
          ..write('ans: $ans')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exp, ans);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpressionRecordItemData &&
          other.id == this.id &&
          other.exp == this.exp &&
          other.ans == this.ans);
}

class ExpressionRecordItemCompanion
    extends UpdateCompanion<ExpressionRecordItemData> {
  final Value<int> id;
  final Value<String> exp;
  final Value<double> ans;
  const ExpressionRecordItemCompanion({
    this.id = const Value.absent(),
    this.exp = const Value.absent(),
    this.ans = const Value.absent(),
  });
  ExpressionRecordItemCompanion.insert({
    this.id = const Value.absent(),
    required String exp,
    required double ans,
  })  : exp = Value(exp),
        ans = Value(ans);
  static Insertable<ExpressionRecordItemData> custom({
    Expression<int>? id,
    Expression<String>? exp,
    Expression<double>? ans,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exp != null) 'exp': exp,
      if (ans != null) 'ans': ans,
    });
  }

  ExpressionRecordItemCompanion copyWith(
      {Value<int>? id, Value<String>? exp, Value<double>? ans}) {
    return ExpressionRecordItemCompanion(
      id: id ?? this.id,
      exp: exp ?? this.exp,
      ans: ans ?? this.ans,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exp.present) {
      map['exp'] = Variable<String>(exp.value);
    }
    if (ans.present) {
      map['ans'] = Variable<double>(ans.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpressionRecordItemCompanion(')
          ..write('id: $id, ')
          ..write('exp: $exp, ')
          ..write('ans: $ans')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpressionRecordItemTable expressionRecordItem =
      $ExpressionRecordItemTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [expressionRecordItem];
}

typedef $$ExpressionRecordItemTableCreateCompanionBuilder
    = ExpressionRecordItemCompanion Function({
  Value<int> id,
  required String exp,
  required double ans,
});
typedef $$ExpressionRecordItemTableUpdateCompanionBuilder
    = ExpressionRecordItemCompanion Function({
  Value<int> id,
  Value<String> exp,
  Value<double> ans,
});

class $$ExpressionRecordItemTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ExpressionRecordItemTable> {
  $$ExpressionRecordItemTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get exp => $state.composableBuilder(
      column: $state.table.exp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get ans => $state.composableBuilder(
      column: $state.table.ans,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ExpressionRecordItemTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ExpressionRecordItemTable> {
  $$ExpressionRecordItemTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get exp => $state.composableBuilder(
      column: $state.table.exp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get ans => $state.composableBuilder(
      column: $state.table.ans,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$ExpressionRecordItemTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpressionRecordItemTable,
    ExpressionRecordItemData,
    $$ExpressionRecordItemTableFilterComposer,
    $$ExpressionRecordItemTableOrderingComposer,
    $$ExpressionRecordItemTableCreateCompanionBuilder,
    $$ExpressionRecordItemTableUpdateCompanionBuilder,
    (
      ExpressionRecordItemData,
      BaseReferences<_$AppDatabase, $ExpressionRecordItemTable,
          ExpressionRecordItemData>
    ),
    ExpressionRecordItemData,
    PrefetchHooks Function()> {
  $$ExpressionRecordItemTableTableManager(
      _$AppDatabase db, $ExpressionRecordItemTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ExpressionRecordItemTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ExpressionRecordItemTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> exp = const Value.absent(),
            Value<double> ans = const Value.absent(),
          }) =>
              ExpressionRecordItemCompanion(
            id: id,
            exp: exp,
            ans: ans,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String exp,
            required double ans,
          }) =>
              ExpressionRecordItemCompanion.insert(
            id: id,
            exp: exp,
            ans: ans,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpressionRecordItemTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ExpressionRecordItemTable,
        ExpressionRecordItemData,
        $$ExpressionRecordItemTableFilterComposer,
        $$ExpressionRecordItemTableOrderingComposer,
        $$ExpressionRecordItemTableCreateCompanionBuilder,
        $$ExpressionRecordItemTableUpdateCompanionBuilder,
        (
          ExpressionRecordItemData,
          BaseReferences<_$AppDatabase, $ExpressionRecordItemTable,
              ExpressionRecordItemData>
        ),
        ExpressionRecordItemData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpressionRecordItemTableTableManager get expressionRecordItem =>
      $$ExpressionRecordItemTableTableManager(_db, _db.expressionRecordItem);
}
