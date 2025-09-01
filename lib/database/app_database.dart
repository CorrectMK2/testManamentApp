import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
//追加
  Future<int> addTask(String title)  {
    return into(tasks).insert(TasksCompanion.insert(title: title));
  }

  Future<List<Task>> getTask(){
    return select(tasks).get();
  }
  // class AppDatabase extends _$AppDatabase { ... } の“中”に追加
  Future<List<Task>> getTasks() {
    return (select(tasks)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
  }
//taskの総数
  Future<int> countTasks() async {
    final c = tasks.id.count();
    final row = await (selectOnly(tasks)..addColumns([c])).getSingle();
    return row.read(c) ?? 0;
  }
  //全削除
  Future<int> deleteAll() {
    return delete(tasks).go();
  }
// Read: 1件（なければ null）
  Future<Task?> getTaskById(int id) {
    return (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
// 変更をリアルタイム監視（UIと相性◎）
  Stream<List<Task>> watchAllTasks() {
    return (select(tasks)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'db.sqlite')); // DBファイルをここに作る
    return NativeDatabase(file);
  });
}
