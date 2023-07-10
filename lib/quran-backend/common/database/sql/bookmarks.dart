import 'package:quranallriwayat/quran-backend/common/data/model/bookmark/bookmark.dart';
import 'package:sqlite3/sqlite3.dart';

class BookmarksDatabase {
  Future<List<Map<String, dynamic>>> getBookmarksByPage(
      int page,
      Bookmark Function(
              int id, int? sura, int? ayah, int page, int addedDate, int? tagId)
          bookmarkWithTagMapper) async {
    final database = sqlite3.open('db_name');
    final results = database.select(
      '''
      SELECT *
      FROM bookmarks
      WHERE page = ?
    ''',
      [page],
    );

    return results;
  }
}

class BookmarksTable {
  static const String tableName = 'bookmarks';
  static const String columnId = '_ID';
  static const String columnSura = 'sura';
  static const String columnAyah = 'ayah';
  static const String columnPage = 'page';
  static const String columnAddedDate = 'added_date';
}

class BookmarkQueries {
  static const String createTableBookmarks = '''
    CREATE TABLE IF NOT EXISTS ${BookmarksTable.tableName} (
      ${BookmarksTable.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${BookmarksTable.columnSura} INTEGER AS Int,
      ${BookmarksTable.columnAyah} INTEGER AS Int,
      ${BookmarksTable.columnPage} INTEGER AS Int NOT NULL,
      ${BookmarksTable.columnAddedDate} INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
    );
  ''';

  static const String addBookmark = '''
    INSERT INTO ${BookmarksTable.tableName} (${BookmarksTable.columnSura}, ${BookmarksTable.columnAyah}, ${BookmarksTable.columnPage}) VALUES(?, ?, ?);
  ''';

  static const String restoreBookmark = '''
    INSERT INTO ${BookmarksTable.tableName} (${BookmarksTable.columnId}, ${BookmarksTable.columnSura}, ${BookmarksTable.columnAyah}, ${BookmarksTable.columnPage}, ${BookmarksTable.columnAddedDate}) VALUES(?, ?, ?, ?, ?);
  ''';

  static const String updateBookmark = '''
    UPDATE ${BookmarksTable.tableName} SET ${BookmarksTable.columnSura} = ?, ${BookmarksTable.columnAyah} = ?, ${BookmarksTable.columnPage} = ? WHERE ${BookmarksTable.columnId} = ?;
  ''';

  static const String getBookmarksByDateAdded = '''
    SELECT
      bookmarks.${BookmarksTable.columnId},
      bookmarks.${BookmarksTable.columnSura},
      bookmarks.${BookmarksTable.columnAyah},
      bookmarks.${BookmarksTable.columnPage},
      bookmarks.${BookmarksTable.columnAddedDate},
      bookmark_tag.tag_id
    FROM
      ${BookmarksTable.tableName} LEFT JOIN bookmark_tag ON bookmarks.${BookmarksTable.columnId} = bookmark_tag.bookmark_id
    ORDER BY bookmarks.${BookmarksTable.columnAddedDate} DESC;
  ''';

  static const String getBookmarksByLocation = '''
    SELECT
      bookmarks.${BookmarksTable.columnId},
      bookmarks.${BookmarksTable.columnSura},
      bookmarks.${BookmarksTable.columnAyah},
      bookmarks.${BookmarksTable.columnPage},
      bookmarks.${BookmarksTable.columnAddedDate},
      bookmark_tag.tag_id
    FROM
      ${BookmarksTable.tableName} LEFT JOIN bookmark_tag ON bookmarks.${BookmarksTable.columnId} = bookmark_tag.bookmark_id
    ORDER BY bookmarks.${BookmarksTable.columnPage} ASC, bookmarks.${BookmarksTable.columnSura} ASC, bookmarks.${BookmarksTable.columnAyah} ASC;
  ''';

  static const String getBookmarksByPage = '''
    SELECT
      bookmarks.${BookmarksTable.columnId},
      bookmarks.${BookmarksTable.columnSura},
      bookmarks.${BookmarksTable.columnAyah},
      bookmarks.${BookmarksTable.columnPage},
      bookmarks.${BookmarksTable.columnAddedDate},
      bookmark_tag.tag_id
    FROM
      ${BookmarksTable.tableName} LEFT JOIN bookmark_tag ON bookmarks.${BookmarksTable.columnId} = bookmark_tag.bookmark_id
    WHERE
      ${BookmarksTable.columnPage} = ? AND ${BookmarksTable.columnSura} IS NOT NULL AND ${BookmarksTable.columnAyah} IS NOT NULL
    ORDER BY bookmarks.${BookmarksTable.columnPage} ASC, bookmarks.${BookmarksTable.columnSura} ASC, bookmarks.${BookmarksTable.columnAyah} ASC;
  ''';

  static const String getBookmarkIdForPage = '''
    SELECT ${BookmarksTable.columnId} FROM ${BookmarksTable.tableName}
    WHERE ${BookmarksTable.columnPage} = ?
    AND ${BookmarksTable.columnSura} IS NULL
    AND ${BookmarksTable.columnAyah} IS NULL;
  ''';

  static const String getBookmarkIdForSuraAyah = '''
    SELECT ${BookmarksTable.columnId} FROM ${BookmarksTable.tableName}
    WHERE ${BookmarksTable.columnSura} = ?
    AND ${BookmarksTable.columnAyah} = ?;
  ''';

  static const String deleteAll = '''
    DELETE FROM ${BookmarksTable.tableName};
  ''';

  static const String deleteByIds = '''
    DELETE FROM ${BookmarksTable.tableName} WHERE ${BookmarksTable.columnId} IN ?;
  ''';
}
