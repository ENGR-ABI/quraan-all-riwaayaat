import 'package:sqlite3/sqlite3.dart';

class DBManager {
  final String dbPath;
  DBManager(this.dbPath);

  ResultSet fetchRecord(String query, [List<Object?> args = const []]) {
    final db = sqlite3.open(dbPath);
    final resultSet = db.select(query, args);
    db.dispose();
    return resultSet;
  }

  bool writeRecord(String sql, [List<Object?> parameters = const []]) {
    try {
      final db = sqlite3.open(dbPath);
      db.execute(sql, parameters);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool writeRecords(String sql,
      [List<Iterable<dynamic>> parameters = const []]) {
    try {
      final db = sqlite3.open(dbPath);
      final stmt = db.prepare(sql);
      for (var params in parameters) {
        stmt.executeWith(StatementParameters(params.toList()));
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
