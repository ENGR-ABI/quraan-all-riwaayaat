class QuranTypesTable {
  static const String tableName = 'quranTypes';
  static const String columnId = '_ID';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnImages = 'images';
  static const String columnDownloadURL = 'downlaodURL';
  static const String columnIsDownlaoded = 'isDownloaded';
}

class QuranTypesTableQueries {

  static const String createTableQuranTypes = '''
    CREATE TABLE IF NOT EXISTS ${QuranTypesTable.tableName} (
      ${QuranTypesTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${QuranTypesTable.columnTitle} TEXT NOT NULL,
      ${QuranTypesTable.columnDescription} TEXT NOT NULL,
      ${QuranTypesTable.columnImages} TEXT NOT NULL,
      ${QuranTypesTable.columnDownloadURL} TEXT NOT NULL,
      ${QuranTypesTable.columnIsDownlaoded} INTEGER DEFAULT (0) NOT NULL
    );
  ''';

  static const String addQuranType = '''
    INSERT INTO ${QuranTypesTable.tableName} (${QuranTypesTable.columnTitle}, ${QuranTypesTable.columnDescription}, ${QuranTypesTable.columnImages}, ${QuranTypesTable.columnDownloadURL}, ${QuranTypesTable.columnIsDownlaoded}) VALUES(?, ?, ?, ?, ?);
  ''';

  static const String getAllQuranTypes = '''
    SELECT * FROM ${QuranTypesTable.tableName}
  ''';
}
