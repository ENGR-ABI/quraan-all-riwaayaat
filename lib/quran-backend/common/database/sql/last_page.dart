class LastPagesTable {
  static const String tableName = 'last_pages';
  static const String columnId = '_ID';
  static const String columnPage = 'page';
  static const String columnAddedDate = 'added_date';
}

class LastPagesQueries {
  static const String createTableLastPages = '''
    CREATE TABLE IF NOT EXISTS ${LastPagesTable.tableName} (
      ${LastPagesTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${LastPagesTable.columnPage} INTEGER NOT NULL UNIQUE,
      ${LastPagesTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
  ''';

  static const String addLastPage = '''
    REPLACE INTO ${LastPagesTable.tableName} (${LastPagesTable.columnPage}) VALUES(?);
    DELETE FROM ${LastPagesTable.tableName} WHERE ${LastPagesTable.columnId} NOT IN (
      SELECT ${LastPagesTable.columnId} FROM ${LastPagesTable.tableName} ORDER BY ${LastPagesTable.columnAddedDate} DESC LIMIT ?
    );
  ''';

  static const String removeLastPages = '''
    DELETE FROM ${LastPagesTable.tableName};
  ''';

  static const String replaceRangeWithPage = '''
    DELETE FROM ${LastPagesTable.tableName} WHERE ${LastPagesTable.columnPage} >= ? AND ${LastPagesTable.columnPage} <= ?;
    REPLACE INTO ${LastPagesTable.tableName} (${LastPagesTable.columnPage}) VALUES(?);
    DELETE FROM ${LastPagesTable.tableName} WHERE ${LastPagesTable.columnId} NOT IN (
      SELECT ${LastPagesTable.columnId} FROM ${LastPagesTable.tableName} ORDER BY ${LastPagesTable.columnAddedDate} DESC LIMIT ?
    );
  ''';

  static const String getLastPages = '''
    SELECT ${LastPagesTable.columnId}, ${LastPagesTable.columnPage}, ${LastPagesTable.columnAddedDate} FROM ${LastPagesTable.tableName} ORDER BY ${LastPagesTable.columnAddedDate} DESC;
  ''';
}
