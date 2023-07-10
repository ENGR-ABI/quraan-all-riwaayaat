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

class LastPagesTable {
  static const String tableName = 'last_pages';
  static const String columnId = '_ID';
  static const String columnPage = 'page';
  static const String columnAddedDate = 'added_date';
}

class DatabaseMigration {
  static const String bookmarksReplacementTable = 'bookmarks_replacement';
  static const String tagsReplacementTable = 'tags_replacement';
  static const String bookmarkTagReplacementTable = 'bookmark_tag_replacement';
  static const String lastPagesReplacementTable = 'last_pages_replacement';

  static const String migrateBookmarks = '''
    -- bookmarks
    CREATE TABLE IF NOT EXISTS $bookmarksReplacementTable (
      ${BookmarksTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${BookmarksTable.columnSura} INTEGER AS Int,
      ${BookmarksTable.columnAyah} INTEGER AS Int,
      ${BookmarksTable.columnPage} INTEGER AS Int NOT NULL,
      ${BookmarksTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
    
    INSERT INTO $bookmarksReplacementTable
    SELECT ${BookmarksTable.columnId}, ${BookmarksTable.columnSura}, ${BookmarksTable.columnAyah}, ${BookmarksTable.columnPage},
      IFNULL(
        CAST(strftime('%s', ${BookmarksTable.columnAddedDate}) AS INTEGER),
        CAST(strftime('%s', 'now') AS INTEGER)
      )
    FROM ${BookmarksTable.tableName};
    
    DROP TABLE ${BookmarksTable.tableName};
    ALTER TABLE $bookmarksReplacementTable RENAME TO ${BookmarksTable.tableName};
  ''';

  static const String migrateTags = '''
    -- tags
    CREATE TABLE IF NOT EXISTS $tagsReplacementTable (
      ${TagsTable.columnId} INTEGER PRIMARY KEY,
      ${TagsTable.columnName} TEXT NOT NULL,
      ${TagsTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
    
    INSERT INTO $tagsReplacementTable
    SELECT ${TagsTable.columnId}, ${TagsTable.columnName},
      IFNULL(
        CAST(strftime('%s', ${TagsTable.columnAddedDate}) AS INTEGER),
        CAST(strftime('%s', 'now') AS INTEGER)
      )
    FROM ${TagsTable.tableName};
    
    DROP TABLE ${TagsTable.tableName};
    ALTER TABLE $tagsReplacementTable RENAME TO ${TagsTable.tableName};
  ''';

  static const String migrateBookmarkTag = '''
    -- bookmark tags
    CREATE TABLE IF NOT EXISTS $bookmarkTagReplacementTable (
      ${BookmarkTagTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${BookmarkTagTable.columnBookmarkId} INTEGER NOT NULL,
      ${BookmarkTagTable.columnTagId} INTEGER NOT NULL,
      ${BookmarkTagTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
    
    INSERT INTO $bookmarkTagReplacementTable
    SELECT ${BookmarkTagTable.columnId}, ${BookmarkTagTable.columnBookmarkId}, ${BookmarkTagTable.columnTagId},
      IFNULL(
        CAST(strftime('%s', ${BookmarkTagTable.columnAddedDate}) AS INTEGER),
        CAST(strftime('%s', 'now') AS INTEGER)
      )
    FROM ${BookmarkTagTable.tableName};
    
    DROP TABLE ${BookmarkTagTable.tableName};
    ALTER TABLE $bookmarkTagReplacementTable RENAME TO ${BookmarkTagTable.tableName};
    
    -- re-add the index if it doesn't exist
    CREATE UNIQUE INDEX IF NOT EXISTS bookmark_tag_index ON ${BookmarkTagTable.tableName}(${BookmarkTagTable.columnBookmarkId}, ${BookmarkTagTable.columnTagId});
  ''';

  static const String migrateLastPages = '''
    -- last pages
    CREATE TABLE IF NOT EXISTS $lastPagesReplacementTable (
      ${LastPagesTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${LastPagesTable.columnPage} INTEGER AS Int NOT NULL UNIQUE,
      ${LastPagesTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
    
    INSERT INTO $lastPagesReplacementTable
    SELECT ${LastPagesTable.columnId}, ${LastPagesTable.columnPage},
      IFNULL(
        CAST(strftime('%s', ${LastPagesTable.columnAddedDate}) AS INTEGER),
        CAST(strftime('%s', 'now') AS INTEGER)
      )
    FROM ${LastPagesTable.tableName};
    
    DROP TABLE ${LastPagesTable.tableName};
    ALTER TABLE $lastPagesReplacementTable RENAME TO ${LastPagesTable.tableName};
  ''';

  static const String databaseMigration = '''
    $migrateBookmarks
    $migrateTags
    $migrateBookmarkTag
    $migrateLastPages
  ''';
}
