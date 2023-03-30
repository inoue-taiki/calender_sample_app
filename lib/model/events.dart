import 'dart:io';  
import 'package:drift/drift.dart';
import 'package:drift/native.dart';  
import 'package:path/path.dart' as p;  
import 'package:path_provider/path_provider.dart';  

part 'events.g.dart';

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get date => dateTime()();
}

@DriftDatabase(tables: [Events])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override 
  int get schemaVersion => 1;
  
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}