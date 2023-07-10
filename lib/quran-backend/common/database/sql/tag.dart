class TagsTable {
  static const String tableName = 'tags';
  static const String columnId = '_ID';
  static const String columnName = 'name';
  static const String columnAddedDate = 'added_date';
}

class TagQueries {
  static const String createTableTags = '''
    CREATE TABLE IF NOT EXISTS ${TagsTable.tableName} (
      ${TagsTable.columnId} INTEGER PRIMARY KEY,
      ${TagsTable.columnName} TEXT NOT NULL,
      ${TagsTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
  ''';

  static const String addTag = '''
    INSERT INTO ${TagsTable.tableName} (${TagsTable.columnName}) VALUES(?);
  ''';

  static const String restoreTag = '''
    INSERT INTO ${TagsTable.tableName} (${TagsTable.columnId}, ${TagsTable.columnName}, ${TagsTable.columnAddedDate}) VALUES(?, ?, ?);
  ''';

  static const String tagByName = '''
    SELECT ${TagsTable.columnId}, ${TagsTable.columnName}, ${TagsTable.columnAddedDate} FROM ${TagsTable.tableName} WHERE ${TagsTable.columnName} = ?;
  ''';

  static const String updateTag = '''
    UPDATE ${TagsTable.tableName} SET ${TagsTable.columnName} = ? WHERE ${TagsTable.columnId} = ?;
  ''';

  static const String getTags = '''
    SELECT ${TagsTable.columnId}, ${TagsTable.columnName}, ${TagsTable.columnAddedDate} FROM ${TagsTable.tableName} ORDER BY ${TagsTable.columnName} ASC;
  ''';

  static const String deleteAll = '''
    DELETE FROM ${TagsTable.tableName};
  ''';

  static const String deleteByIds = '''
    DELETE FROM ${TagsTable.tableName} WHERE ${TagsTable.columnId} IN ?;
  ''';
}
