class BookmarkTagTable {
  static const String tableName = 'bookmark_tag';
  static const String columnId = '_ID';
  static const String columnBookmarkId = 'bookmark_id';
  static const String columnTagId = 'tag_id';
  static const String columnAddedDate = 'added_date';
  static const String indexName = 'bookmark_tag_index';
}

class BookmarkTagQueries {
  static const String createTableBookmarkTag = '''
    CREATE TABLE IF NOT EXISTS ${BookmarkTagTable.tableName} (
      ${BookmarkTagTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${BookmarkTagTable.columnBookmarkId} INTEGER NOT NULL,
      ${BookmarkTagTable.columnTagId} INTEGER NOT NULL,
      ${BookmarkTagTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
  ''';

  static const String createIndexBookmarkTag = '''
    CREATE UNIQUE INDEX IF NOT EXISTS ${BookmarkTagTable.indexName}
    ON ${BookmarkTagTable.tableName} (${BookmarkTagTable.columnBookmarkId}, ${BookmarkTagTable.columnTagId});
  ''';

  static const String getTagIdsForBookmark = '''
    SELECT ${BookmarkTagTable.columnTagId} FROM ${BookmarkTagTable.tableName} WHERE ${BookmarkTagTable.columnBookmarkId} = ? ORDER BY ${BookmarkTagTable.columnTagId} ASC;
  ''';

  static const String addBookmarkTag = '''
    INSERT INTO ${BookmarkTagTable.tableName} (${BookmarkTagTable.columnBookmarkId}, ${BookmarkTagTable.columnTagId}) VALUES(?, ?);
  ''';

  static const String replaceBookmarkTag = '''
    REPLACE INTO ${BookmarkTagTable.tableName} (${BookmarkTagTable.columnBookmarkId}, ${BookmarkTagTable.columnTagId}) VALUES(?, ?);
  ''';

  static const String deleteAll = '''
    DELETE FROM ${BookmarkTagTable.tableName};
  ''';

  static const String deleteByBookmarkIds = '''
    DELETE FROM ${BookmarkTagTable.tableName} WHERE ${BookmarkTagTable.columnBookmarkId} IN ?;
  ''';

  static const String deleteByTagIds = '''
    DELETE FROM ${BookmarkTagTable.tableName} WHERE ${BookmarkTagTable.columnTagId} IN ?;
  ''';

  static const String untag = '''
    DELETE FROM ${BookmarkTagTable.tableName} WHERE ${BookmarkTagTable.columnBookmarkId} = ? AND ${BookmarkTagTable.columnTagId} = ?;
  ''';
}
