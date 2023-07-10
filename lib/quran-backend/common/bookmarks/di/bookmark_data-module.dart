// import 'package:bookmarks_database/last_pages.dart';
// import 'package:context/context.dart';
// import 'package:injectable/injectable.dart';
// import '../sql/bookmarks.dart';
// import 'package:sqlite3/sqlite3.dart';
// import 'package:quran_mobile/data/dao/settings.dart';
// import 'package:quran_mobile/di/app_scope.dart';

// @module
// @LazySingleton()
// @RegisterAs(BookmarkDataModule)
// class BookmarkDataModule {
//   @LazySingleton()
//   @Provides()
//   BookmarksDatabase provideBookmarksDatabase(
//     Context context,
//     Settings settings,
//   ) {
//     final driver = AndroidSqliteDriver(
//       schema: BookmarksDatabase.schema,
//       context: context,
//       name: 'bookmarks.db',
//       callback: AndroidSqliteDriverCallback(
//         BookmarksDatabase.schema,
//         afterVersion: (db, version) async {
//           final lastPage = await settings.lastPage();
//           if (lastPage > -1) {
//             await db.execute(null, 'INSERT INTO last_pages(page) values($lastPage)', 0);
//           }
//         },
//       ),
//     );
//     return BookmarksDatabase(
//       driver,
//       bookmarksAdapter: BookmarksAdapter(),
//       lastPagesAdapter: Last_pagesAdapter(),
//     );
//   }
// }
