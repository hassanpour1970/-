import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'database.g.dart';

const _uuid = Uuid();
String newId() => _uuid.v4();

@DriftDatabase(tables: [
  FormTemplates,
  TemplateVersions,
  TemplateSections,
  TemplateFields,
  Dealerships,
  Inspectors,
  FilledForms,
  FieldAnswers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        // مهاجرت‌های بعدی:
        // onUpgrade: (m, from, to) async { if (from < 2) {...} },
      );

  // ---------- بازرس ----------
  Future<Inspector?> getInspector() => select(inspectors).getSingleOrNull();

  Future<void> saveInspector(InspectorsCompanion data) async {
    await transaction(() async {
      await delete(inspectors).go();
      await into(inspectors).insert(data);
    });
  }

  // ---------- قالب‌ها ----------
  Stream<List<FormTemplate>> watchTemplates() => (select(formTemplates)
        ..where((t) => t.isArchived.equals(false))
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();
}

/// پوشه‌ی داده‌ها (دیتابیس + تصاویر + امضاها)؛ مبنای بک‌آپ
Future<Directory> appDataDir() async {
  final base = await getApplicationDocumentsDirectory();
  final dir = Directory(p.join(base.path, 'dealer_audit'));
  if (!await dir.exists()) await dir.create(recursive: true);
  return dir;
}

LazyDatabase _open() => LazyDatabase(() async {
      final dir = await appDataDir();
      return NativeDatabase.createInBackground(
          File(p.join(dir.path, 'db.sqlite')));
    });
