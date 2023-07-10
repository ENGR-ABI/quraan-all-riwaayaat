// ignore_for_file: file_names

class BookmarksTable {
  static const String tableName = 'bookmarks';
  static const String columnId = '_ID';
  static const String columnSura = 'sura';
  static const String columnAyah = 'ayah';
  static const String columnPage = 'page';
  static const String columnAddedDate = 'added_date';
}

class TagsTable {
  static const String tableName = 'tags';
  static const String columnId = '_ID';
  static const String columnName = 'name';
  static const String columnAddedDate = 'added_date';
}

class BookmarkTagTable {
  static const String tableName = 'bookmark_tag';
  static const String columnId = '_ID';
  static const String columnBookmarkId = 'bookmark_id';
  static const String columnTagId = 'tag_id';
  static const String columnAddedDate = 'added_date';
}

class AyahBookmarksTable {
  static const String tableName = 'ayah_bookmarks';
  static const String columnId = '_ID';
  static const String columnPage = 'page';
  static const String columnSura = 'sura';
  static const String columnAyah = 'ayah';
  static const String columnBookmarked = 'bookmarked';
  static const String columnNotes = 'notes';
}

class PageBookmarksTable {
  static const String tableName = 'page_bookmarks';
  static const String columnId = '_ID';
  static const String columnBookmarked = 'bookmarked';
}

class BookmarkQueries {
  static const String dropTableTags = '''
    DROP TABLE IF EXISTS ${TagsTable.tableName};
  ''';

  static const String dropTableAyahTagMap = '''
    DROP TABLE IF EXISTS ayah_tag_map;
  ''';

  static const String createTableBookmarks = '''
    CREATE TABLE IF NOT EXISTS ${BookmarksTable.tableName} (
      ${BookmarksTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${BookmarksTable.columnSura} INTEGER,
      ${BookmarksTable.columnAyah} INTEGER,
      ${BookmarksTable.columnPage} INTEGER NOT NULL,
      ${BookmarksTable.columnAddedDate} INTEGER DEFAULT CURRENT_TIMESTAMP
    );
  ''';

  static const String createTableTags = '''
    CREATE TABLE IF NOT EXISTS ${TagsTable.tableName} (
      ${TagsTable.columnId} INTEGER PRIMARY KEY,
      ${TagsTable.columnName} TEXT NOT NULL,
      ${TagsTable.columnAddedDate} INTEGER DEFAULT CURRENT_TIMESTAMP
    );
  ''';

  static const String createTableBookmarkTag = '''
    CREATE TABLE IF NOT EXISTS ${BookmarkTagTable.tableName} (
      ${BookmarkTagTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${BookmarkTagTable.columnBookmarkId} INTEGER NOT NULL,
      ${BookmarkTagTable.columnTagId} INTEGER NOT NULL,
      ${BookmarkTagTable.columnAddedDate} INTEGER DEFAULT CURRENT_TIMESTAMP
    );
  ''';

  static const String createIndexBookmarkTag = '''
    CREATE UNIQUE INDEX IF NOT EXISTS bookmark_tag_index ON ${BookmarkTagTable.tableName}(${BookmarkTagTable.columnBookmarkId}, ${BookmarkTagTable.columnTagId});
  ''';

  static const String createTableAyahBookmarks = '''
    CREATE TABLE IF NOT EXISTS ${AyahBookmarksTable.tableName} (
      ${AyahBookmarksTable.columnId} INTEGER PRIMARY KEY,
      ${AyahBookmarksTable.columnPage} INTEGER NOT NULL,
      ${AyahBookmarksTable.columnSura} INTEGER NOT NULL,
      ${AyahBookmarksTable.columnAyah} INTEGER NOT NULL,
      ${AyahBookmarksTable.columnBookmarked} INTEGER NOT NULL,
      ${AyahBookmarksTable.columnNotes} TEXT
    );
  ''';

  static const String insertBookmarksFromAyahBookmarks = '''
    INSERT INTO ${BookmarksTable.tableName}(${BookmarksTable.columnId}, ${BookmarksTable.columnSura}, ${BookmarksTable.columnAyah}, ${BookmarksTable.columnPage})
    SELECT ${AyahBookmarksTable.columnId}, ${AyahBookmarksTable.columnSura}, ${AyahBookmarksTable.columnAyah}, ${AyahBookmarksTable.columnPage}
    FROM ${AyahBookmarksTable.tableName} WHERE ${AyahBookmarksTable.columnBookmarked} = 1;
  ''';

  static const String createTablePageBookmarks = '''
    CREATE TABLE IF NOT EXISTS ${PageBookmarksTable.tableName} (
      ${PageBookmarksTable.columnId} INTEGER PRIMARY KEY,
      ${PageBookmarksTable.columnBookmarked} INTEGER NOT NULL
    );
  ''';

  static const String insertBookmarksFromPageBookmarks = '''
    INSERT INTO ${BookmarksTable.tableName}(${BookmarksTable.columnPage})
    SELECT ${PageBookmarksTable.columnId} FROM ${PageBookmarksTable.tableName} WHERE ${PageBookmarksTable.columnBookmarked} = 1;
  ''';

  static const String dropTablePageBookmarks = '''
    DROP TABLE IF EXISTS ${PageBookmarksTable.tableName};
  ''';

  static const String dropTableAyahBookmarks = '''
    DROP TABLE IF EXISTS ${AyahBookmarksTable.tableName};
  ''';

  static const String deleteAllBookmarks = '''
    DELETE FROM ${BookmarksTable.tableName};
  ''';

  static const String deleteBookmarksByIds = '''
    DELETE FROM ${BookmarksTable.tableName} WHERE ${BookmarksTable.columnId} IN ?;
  ''';
}
