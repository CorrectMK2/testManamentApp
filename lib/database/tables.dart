import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get completed =>
      boolean().withDefault(const Constant(false))();
}
